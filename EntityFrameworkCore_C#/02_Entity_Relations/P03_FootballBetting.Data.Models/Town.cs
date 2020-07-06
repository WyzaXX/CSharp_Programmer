﻿using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace P03_FootballBetting.Data.Models
{
    public class Town
    {
        public Town()
        {
            this.Teams = new HashSet<Team>();
        }
        public int TownId { get; set; }


        public int CountryId { get; set; }
        public Country Country { get; set; }

        [Required]
        public string Name { get; set; }

        public virtual ICollection<Team> Teams { get; set; }
    }
}
