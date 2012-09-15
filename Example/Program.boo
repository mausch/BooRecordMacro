namespace Example

import System
import System.Collections.Generic
import Boo.Lang.Extensions

record Person:
	Name as string
	Value as int

p = Person("john", 23)
print p.Name
print p.GetHashCode()
Console.ReadKey()