import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MacrosForSwiftMacros)
import MacrosForSwiftMacros

let testMacros: [String: Macro.Type] = [
	"toString": ToStringMacro.self,
]
#endif



final class MacrosForSwiftTests: XCTestCase
{
	func testToStringMacro() throws
	{
		#if canImport(MacrosForSwiftMacros)
		assertMacroExpansion(
			"""
			#toString(a)
			""",
			expandedSource: """
			"a"
			""",
			macros: testMacros
		)
		assertMacroExpansion(
			"""
			#toString(a.property)
			""",
			expandedSource: """
			"property"
			""",
			macros: testMacros
		)
		assertMacroExpansion(
			"""
			#toString(TypeName)
			""",
			expandedSource: """
			"TypeName"
			""",
			macros: testMacros
		)
		assertMacroExpansion(
			"""
			#toString(TypeName.staticProperty)
			""",
			expandedSource: """
			"staticProperty"
			""",
			macros: testMacros
		)
		assertMacroExpansion(
			"""
			#toString(\\TypeName.property)
			""",
			expandedSource: """
			"property"
			""",
			macros: testMacros
		)
		assertMacroExpansion(
			"""
			#toString(\\TypeName.property.subProperty)
			""",
			expandedSource: """
			"subProperty"
			""",
			macros: testMacros
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	
	
	func testToStringMacroErrors() throws
	{
		#if canImport(MacrosForSwiftMacros)
		assertMacroExpansion(
			"""
			#toString(1 + 2)
			""",
			expandedSource: """
			#toString(1 + 2)
			""",
			diagnostics: [
				.init(message: ToStringMacro.ToStringError.unsupportedExpression.description, line: 1, column: 1),
			],
			macros: testMacros
		)
		assertMacroExpansion(
			"""
			#toString((val: 1))
			""",
			expandedSource: """
			#toString((val: 1))
			""",
			diagnostics: [
				.init(message: ToStringMacro.ToStringError.unsupportedExpression.description, line: 1, column: 1),
			],
			macros: testMacros
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
}
