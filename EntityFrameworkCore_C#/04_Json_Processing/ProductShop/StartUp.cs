using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json;
using ProductShop.Data;
using ProductShop.Models;

namespace ProductShop
{
    public class StartUp
    {
        private static readonly string ResultsDirectoryPath = "../../../Datasets/Results";

        public static void Main(string[] args)
        {
            var db = new ProductShopContext();
            //ResetDatabase(db);

            //ImportData(db);

            //GetProductsInRange(db);
            //GetSoldProducts(db);
            //GetCategoriesByProductsCount(db);
            var result = GetUsersWithProducts(db);
            Console.WriteLine(result);
            //EnsureDirectoryExists(ResultsDirectoryPath);

            //File.WriteAllText(ResultsDirectoryPath + "/products-in-range.json", json);
            //File.WriteAllText(ResultsDirectoryPath + "/users-sold-products.json", json);
        }

        private static void ResetDatabase(ProductShopContext db)
        {
            db.Database.EnsureDeleted();
            Console.WriteLine("Database deleted successfully");
            db.Database.EnsureCreated();
            Console.WriteLine("Database created successfully");
        }

        private static void ImportData(ProductShopContext db)
        {
            var usersJSON = File.ReadAllText("../../../Datasets/users.json");
            var productsJSON = File.ReadAllText("../../../Datasets/products.json");
            var categoriesJSON = File.ReadAllText("../../../Datasets/categories.json");
            var categorieProductsJson = File.ReadAllText("../../../Datasets/categories-products.json");

            ImportUsers(db, usersJSON);
            ImportProducts(db, productsJSON);
            ImportCategories(db, categoriesJSON);
            ImportCategoryProducts(db, categorieProductsJson);
        }

        public static string ImportUsers(ProductShopContext context, string inputJson)
        {
            var users = JsonConvert.DeserializeObject<List<User>>(inputJson);

            context.Users.AddRange(users);
            context.SaveChanges();

            return $"Successfully imported {users.Count}";
        }

        public static string ImportProducts(ProductShopContext context, string inputJson)
        {
            var products = JsonConvert.DeserializeObject<List<Product>>(inputJson);

            context.Products.AddRange(products);
            context.SaveChanges();

            return $"Successfully imported {products.Count}";
        }

        public static string ImportCategories(ProductShopContext context, string inputJson)
        {
            var settings = new JsonSerializerSettings()
            {
                NullValueHandling = NullValueHandling.Ignore
            };

            var categories = JsonConvert.DeserializeObject<List<Category>>(inputJson, settings);

            context.Categories.AddRange(categories);
            context.SaveChanges();

            return $"Successfully imported {categories.Count}";
        }

        public static string ImportCategoryProducts(ProductShopContext context, string inputJson)
        {
            var categoriesProducts = JsonConvert.DeserializeObject<List<CategoryProduct>>(inputJson);

            context.CategoryProducts.AddRange(categoriesProducts);
            context.SaveChanges();

            return $"Successfully imported {categoriesProducts.Count}";
        }

        //save to file 
        private static void EnsureDirectoryExists(string path)
        {
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
        }

        //Problem 01
        public static string GetProductsInRange(ProductShopContext context)
        {
            var products = context.Products
                .Where(x => x.Price >= 500 && x.Price <= 1000)
                .OrderBy(x => x.Price)
                .Select(x => new
                {
                    name = x.Name,
                    price = x.Price,
                    seller = x.Seller.FirstName + " " + x.Seller.LastName,
                })
                .ToList();

            var json = JsonConvert.SerializeObject(products, Formatting.Indented);
            return json;

        }

        //Problem 02
        public static string GetSoldProducts(ProductShopContext context)
        {
            var users = context.Users
                 .Where(x => x.ProductsSold.Any(ps => ps.Buyer != null))
                 .OrderBy(x => x.LastName)
                 .ThenBy(x => x.LastName)
                 .Select(x => new
                 {
                     firstName = x.FirstName,
                     lastName = x.LastName,
                     soldProducts = x.ProductsSold
                     .Where(ps => ps.Buyer != null)
                     .Select(ps => new
                     {
                         name = ps.Name,
                         price = ps.Price,
                         buyerFirstName = ps.Buyer.FirstName,
                         buyerLastName = ps.Buyer.LastName
                     })
                 }).ToList();

            var json = JsonConvert.SerializeObject(users, Formatting.Indented);

            return json;
        }

        //Problem 03
        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            var categories = context.Categories.Where(x => x.Name != null)
                .Select(x => new
                {
                    category = x.Name,
                    productsCount = x.CategoryProducts.Count(),
                    averagePrice = x.CategoryProducts.Average(p => p.Product.Price).ToString("F2"),
                    totalRevenue = x.CategoryProducts.Sum(p => p.Product.Price).ToString("F2")
                })
                .OrderByDescending(x => x.productsCount)
                .ToList();

            var json = JsonConvert.SerializeObject(categories, Formatting.Indented);

            return json;
        }

        //Problem 04*
        public static string GetUsersWithProducts(ProductShopContext context)
        {
            var users = context.Users
                .Where(x => x.ProductsSold.Any(ps => ps.Buyer != null))
                .OrderByDescending(x => x.ProductsSold.Count)
                .Select(x => new
                {
                    lastName = x.LastName,
                    age = x.Age,
                    soldProducts = new
                    {
                        count = x.ProductsSold
                        .Count(p => p.Buyer != null),
                        products = x.ProductsSold
                        .Where(p => p.Buyer != null)
                        .Select(p => new
                        {
                            name = p.Name,
                            price = p.Price
                        })
                    }
                })
                .ToList();

            var resultObj = new
            {
                usersCount = users.Count,
                users = users
            };

            var settings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore
            };

            var json = JsonConvert.SerializeObject
                (resultObj, Formatting.Indented, settings);

            return json;
        }
    }
}