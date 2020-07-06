using Microsoft.EntityFrameworkCore;
using P03_FootballBetting.Data.Models;

namespace P03_FootballBetting.Data
{
    public class FootballBettingContext : DbContext
    {
        public FootballBettingContext()
        {
        }

        public FootballBettingContext(DbContextOptions<FootballBettingContext> options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(Configuration.connectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Team>(e =>
            {
                e.Property(t => t.LogoUrl)
                .IsUnicode(false);

                e.HasOne(t => t.PrimaryKitColor)
                .WithMany(c => c.PrimaryKitTeams)
                .HasForeignKey(t => t.PrimaryKitColorId)
                .OnDelete(DeleteBehavior.Restrict);

                e.HasOne(t => t.SecondaryKitColor)
                .WithMany(c => c.SecondaryKitTeams)
                .HasForeignKey(t => t.SecondaryKitColorId)
                .OnDelete(DeleteBehavior.Restrict);

                e.HasOne(t => t.Town)
                .WithMany(t => t.Teams)
                .HasForeignKey(t => t.TownId);
            });

            modelBuilder.Entity<Color>(e =>
            {
                e.Property(c => c.Name)
                .IsUnicode(false);
            });

            modelBuilder.Entity<Town>(e =>
            {
                e.Property(t => t.Name)
                .IsUnicode(false);

                e.HasOne(t => t.Country)
                .WithMany(c => c.Towns)
                .HasForeignKey(t => t.CountryId);
            });

            modelBuilder.Entity<Country>(e =>
            {
                e.Property(c => c.Name)
                .IsUnicode(false);

            });

            modelBuilder.Entity<Player>(e =>
            {
                e.HasOne(p => p.Team)
                .WithMany(t => t.Players)
                .HasForeignKey(p => p.TeamId);

                e.HasOne(p => p.Position)
                .WithMany(pos => pos.Players)
                .HasForeignKey(p => p.PositionId);
            });

            modelBuilder.Entity<Position>(e =>
            {
                e.Property(p => p.Name)
                .IsUnicode(false);
            });

            modelBuilder.Entity<PlayerStatistic>(e =>
            {
                e.HasKey
                (e => new { e.GameId, e.PlayerId });

                e.HasOne(ps => ps.Player)
                .WithMany(p => p.PlayerStatistics)
                .HasForeignKey(ps => ps.PlayerId);

                e.HasOne(ps => ps.Game)
                .WithMany(g => g.PlayerStatistics)
                .HasForeignKey(ps => ps.GameId);
            });

            modelBuilder.Entity<Game>(e =>
            {
                e.Property(g => g.Result)
                .IsUnicode(false);

                e.HasOne(g => g.HomeTeam)
                .WithMany(t => t.HomeGames)
                .HasForeignKey(g => g.HomeTeamId)
                .OnDelete(DeleteBehavior.Restrict);

                e.HasOne(g => g.AwayTeam)
                .WithMany(t => t.AwayGames)
                .HasForeignKey(g => g.AwayTeamId)
                .OnDelete(DeleteBehavior.Restrict);


            });

            modelBuilder.Entity<Bet>(e =>
            {
                e.HasOne(b => b.Game)
                .WithMany(g => g.Bets)
                .HasForeignKey(g => g.GameId);

                e.HasOne(b => b.User)
                .WithMany(u => u.Bets)
                .HasForeignKey(b => b.UserId);
            });

            //TODO
            modelBuilder.Entity<User>(e =>
            {
                e.Property(u => u.Name)
                .IsUnicode(false);

                e.Property(u => u.Password)
                .IsUnicode(false);

                e.Property(u => u.Email)
                .IsUnicode(false);

                //todo implement password hash nad username validation
            });
        }

        public DbSet<Team> Teams { get; set; }

        public DbSet<Color> Colors { get; set; }

        public DbSet<Town> Towns { get; set; }

        public DbSet<Country> Countries { get; set; }

        public DbSet<Player> Players { get; set; }

        public DbSet<Position> Positions { get; set; }

        public DbSet<PlayerStatistic> PlayerStatistics { get; set; }

        public DbSet<Game> Games { get; set; }

        public DbSet<Bet> Bets { get; set; }

        public DbSet<User> Users { get; set; }
    }
}
