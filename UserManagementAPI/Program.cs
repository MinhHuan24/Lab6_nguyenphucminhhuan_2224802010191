using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using UserManagementAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// 1. Cấu hình kết nối SQL Server thông qua DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddControllers();

// 2. Cấu hình JWT Authentication
var jwtKey = builder.Configuration["Jwt:Key"] ?? throw new InvalidOperationException("Chưa có JWT Key!");
var keyBytes = Encoding.UTF8.GetBytes(jwtKey);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(keyBytes)
    };
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy => policy.RequireRole("Admin"));
    options.AddPolicy("UserOnly", policy => policy.RequireRole("User", "Student"));
});

var app = builder.Build();

// ----- ĐOẠN KHỞI TẠO ĐỂ TỰ ĐỘNG TẠO DATABASE VÀ TÀI KHOẢN ADMIN MẶC ĐỊNH -----
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<AppDbContext>();
    
    context.Database.EnsureCreated();

    // Tự động chèn dữ liệu Admin mẫu nếu chưa có
    if (!context.Users.Any(u => u.Email == "admin@gmail.com"))
    {
        context.Users.AddRange(
            new User { Email = "admin@gmail.com", PasswordHash = "123456", Role = "Admin" },
            new User { Email = "user@gmail.com", PasswordHash = "123456", Role = "User" },
            new User { Email = "student@gmail.com", PasswordHash = "123456", Role = "Student" }
        );
        context.SaveChanges();
    }
}
// -----------------------------------------------------------------------------

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();