namespace ConsoleApplication5

import System
import System.Collections.Generic
import Boo.Lang.Compiler.Ast

macro record:
	def GetFields(m as MacroStatement):
		fields = List[of Field]()
		for s in m.Body.Statements:
			if s isa DeclarationStatement:
				ss = s as DeclarationStatement
				field = Field(Name: ss.Declaration.Name, Type: ss.Declaration.Type, Modifiers: TypeMemberModifiers.Final | TypeMemberModifiers.Public)
				fields.Add(field)
		return fields

	def BuildCtor(fields as List[of Field]):
		ctor = Constructor()
		for r in fields:
			param = ParameterDeclaration(Name: r.Name, Type: r.Type)
			ctor.Parameters.Add(param)
			ctor.Body.Add([| self.$(r.Name) = $param |])
		return ctor

	fields = GetFields(record)
	ctor = BuildCtor(fields)
	clazz = ClassDefinition(Name: record.Arguments[0].ToString())
	clazz.Members.Add(ctor)
	for r in fields:
		clazz.Members.Add(r)
	yield clazz


record Person:
	Name as string
	Value as int

p = Person("john", 23)
print p.Name
Console.ReadKey()