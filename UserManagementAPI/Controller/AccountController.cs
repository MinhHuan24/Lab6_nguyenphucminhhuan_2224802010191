using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using UserManagementAPI.Models;

namespace UserManagementAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AccountController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [HttpPost("register")]
        public IActionResult Register([FromBody] LoginModel model)
        {
            if (_context.Users.Any(u => u.Email == model.Email))
                return BadRequest("Email này đã tồn tại.");

            var newUser = new User
            {
                Email = model.Email,
                PasswordHash = model.Password, // Đơn giản hóa cho bài Lab
                Role = "User"
            };

            _context.Users.Add(newUser);
            _context.SaveChanges();
            return Ok(new { message = "Đăng ký thành công" });
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModel model)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == model.Email && u.PasswordHash == model.Password);
            if (user == null)
                return Unauthorized(new { message = "Tài khoản hoặc mật khẩu không chính xác." });

            // Tạo mã Token JWT trả về cho Flutter
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(_config["Jwt:Key"]!);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[] 
                {
                    new Claim(ClaimTypes.Email, user.Email),
                    new Claim(ClaimTypes.Role, user.Role)
                }),
                Expires = DateTime.UtcNow.AddDays(7),
                Issuer = _config["Jwt:Issuer"],
                Audience = _config["Jwt:Audience"],
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return Ok(new { token = tokenHandler.WriteToken(token) });
        }
        [HttpGet("users")]
        public IActionResult GetUsers()
        {
            var users = _context.Users.Select(u => new { id = u.Id.ToString(), email = u.Email, role = new string[] { u.Role } }).ToList();
            return Ok(users);
        }
        [HttpPut("update-role")]
        public IActionResult UpdateRole([FromBody] UpdateRoleModel model)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == model.Email);
            if (user == null)
            {
                return NotFound(new { message = "Không tìm thấy người dùng!" });
            }

            // Cập nhật lại vai trò mới vào cột Role trong DB
            user.Role = model.NewRole;
            _context.SaveChanges();

            return Ok(new { message = "Cập nhật vai trò thành công!" });
        }

        // Class bổ trợ để nhận dữ liệu JSON gửi từ Flutter lên
        public class UpdateRoleModel
        {
            public string Email { get; set; } = string.Empty;
            public string NewRole { get; set; } = string.Empty;
        }
    }
}