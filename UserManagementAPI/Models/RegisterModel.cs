using System.ComponentModel.DataAnnotations;

namespace UserManagementAPI.Models
{
    public class RegisterModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MinLength(6, ErrorMessage = "Mật khẩu tối thiểu phải từ 6 ký tự trở lên.")]
        public string Password { get; set; } = string.Empty;

        public string Phone { get; set; } = string.Empty;
    }
}