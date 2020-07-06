﻿using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Drawing;

namespace P03_FootballBetting.Data.Models
{
    public class Player
    {
        public Player()
        {
            this.PlayerStatistics = new HashSet<PlayerStatistic>();
        }
        public int PlayerId { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public byte SquadNumber { get; set; }

        public int TeamId { get; set; }
        public Team Team { get; set; }

        public int PositionId { get; set; }
        public Position Position { get; set; }

        public bool IsInjured { get; set; }

        public virtual ICollection<PlayerStatistic> PlayerStatistics { get; set; }
    }
}
