//
//  Utilities.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


@_transparent
internal func _abstract(_ class: AnyClass, _ function: StaticString = #function, _ line: Int = #line, _ file: StaticString = #file) -> Never {
    fatalError("Abstract class: \(`class`) in file: \"\(file)\" at line: \(line). You need to implement the function: \"\(function)\" by yourself.")
}

@_transparent
internal func _abstract(_ object: AnyObject, _ function: StaticString = #function, _ line: Int = #line, _ file: StaticString = #file) -> Never {
    fatalError("Abstract class: \(type(of: object)) in file: \"\(file)\" at line: \(line). You need to implement the function: \"\(function)\" by yourself.")
}

@_transparent
internal func _unimplemented(_ function: StaticString = #function, _ line: Int = #line, _ file: StaticString = #file) -> Never {
    fatalError("Unimplemented function: \"\(function)\" in file: \"\(file)\" at line: \(line).")
}
