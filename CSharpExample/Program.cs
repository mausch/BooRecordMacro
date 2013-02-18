using System;
using Example;

namespace CSharpExample {
    internal class Program {
        private static void Main(string[] args) {
            var john = new Person(Name: "John", Value: 23);
            var johnDoe = Person.NameLens.Update(john, x => x + " Doe");
            Console.WriteLine(johnDoe.Name);
        }
    }
}