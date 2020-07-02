using System;
using System.Text;
using System.Linq;

using SoftUni.Data;
using SoftUni.Models;
using System.Globalization;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace SoftUni
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            var context = new SoftUniContext();

            var result = RemoveTown(context);

            Console.WriteLine(result);
        }

        //Problem 03
        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var employees = context.Employees.OrderBy(e => e.EmployeeId).Select(e => new
            {
                firstName = e.FirstName,
                lastName = e.LastName,
                middleName = e.MiddleName,
                jobTitle = e.JobTitle,
                salary = e.Salary
            }).ToList();

            foreach (var e in employees)
            {
                sb.AppendLine
                    ($@"{e.firstName} {e.lastName} {e.middleName} {e.jobTitle} {e.salary:F2}");


            }

            return sb.ToString().TrimEnd();
        }

        //Problem 04
        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var employeesWithSalaryOver50000 = context.Employees.Where(e => e.Salary > 50000).OrderBy(e => e.FirstName).Select(x => new
            {
                firstName = x.FirstName,
                salary = x.Salary
            }).ToList();

            foreach (var e in employeesWithSalaryOver50000)
            {
                sb.AppendLine($@"{e.firstName} - {e.salary:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 05
        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var employeesFromResearchAndDevelopent = context.Employees
                 .Where(e => e.Department.Name == "Research and Development")
                 .Select(e => new
                 {
                     e.FirstName,
                     e.LastName,
                     departmentName = e.Department.Name,
                     e.Salary
                 })
                 .OrderBy(e => e.Salary)
                 .ThenByDescending(e => e.FirstName).ToList();

            foreach (var e in employeesFromResearchAndDevelopent)
            {
                sb.AppendLine
                    ($@"{e.FirstName} {e.LastName} from {e.departmentName} - ${e.Salary:F2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 06 
        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            var sb = new StringBuilder();

            Address newAddress = new Address()
            {
                AddressText = "Vitoshka 15",
                TownId = 4
            };

            var employeeNakov = context.Employees.First(e => e.LastName == "Nakov");

            employeeNakov.Address = newAddress;

            context.SaveChanges();

            var employees = context.Employees.Select(e => new
            {
                addressId = e.AddressId,
                addressText = e.Address.AddressText
            }).OrderByDescending(e => e.addressId).Take(10).ToList();

            foreach (var e in employees)
            {
                sb.AppendLine
                    ($@"{e.addressText}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 07*
        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var employees = context.Employees
                .Where(e => e.EmployeesProjects
                .Any(ep => ep.Project.StartDate.Year >= 2001 &&
                      ep.Project.StartDate.Year <= 2003))
                .Take(10)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    managerFirstName = e.Manager.FirstName,
                    managerLastName = e.Manager.LastName,
                    Project = e.EmployeesProjects
                    .Select(ep => new
                    {
                        ProjectName = ep.Project.Name,
                        StartDate = ep.Project
                        .StartDate
                        .ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture),
                        EndDate = ep.Project.EndDate.HasValue ?
                            ep.Project
                            .EndDate
                            .Value
                            .ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture)
                            : "not finished"
                    }).ToList()
                }).ToList();

            foreach (var e in employees)
            {
                sb.AppendLine
                    ($@"{e.FirstName} {e.LastName} - Manager: {e.managerFirstName} {e.managerLastName}");

                foreach (var p in e.Project)
                {
                    sb.AppendLine
                        ($@"--{p.ProjectName} - {p.StartDate} - {p.EndDate}");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 08
        public static string GetAddressesByTown(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var addresses = context.Addresses
                .OrderByDescending(a => a.Employees.Count())
                .ThenBy(a => a.Town.Name)
                .ThenBy(a => a.AddressText)
                .Take(10)
                .Select(a => new
                {
                    a.AddressText,
                    AddressTownName = a.Town.Name,
                    EmployeeCount = a.Employees.Count
                }).ToList();

            foreach (var a in addresses)
            {
                sb.AppendLine
                    ($@"{a.AddressText}, {a.AddressTownName} - {a.EmployeeCount} employees");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 09
        public static string GetEmployee147(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var employee147 = context.Employees
                .Where(e => e.EmployeeId == 147)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.JobTitle,
                    Projects = e.EmployeesProjects
                    .OrderBy(ep => ep.Project.Name)
                    .Select(ep => new
                    {
                        ProjectName = ep.Project.Name
                    }).ToList()
                }).ToList();

            foreach (var e in employee147)
            {
                sb.AppendLine
                    ($@"{e.FirstName} {e.LastName} - {e.JobTitle}");
                foreach (var p in e.Projects)
                {
                    sb.AppendLine
                        ($@"{p.ProjectName}");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 10
        public static string GetDepartmentsWithMoreThan5Employees(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var departments = context.Departments
                .Where(d => d.Employees.Count > 5)
                .OrderBy(d => d.Employees.Count)
                .ThenByDescending(d => d.Name)
                .Select(d => new
                {
                    d.Name,
                    ManagerFirstName = d.Manager.FirstName,
                    ManagerLastName = d.Manager.LastName,
                    Employees = d.Employees
                    .OrderBy(e => e.FirstName)
                    .ThenBy(e => e.LastName)
                    .Select(e => new
                    {
                        e.FirstName,
                        e.LastName,
                        e.JobTitle
                    }).ToList()
                }).ToList();

            foreach (var d in departments)
            {
                sb.AppendLine
                    ($@"{d.Name} - {d.ManagerFirstName} {d.ManagerLastName}");
                foreach (var e in d.Employees)
                {
                    sb.AppendLine
                        ($@"{e.FirstName} {e.LastName} - {e.JobTitle}");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 11
        public static string GetLatestProjects(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var projects = context.Projects
                .OrderByDescending(p => p.StartDate)
                .Take(10)
                .OrderBy(p => p.Name)
                .Select(p => new
                {
                    p.Name,
                    p.Description,
                    StartDate = p.StartDate
                    .ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture)
                }).ToList();

            foreach (var p in projects)
            {
                sb.AppendLine($@"{p.Name}");
                sb.AppendLine($@"{p.Description}");
                sb.AppendLine($@"{p.StartDate}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 12
        public static string IncreaseSalaries(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var increaseSalary = 1.12M;

            //needs to be IQueryable to increase salary!!!
            var employees = context.Employees
                .Where(e => e.Department.Name == "Engineering" ||
                        e.Department.Name == "Tool Design" ||
                        e.Department.Name == "Marketing" ||
                        e.Department.Name == "Information Services");

            foreach (var e in employees)
            {
                e.Salary *= increaseSalary;
            }

            context.SaveChanges();

            var employeesInfo = employees
                .OrderBy(e => e.FirstName)
                .ThenBy(e => e.LastName)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.Salary
                });

            foreach (var e in employeesInfo)
            {
                sb.AppendLine
                    ($@"{e.FirstName} {e.LastName} (${e.Salary:F2})");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 13
        public static string GetEmployeesByFirstNameStartingWithSa(SoftUniContext context)
        {
            var sb = new StringBuilder();

            var employeesWithSa = context.Employees
                .Where(e => e.FirstName.StartsWith("Sa"))
                .OrderBy(e => e.FirstName)
                .ThenBy(e => e.LastName)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.JobTitle,
                    e.Salary
                }).ToList();


            foreach (var e in employeesWithSa)
            {
                sb.AppendLine
                    ($@"{e.FirstName} {e.LastName} - {e.JobTitle} - (${e.Salary:F2})");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 14
        public static string RemoveTown(SoftUniContext context)
        {
            var townToDel = context
                .Towns
                .First(t => t.Name == "Seattle");

            var addressesToDel = context
                .Addresses
                .Where(a => a.TownId == townToDel.TownId);

            int addressCount = addressesToDel.Count();

            var employeesOnDelAddress = context
                .Employees
                .Where(e => addressesToDel
                .Any(a => a.AddressId == e.AddressId));

            foreach (var e in employeesOnDelAddress)
            {
                e.AddressId = null;
            }

            foreach (var a in addressesToDel)
            {
                context.Addresses.Remove(a);
            }

            context.Towns.Remove(townToDel);

            context.SaveChanges();

            return $"{addressCount} addresses in {townToDel.Name} were deleted";
        }
    }
}
