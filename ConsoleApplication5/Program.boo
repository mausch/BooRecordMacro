namespace ConsoleApplication5

import System
import System.Collections.Generic
import Boo.Lang.Compiler.Ast

macro record:
	decl = List[of Field]()
	for s in record.Body.Statements:
		if s isa DeclarationStatement:
			ss = s as DeclarationStatement
			field = Field(Name: ss.Declaration.Name, Type: ss.Declaration.Type)
			field.Modifiers = TypeMemberModifiers.Final | TypeMemberModifiers.Public
			decl.Add(field)
	ctor = Constructor()
	for r in decl:
		param = ParameterDeclaration(Name: r.Name, Type: r.Type)
		ctor.Parameters.Add(param)
		ctor.Body.Add([| self.$(r.Name) = $param |])
	clazz = ClassDefinition(Name: record.Arguments[0].ToString())
	clazz.Members.Add(ctor)
	for r in decl:
		clazz.Members.Add(r)
	yield clazz

record Person:
	Name as string
	Value as int

p = Person("john", 23)
print p.Name
Console.ReadKey()