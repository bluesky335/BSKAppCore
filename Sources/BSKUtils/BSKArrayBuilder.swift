//
//  BSKArrayBuilder.swift
//
//
//

import Foundation

/// 数组构建器 让数组支持如下语法：
/// var a = 0
/// let array = Array<Int>{
///     1
///     2
///     3
///     if a == 0 {
///         4
///     } else {
///         5
///     }
///     6
/// }
/// array 的最终值为：[1,2,3,4,6]
///
@resultBuilder
public struct BSKArrayBuilder<T> {
    public typealias Component = [T]
    public typealias Expression = T
    public static func buildExpression(_ element: Expression) -> Component {
        return [element]
    }
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    public static func buildArray(_ components: [Component]) -> Component {
        return Array(components.joined())
    }
    public static func buildBlock(_ components: Component...) -> Component {
        return Array(components.joined())
    }
}

public extension Array {
    init(@BSKArrayBuilder<Element> _ builder:()->Self) {
        self = builder()
    }
}
