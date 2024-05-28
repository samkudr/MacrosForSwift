import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros



public struct ToStringMacro: ExpressionMacro
{
	public enum ToStringError: Error, CustomStringConvertible
	{
		case unsupportedExpression
		
		public var description: String
		{
			switch self
			{
			case .unsupportedExpression:
				return "Unsupported expression."
			}
		}
	}
	
	
	
	public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax
	{
		let argument = node.argumentList.first!.expression
		
		if let declExpr = argument.as(DeclReferenceExprSyntax.self)
		{
			return "\"\(declExpr.baseName)\""
		}
		else if let memberExpr = argument.as(MemberAccessExprSyntax.self)
		{
			return "\"\(memberExpr.declName.baseName)\""
		}
		else if let keyPathExpr = argument.as(KeyPathExprSyntax.self),
						let compExpr = keyPathExpr.components.last?.component.as(KeyPathPropertyComponentSyntax.self)
		{
			return "\"\(compExpr.declName.baseName)\""
		}
		
		throw ToStringError.unsupportedExpression
	}
}



@main
struct MacrosForSwiftPlugin: CompilerPlugin
{
	let providingMacros: [Macro.Type] = [
		ToStringMacro.self,
	]
}
