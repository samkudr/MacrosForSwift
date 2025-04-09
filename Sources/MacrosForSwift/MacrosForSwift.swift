// The Swift Programming Language
// https://docs.swift.org/swift-book



/// Converts expression to a string literal.
///
/// - parameter expression: Expression or key path.
///
/// Examples:
///
///		#toString(variable) -> "variable"
///		#toString(TypeName.self) -> "TypeName"
///		#toString(TypeName.staticProperty) -> "staticProperty"
///		#toString(instance.property) -> "property"
///		#toString(\TypeName.property) -> "property"
///		#toString(\TypeName.property.subProperty) -> "subProperty"
@freestanding(expression)
public macro toString(_ expression: Any) -> String = #externalMacro(module: "MacrosForSwiftMacros", type: "ToStringMacro")
