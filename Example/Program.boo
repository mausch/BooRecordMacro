namespace Example

import System
import Boo.Lang.Extensions

record Person:
	Name as string
	Value as int

p = Person("john", 23)
print p.Name
print Person.NameLens.Get(p)
print Person.ValueLens.Set(p, 44).Value
print Person.NameLens.Set(p, "David").Name
print Person.ValueLens.Update(p, {x as int | x + 11}).Value
# Console.ReadKey()