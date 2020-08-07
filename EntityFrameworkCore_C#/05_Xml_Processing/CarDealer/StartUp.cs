using System.IO;
using System.Linq;
using System.Collections.Generic;

using CarDealer.Data;
using CarDealer.Models;
using CarDealer.XMLHelper;
using CarDealer.Dtos.Import;
using CarDealer.Dtos.Export;

namespace CarDealer
{
    public class StartUp
    {
        public static void Main()
        {
            using var db = new CarDealerContext();

            db.Database.EnsureDeleted();
            db.Database.EnsureCreated();
            ImportData(db);

        }

        private static void ImportData(CarDealerContext db)
        {
            var importSuppliersXml = File.ReadAllText(@"../../../Datasets/suppliers.xml");
            var importPartsXml = File.ReadAllText(@"../../../Datasets/parts.xml");
            var importCarsXml = File.ReadAllText(@"../../../Datasets/cars.xml");
            var importCustomersXml = File.ReadAllText(@"../../../Datasets/customers.xml");
            var importSalesXml = File.ReadAllText(@"../../../Datasets/sales.xml");

            ImportSuppliers(db, importSuppliersXml);
            ImportParts(db, importPartsXml);
            ImportCars(db, importCarsXml);
            ImportCustomers(db, importCustomersXml);
            ImportSales(db, importSalesXml);
        }

        public static string ImportSuppliers(CarDealerContext context, string inputXml)
        {
            const string rootElement = "Suppliers";

            var suppliersResult = XmlConverter.Deserializer<ImportSupplierDto>(inputXml, rootElement);

            var suppliers = suppliersResult.Select(s => new Supplier
            {
                Name = s.Name,
                IsImporter = s.IsImporter
            }).ToList();

            context.Suppliers.AddRange(suppliers);
            context.SaveChanges();

            return $"Successfully imported {suppliers.Count}";
        }

        public static string ImportParts(CarDealerContext context, string inputXml)
        {
            const string rootElement = "Parts";

            var partsResult = XmlConverter.Deserializer<ImportPartsDto>(inputXml, rootElement);

            var parts = partsResult
                .Where(p => context.Suppliers.Any(s => s.Id == p.SupplierId))
                .Select(p => new Part
                {
                    Name = p.Name,
                    Price = p.Price,
                    Quantity = p.Quantity,
                    SupplierId = p.SupplierId
                }).ToList();

            context.Parts.AddRange(parts);
            context.SaveChanges();

            return $"Successfully imported {parts.Count}";
        }

        //Special Case* if some pard id is null skip the whole entity* may be used in future
        public static string ImportCars(CarDealerContext context, string inputXml)
        {
            const string rootElement = "Cars";

            var CarsDtos = XmlConverter.Deserializer<ImportCarDto>(inputXml, rootElement);

            var cars = new List<Car>();

            foreach (var carDto in CarsDtos)
            {
                var uniqueParts = carDto.Parts.Select(p => p.Id).Distinct().ToArray();
                var realParts = uniqueParts.Where(id => context.Parts.Any(i => i.Id == id));

                var car = new Car
                {
                    Make = carDto.Make,
                    Model = carDto.Model,
                    TravelledDistance = carDto.TraveledDistance,
                    PartCars = realParts.Select(id => new PartCar()
                    {
                        PartId = id
                    }).ToArray()
                };

                cars.Add(car);
            }

            context.Cars.AddRange(cars);
            context.SaveChanges();

            return $"Successfully imported {cars.Count}";
        }

        public static string ImportCustomers(CarDealerContext context, string inputXml)
        {
            const string rootElement = "Customers";

            var customersDtos = XmlConverter.Deserializer<ImportCustomerDto>(inputXml, rootElement);

            var customers = customersDtos
                .Select(c => new Customer
                {
                    Name = c.Name,
                    BirthDate = c.BirthDate,
                    IsYoungDriver = c.IsYoungDriver
                }).ToList();

            context.Customers.AddRange(customers);
            context.SaveChanges();

            return $"Successfully imported {customers.Count}";
        }

        //if car id is not in database skip entry*
        public static string ImportSales(CarDealerContext context, string inputXml)
        {
            const string rootElement = "Sales";

            var salesDtos = XmlConverter.Deserializer<ImportSalesDto>(inputXml, rootElement);

            var sales = salesDtos
                .Where(s => context.Cars.Any(c => c.Id == s.CarId))
                .Select(s => new Sale
                {
                    CarId = s.CarId,
                    CustomerId = s.CustomerId,
                    Discount = s.Discount
                }).ToList();

            context.Sales.AddRange(sales);
            context.SaveChanges();

            return $"Successfully imported {sales.Count}";
        }

