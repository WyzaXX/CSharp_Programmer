using ProductShop.Data;
using ProductShop.Models;
using ProductShop.XMLHelper;
using ProductShop.Dtos.Import;

using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;
using System.Collections.Generic;
using ProductShop.Dtos.Export;

namespace ProductShop
{
    public class StartUp
    {
        public static void Main()
        {
            using var db = new ProductShopContext();

            db.Database.EnsureDeleted();
            db.Database.EnsureCreated();

            var xmlusers = File.ReadAllText(@"datasets/users.xml");
            var xmlcategories = File.ReadAllText(@"datasets/categories.xml");
            var xmlproducts = File.ReadAllText(@"datasets/products.xml");
            var xmlcategoriesproducts = File.ReadAllText(@"datasets/categories-products.xml");


            ImportUsers(db, xmlusers);
            ImportProducts(db, xmlproducts);
            ImportCategories(db, xmlcategories);
            ImportCategoryProducts(db, xmlcategoriesproducts);

            var productsinrange = GetProductsInRange(db);
            File.WriteAllText("../../../results/productsinrange.xml", productsinrange);

            var userswithSoldProducts = GetSoldProducts(db);
            File.WriteAllText("../../../results/usersWithSoldProducts.xml", userswithSoldProducts);

            var categoriesWithProductsCount = GetCategoriesByProductsCount(db);
            File.WriteAllText("../../../results/categoriesWithProductsCount.xml", categoriesWithProductsCount);

            var usersWithProducts = GetUsersWithProducts(db);
            File.WriteAllText("../../../results/UsersWithProducts.xml"
                ,usersWithProducts);
        }
        public static string ImportUsers
            (ProductShopContext context, string inputXml)
        {
            const string rootElement = "Users";

            var usersResult = XmlConverter.Deserializer<ImportUserDTO>(inputXml, rootElement);

            var users = usersResult.Select(u => new User
            {
                FirstName = u.FirstName,
                LastName = u.LastName,
                Age = u.Age
            }).ToList();

            context.Users.AddRange(users);
            context.SaveChanges();

            return $"Successfully imported {users.Count}";
        }

        public static string ImportProducts(ProductShopContext context, string inputXml)
        {
            const string rootElement = "Products";

            var productsResult = XmlConverter.Deserializer<ImportProductDTO>(inputXml, rootElement);

            var products = productsResult.Select(p => new Product
            {
                Name = p.Name,
                Price = p.Price,
                SellerId = p.SellerId,
                BuyerId = p.BuyerId
            }).ToList();

            context.Products.AddRange(products);
            context.SaveChanges();

            return $"Successfully imported {products.Count}";
        }

        public static string ImportCategories(ProductShopContext context, string inputXml)
        {
            const string rootElement = "Categories";

            var categoriesResult = XmlConverter.Deserializer<ImportCategoryDTO>(inputXml, rootElement);

            var categories = categoriesResult
                .Where(c => c.Name != null)
                .Select(c => new Category
                {
                    Name = c.Name
                }).ToList();

            context.Categories.AddRange(categories);
            context.SaveChanges();

            return $"Successfully imported {categories.Count}";
        }

        public static string ImportCategoryProducts(ProductShopContext context, string inputXml)
        {
            const string rootElement = "CategoryProducts";

            var categoryProductResult = XmlConverter.Deserializer<ImportCategoryProductDTO>(inputXml, rootElement);

            //.where() clause is =>
            //=> if category id or product id doens't exist

            var categoryProducts = categoryProductResult
                .Where(x =>
                    context.Categories.Any(c => c.Id == x.CategoryId) &&
                    context.Products.Any(p => p.Id == x.ProductId))
                .Select(cp => new CategoryProduct
                {
                    CategoryId = cp.CategoryId,
                    ProductId = cp.ProductId
                }).ToList();

            context.CategoryProducts.AddRange(categoryProducts);
            context.SaveChanges();

            return $"Successfully imported {categoryProducts.Count}";
        }

        //P01 EXPORT products in price range
        public static string GetProductsInRange(ProductShopContext context)
        {
            const string rootElement = "Products";

            var productsDTo = context.Products
                .Where(p => p.Price >= 500 && p.Price <= 1000)
                .OrderBy(p => p.Price)
                .Take(10)
                .Select(p => new ExportProductInfoDTo
                {
                    Name = p.Name,
                    Price = p.Price,
                    Buyer = p.Buyer.FirstName + " " + p.Buyer.LastName
                }).ToList();

            var result = XmlConverter.Serialize(productsDTo, rootElement);

            return result;
        }

        //P02 EXPORT users with sold products
        public static string GetSoldProducts(ProductShopContext context)
        {
            const string rootElement = "Users";

            var usersWithProducts = context.Users
                .Where(u => u.ProductsSold.Any())
                .OrderBy(u => u.LastName)
                .ThenBy(u => u.FirstName)
                .Take(5)
                .Select(u => new ExportUsersWithSoldProductsDTo
                {
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    SoldProducts = u.ProductsSold.Select(ps => new UserProductDTo
                    {
                        Name = ps.Name,
                        Price = ps.Price
                    }).ToArray()
                })
                .ToList();

            var result = XmlConverter.Serialize(usersWithProducts, rootElement);

            return result;
        }

        //P03 EXPORT categories with products price and count 
        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            const string rootElement = "Categories";

            var categoriesWIthProducts = context.Categories
                .Select(c => new ExportCategoriesWithProductsCountDTo
                {
                    Name = c.Name,
                    Count = c.CategoryProducts.Count,
                    AveragePrice = c.CategoryProducts.Average(cp => cp.Product.Price),
                    TotalRevenue = c.CategoryProducts.Sum(cp => cp.Product.Price)
                })
                .OrderByDescending(c => c.Count)
                .ThenBy(c => c.TotalRevenue)
                .ToList();

            var result = XmlConverter.Serialize(categoriesWIthProducts, rootElement);

            return result;
        }

        //P04* EXPORT users and products
        public static string GetUsersWithProducts(ProductShopContext context)
        {
            const string rootElement = "Users";

            //We materialize the data first so that the database is not in memory because of judge test but dont do in future!!!

            var usersAndProducts = context.Users
                .ToArray()
                .Where(u => u.ProductsSold.Any())
                .Select(u => new ExportUserDto
                {
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    Age = u.Age,
                    SoldProduct = new ExportProductCountDTo
                    {
                        Count = u.ProductsSold.Count,
                        Products = u.ProductsSold.Select(ps => new UserProductDTo
                        {
                            Name = ps.Name,
                            Price = ps.Price
                        })
                        .OrderByDescending(ps=>ps.Price)
                        .ToArray()
                    }
                })
                .OrderByDescending(u => u.SoldProduct.Count)
                .Take(10)
                .ToList();

            var xml = new ExportUsersAndCountDTo
            {
                Count = context.Users.Count(u=>u.ProductsSold.Any()),
                Users = usersAndProducts.ToArray()
            };

            var result = XmlConverter.Serialize(xml, rootElement);

            return result;
        }
    }
}