namespace BookShop
{
    using System;
    using System.Text;
    using System.Linq;

    using Data;
    using Initializer;
    using BookShop.Models.Enums;
    using System.Collections.Generic;

    public class StartUp
    {
        private static StringBuilder sb = new StringBuilder();

        public static void Main()
        {
            using var context = new BookShopContext();
           
            //Optional
            //DbInitializer.ResetDatabase(context);
        }

        //Problem 01
        public static string GetBooksByAgeRestriction(BookShopContext context, string command)
        {
            var books = context
                .Books
                .ToList()
                .Where(x => x.AgeRestriction.ToString().ToLower() == command.ToLower())
                .OrderBy(x => x.Title)
                .Select(x => x.Title);

            foreach (var b in books)
            {
                sb.AppendLine($@"{b}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 02
        public static string GetGoldenBooks(BookShopContext context)
        {
            var goldenBooks = context
                .Books
                .Where(b => b.Copies < 5000)
                .Where(b => b.EditionType == EditionType.Gold)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            foreach (var b in goldenBooks)
            {
                sb.AppendLine($@"{b}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 03
        public static string GetBooksByPrice(BookShopContext context)
        {
            var books = context.Books
                .Where(b => b.Price > 40)
                .OrderByDescending(b => b.Price)
                .Select(b => new
                {
                    b.Title,
                    b.Price
                })
                .ToList();

            foreach (var b in books)
            {
                sb.AppendLine($@"{b.Title} - ${b.Price:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 04
        public static string GetBooksNotReleasedIn
            (BookShopContext context, int year)
        {
            var books = context.Books
                .Where(b => b.ReleaseDate.Value.Year != year)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            foreach (var b in books)
            {
                sb.AppendLine($@"{b}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 05
        public static string GetBooksByCategory
            (BookShopContext context, string input)
        {
            var allBooks = new List<string>();

            var categories = input.Split
                (' ', StringSplitOptions.RemoveEmptyEntries)
                .Select(c => c.ToLower()).ToList();

            foreach (var c in categories)
            {
                var books = context.Books
                    .Where
                    (b => b.BookCategories
                    .Any(cat => cat.Category.Name.ToLower() == c))
                    .OrderBy(c => c.Title)
                    .Select(c => c.Title)
                    .ToList();

                allBooks.AddRange(books);
            }

            allBooks = allBooks.OrderBy(b => b).ToList();

            return String.Join(Environment.NewLine, allBooks);
        }

        //Problem 06
        public static string GetBooksReleasedBefore(BookShopContext context, string date)
        {
            var inputDate = DateTime.ParseExact(date, "dd-MM-yyyy", null);

            var books = context.Books
                .Where(b => b.ReleaseDate < inputDate)
                .OrderByDescending(b => b.ReleaseDate)
                .Select(b => new
                {
                    b.Title,
                    b.EditionType,
                    b.Price
                })
                .ToList();

            foreach (var b in books)
            {
                sb.AppendLine
                    ($@"{b.Title} - {b.EditionType} - ${b.Price:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 07
        public static string GetAuthorNamesEndingIn(BookShopContext context, string input)
        {
            var authors = context.Authors
                .Where(a => a.FirstName.EndsWith(input))
                .Select(x => new
                {
                    fullName = x.FirstName + " " + x.LastName
                }).ToList();

            authors = authors.OrderBy(a => a.fullName).ToList();

            foreach (var a in authors)
            {
                sb.AppendLine($@"{a.fullName}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 08
        public static string GetBookTitlesContaining(BookShopContext context, string input)
        {
            var books = context.Books
                .ToList()
                .Where(b => b.Title.Contains(input, StringComparison.InvariantCultureIgnoreCase))
                .Select(b => b.Title)
                .OrderBy(b => b);

            return String.Join(Environment.NewLine, books);
        }

        //Problem 09
        public static string GetBooksByAuthor(BookShopContext context, string input)
        {
            var books = context.Books
                .Select(b => new
                {
                    b.BookId,
                    b.Title,
                    authorFirstName = b.Author.FirstName,
                    authorLastName = b.Author.LastName
                })
                .ToList()
                .Where(b => b.authorLastName.StartsWith(input, StringComparison.InvariantCultureIgnoreCase))
                .OrderBy(b => b.BookId);

            foreach (var b in books)
            {
                sb.AppendLine($@"{b.Title} ({b.authorFirstName} {b.authorLastName})");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 10
        public static int CountBooks(BookShopContext context, int lengthCheck)
        {
            return context.Books.Count(b => b.Title.Length > lengthCheck);
        }

        //Problem 11
        public static string CountCopiesByAuthor(BookShopContext context)
        {
            var authors = context.Authors
               .Select(a => new
               {
                   fullName = a.FirstName + " " + a.LastName + " - ",
                   BookCopies = a.Books.Sum(b => b.Copies)
               })
               .OrderByDescending(a => a.BookCopies)
               .ToList();

            foreach (var a in authors)
            {
                sb.AppendLine
                    ($@"{a.fullName}{a.BookCopies}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 12
        public static string GetTotalProfitByCategory(BookShopContext context)
        {
            var profits = context.Categories
                .Select(c => new
                {
                    c.Name,
                    TotalProfits = c.CategoryBooks
                    .Select(cb => new
                    {
                        BookProfit = cb.Book.Copies * cb.Book.Price
                    })
                    .Sum(cb => cb.BookProfit)
                })
                .OrderByDescending(c => c.TotalProfits)
                .ThenBy(c => c.Name)
                .ToList();

            foreach (var c in profits)
            {
                sb.AppendLine
                    ($@"{c.Name} ${c.TotalProfits:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 13
        public static string GetMostRecentBooks(BookShopContext context)
        {
            var categories = context.Categories
                 .Select(c => new
                 {
                     c.Name,
                     Books = c.CategoryBooks
                     .OrderByDescending(cb => cb.Book.ReleaseDate)
                     .Take(3)
                     .Select(cb => new
                     {
                         BookTitle = cb.Book.Title,
                         ReleaseDate = cb.Book.ReleaseDate
                     })
                 })
                 .OrderBy(c => c.Name)
                 .ToList();

            foreach (var c in categories)
            {
                sb.AppendLine($@"--{c.Name}");
                foreach (var b in c.Books)
                {
                    sb.AppendLine($@"{b.BookTitle} ({b.ReleaseDate.Value.Year})");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 14
        public static void IncreasePrices(BookShopContext context)
        {
            var booksToIncreasePrice = context.Books
                .Where(b => b.ReleaseDate.Value.Year < 2010);

            foreach (var b in booksToIncreasePrice)
            {
                b.Price += 5;
            }

            context.SaveChanges();
        }
    }
}

