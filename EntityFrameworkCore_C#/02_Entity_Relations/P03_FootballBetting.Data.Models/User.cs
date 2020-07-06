using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace P03_FootballBetting.Data.Models
{
    public class User
    {
        public User()
        {
            this.Bets = new HashSet<Bet>();
        }
        public int UserId { get; set; }

        [Required]
        public string Username { get; set; }

        [Required,MaxLength(256)]
        public string Password { get; set; }

        [Required]
        public string Email { get; set; }

        public string Name { get; set; }

        public decimal Balance { get; set; }

        public virtual ICollection<Bet> Bets { get; set; }
    }
}
