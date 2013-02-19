// Learn more about F# at http://fsharp.net

open Example
open FSharpx

let john = Person(Name = "John", Value = 23)
let johnDoe = john |> Lens.update (fun x -> x + " Doe") Person.NameLens
printfn "%s" johnDoe.Name