        //export cars with distance
        public static string GetCarsWithDistance(CarDealerContext context)
        {
            const string rootElement = "cars";

            var carsDtos = context.Cars
                .Where(c => c.TravelledDistance > 2000000)
                .OrderBy(c => c.Make)
                .ThenBy(c => c.Model)
                .Take(10)
                .Select(c => new ExportCarsWithDistanceDto
                {
                    Make = c.Make,
                    Model = c.Model,
                    TravelledDistance = c.TravelledDistance
                })
                .ToList();

            var result = XmlConverter.Serialize(carsDtos, rootElement);

            return result;
        }

        //export cars only from bmw with xmltags
        //**!!NB get the make with ToLower() to ensure all cars!!!
        public static string GetCarsFromMakeBmw(CarDealerContext context)
        {
            var rootElement = "cars";

            var carsDTos = context.Cars
                .Where(c => c.Make.ToLower() == "bmw")
                .OrderBy(c => c.Model)
                .ThenByDescending(c => c.TravelledDistance)
                .Select(c => new ExportBMWDto
                {
                    Id = c.Id,
                    Model = c.Model,
                    TravelledDistance = c.TravelledDistance
                }).ToList();

            var result = XmlConverter.Serialize(carsDTos, rootElement);

            return result;
        }

        //export local suppliers
        public static string GetLocalSuppliers(CarDealerContext context)
        {
            const string rootElement = "suppliers";

            var suppliersDtos = context.Suppliers
                .Where(s => s.IsImporter == false)
                .Select(s => new ExportLocalSuppliersDto
                {
                    Id = s.Id,
                    Name = s.Name,
                    PartsCount = s.Parts.Count()
                }).ToList();

            var result = XmlConverter.Serialize(suppliersDtos, rootElement);

            return result;
        }


        //export cars with their list of parts
        public static string GetCarsWithTheirListOfParts(CarDealerContext context)
        {
            var rootElement = "cars";

            var carsWithPartsDto = context.Cars
                .Select(c => new ExportCarsWithPartsDto
                {
                    Make = c.Make,
                    Model = c.Model,
                    TravelledDistance = c.TravelledDistance,
                    Parts = c.PartCars
                    .Select(pc => new Parts
                    {
                        Name = pc.Part.Name,
                        Price = pc.Part.Price
                    })
                    .OrderByDescending(pc => pc.Price)
                    .ToArray()
                })
                .OrderByDescending(c => c.TravelledDistance)
                .ThenBy(c => c.Model)
                .Take(5)
                .ToList();

            var result = XmlConverter.Serialize(carsWithPartsDto, rootElement);
            return result;
        }

        //export total sales by customers
        public static string GetTotalSalesByCustomer(CarDealerContext context)
        {
            var rootElement = "customers";

            var salesDtos = context.Sales
                .Where(s => s.Customer.Sales.Any())
                .Select(s => new ExportSalesDto
                {
                    FullName = s.Customer.Name,
                    BoughtCars = s.Customer.Sales.Count,
                    SpentMoney = s.Car.PartCars.Sum(pc => pc.Part.Price)
                })
                .OrderByDescending(s => s.SpentMoney)
                .ToList();

            var result = XmlConverter.Serialize(salesDtos, rootElement);
            return result;
        }

        //** check if stuck on someXml
        //export Sales with applied discount
        public static string GetSalesWithAppliedDiscount(CarDealerContext context)
        {
            var rootElement = "sales";

            var salesWithDiscount = context.Sales
                .Select(s => new ExportSalesWithDiscountDto
                {
                    Car = new CarInfo
                    {
                        Make = s.Car.Make,
                        Model = s.Car.Model,
                        TravelledDistance = s.Car.TravelledDistance
                    },
                    Discount = s.Discount,
                    CustomerName = s.Customer.Name,
                    Price = s.Car.PartCars.Sum(pc => pc.Part.Price),
                    PriceWithDiscount = s.Car.PartCars.Sum(pc => pc.Part.Price)
                    - (s.Car.PartCars.Sum(pc => pc.Part.Price) * s.Discount)
                    / 100.0M
                }).ToList();

            var result = XmlConverter.Serialize(salesWithDiscount, rootElement);
            return result;
        }
    }
}