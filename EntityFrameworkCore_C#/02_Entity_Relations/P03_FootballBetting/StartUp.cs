using Microsoft.EntityFrameworkCore;
using P03_FootballBetting.Data;

namespace P03_FootballBetting
{
    public class StartUp
    {
        public static void Main(string[] args)
        {
            var db = new FootballBettingContext();
            db.Database.Migrate();

            db.SaveChanges();
        }
    }
}
