namespace Example

import System
import Boo.Lang.Extensions

record Person:
	Name as string
	Value as int

p = Person("john", 23)
print p.Name # prints 'john', OK
print Person.NameLens.Get(p) # prints 'john', OK
print Person.ValueLens.Set(p, 44).Value # prints 44, OK
print Person.NameLens.Set(p, "David").Name # prints 44, OK

fv = {x as int | x + 11}
print Person.ValueLens.Update(p, fv).Value # prints 34, OK

print Person.ValueLens.Update(p, {x as int | x + 11}).Value # prints garbage

print Person.NameLens.Update(p, {x as string | x + " doe" }).Name # prints ' doe', wrong

print Person.NameLens.Update(p, Func[of string,string]({x as string | x + " doe" })).Name # prints 'john doe', OK
