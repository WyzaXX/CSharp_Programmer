using System.Xml.Serialization;

namespace ProductShop.Dtos.Export
{
    [XmlType("Category")]
    public class ExportCategoriesWithProductsCountDTo
    {
        [XmlElement("name")]
        public string Name{ get; set; }

        [XmlElement("count")]
        public int Count{ get; set; }

        [XmlElement("averagePrice")]
        public decimal AveragePrice{ get; set; }

        [XmlElement("totalRevenue")]
        public decimal TotalRevenue { get; set; }

    }

  //<Category>
  //  <name>Adult</name>
  //  <count>22</count>
  //  <averagePrice>704.41</averagePrice>
  //  <totalRevenue>15497.02</totalRevenue>
  //</Category>

}
