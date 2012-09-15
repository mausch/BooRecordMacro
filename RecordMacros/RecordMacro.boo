namespace Boo.Lang.Extensions

import System
import System.Collections.Generic
import Boo.Lang.Compiler.Ast

public static class Lensf:
	def Create[of S,D](lget as Func[of S,D], lset as Func[of D,S,S]) as FSharpx.Lens[of S,D]:
		raise "asdasd"

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
			lens = [| Lensf.Create[of $(clazz),$(f.Type)]({x|0}, { a,b | return b}) |]
			lensType = GenericTypeReference("FSharpx.Lens", SimpleTypeReference(clazz.Name), f.Type)
			field = newField(f.Name + "Lens", lensType)
			field.Modifiers = field.Modifiers | TypeMemberModifiers.Static
			lenses.Add(field)
		return lenses

	def BuildCtor(fields as List[of Field]):
		ctor = Constructor()
		for r in fields:
			param = ParameterDeclaration(Name: r.Name, Type: r.Type)
			ctor.Parameters.Add(param)
			ctor.Body.Add([| self.$(r.Name) = $param |])
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
	ctor = BuildCtor(fields)
	clazz = ClassDefinition(Name: record.Arguments[0].ToString())
	clazz.Members.Add(ctor)
	clazz.Members.Add(BuildGetHashCode(fields))
	for r in fields:
		clazz.Members.Add(r)
	lenses = BuildLenses(clazz, fields)
	for r in lenses:
		clazz.Members.Add(r)
	yield clazz

	# TODO equality, ToString(), copy-and-update