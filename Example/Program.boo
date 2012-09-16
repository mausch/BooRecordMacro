namespace Example

import System
import Boo.Lang.Extensions
import FSharpx
import Boo.Lang from Boo.Lang

[Extension]
def Get[of S,D](lens as Lens[of S,D], source as S) as D:
	return lens.Get.Invoke(source)

[Extension]
def Set[of S,D](lens as Lens[of S,D], source as S, newValue as D) as S:
	return lens.Set.Invoke(newValue).Invoke(source)

[Extension]
def Update[of S,D](lens as Lens[of S,D], source as S, update as Func[of D,D]) as S:
	fupdate = FSharpFunc.FromFunc(update)
	return lens.Update(fupdate, source)

record Person:
	Name as string
	Value as int

p = Person("john", 23)
print p.Name
print Person.NameLens.Get(p)
Console.ReadKey()