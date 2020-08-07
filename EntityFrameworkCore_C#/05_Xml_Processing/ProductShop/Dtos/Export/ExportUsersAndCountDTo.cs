using System.Xml.Serialization;

namespace ProductShop.Dtos.Export
{
    public class ExportUsersAndCountDTo
    {
        [XmlElement("count")]
        public int Count { get; set; }

        [XmlArray("users")]
        public ExportUserDto[] Users { get; set; }
    }

    [XmlType("User")]
    public class ExportUserDto
    {
        [XmlElement("firstName")]
        public string FirstName { get; set; }

        [XmlElement("lastName")]
        public string LastName { get; set; }

        [XmlElement("age")]
        public int? Age{ get; set; }

        [XmlElement("SoldProducts")]
        public ExportProductCountDTo SoldProduct{ get; set; }
    }


     public class ExportProductCountDTo
    {
        [XmlElement("count")]
        public int Count{ get; set; }

        [XmlArray("products")]
        public UserProductDTo[] Products{ get; set; }
    }
}
