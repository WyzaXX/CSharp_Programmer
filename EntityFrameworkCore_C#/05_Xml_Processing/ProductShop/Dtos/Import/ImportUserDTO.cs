using System.Xml.Serialization;

namespace ProductShop
{
    [XmlType("User")]
    public class ImportUserDTO
    {
        [XmlElement("firstName")]
        public string FirstName { get; set; }
        
        [XmlElement("lastName")]
        public string LastName { get; set; }
        
        [XmlElement("age")]
        public int Age { get; set; }
    }
}
