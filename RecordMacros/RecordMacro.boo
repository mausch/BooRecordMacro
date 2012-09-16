namespace Boo.Lang.Extensions

import System
import System.Collections.Generic
import Boo.Lang.Compiler.Ast

public static class Lensf:
	def Create[of S,D](lget as Func[of S,D], lset as Func[of D,S,S]):
		fget = FSharpx.FSharpFunc.FromFunc(lget)
		fset = FSharpx.FSharpFunc.FromFunc(lset)
		return FSharpx.Lens[of S,D](fget, fset)

macro record:
	def newField(name, type):
		return Field(Name: name, Type: type, Modifiers: TypeMemberModifiers.Final | TypeMemberModifiers.Public)

	def GetFields(m as Block):
		fields = List[of Field]()
		for s in m.Statements:
			if s isa DeclarationStatement:
				ss = s as DeclarationStatement
				field = newField(ss.Declaration.Name, ss.Declaration.Type)
				fields.Add(field)
		return fields

	def BuildLenses(clazz as ClassDefinition, fields as List[of Field]):
		lenses = List[of Field]()
		for f in fields:
			lensType = GenericTypeReference("FSharpx.Lens", SimpleTypeReference(clazz.Name), f.Type)
			field = newField(f.Name + "Lens", lensType)
			field.Modifiers = field.Modifiers | TypeMemberModifiers.Static
			lenses.Add(field)
		return lenses

	def BuildCtor(fields as List[of Field]):
		ctor = Constructor()
		for f in fields:
			param = ParameterDeclaration(Name: f.Name, Type: f.Type)
			ctor.Parameters.Add(param)
			ctor.Body.Add([| self.$(f.Name) = $param |])
		return ctor

	def BuildStaticCtor(clazz as ClassDefinition, fields as List[of Field], lenses as List[of Field]):
		ctor = Constructor()
		for i in range(fields.Count):
			f = fields[i]
			l = lenses[i]
			setter = [| { a as $(f.Type), b as $(clazz) | return b } |]
			ctor.Body.Add([| self.$(l.Name) = Lensf.Create[of $(clazz),$(f.Type)]({ x as $(clazz) | return x.$(f.Name) }, $(setter)) |])
		ctor.Modifiers = ctor.Modifiers | TypeMemberModifiers.Static
		return ctor

	def BuildGetHashCode(fields as List[of Field]):
		metod = [| 
					def GetHashCode() as int:
						pass
				|]
		metod.Body.Add([| hashv = 17 |])
		for f in fields:
			metod.Body.Add([| hashv = hashv * 23 + $(f).GetHashCode() |])
		metod.Body.Add([| return hashv |])
		metod.Body["checked"] = false
		return metod

	fields = GetFields(record.Body)
	clazz = ClassDefinition(Name: record.Arguments[0].ToString())
	clazz.Members.Add(BuildGetHashCode(fields))
	for r in fields:
		clazz.Members.Add(r)
	ctor = BuildCtor(fields)
	clazz.Members.Add(ctor)
	lenses = BuildLenses(clazz, fields)
	for r in lenses:
		clazz.Members.Add(r)
	clazz.Members.Add(BuildStaticCtor(clazz, fields, lenses))
	yield clazz

	# TODO equality, ToString(), copy-and-update