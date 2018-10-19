//
//  TrieTestsAuxiliaries.swift
//  TrieSet
//
//  Created on 7/30/18.
//

@testable
import TrieSet


enum TrieElementComponent: TriePrefixSpace, CustomStringConvertible {
    case stringA(String)
    case stringB(String)
    
    var hashValue: Int {
        switch self {
        case let .stringA(value):  return value.hashValue
        case let .stringB(value): return value.hashValue
        }
    }
    
    static func == (
        lhs: TrieElementComponent,
        rhs: TrieElementComponent
        ) -> Bool
    {
        switch (lhs, rhs) {
        case let (.stringA(lhs), .stringA(rhs)): return lhs == rhs
        case let (.stringB(lhs), .stringB(rhs)): return lhs == rhs
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case let .stringA(string):
            return "stringA(\(string))"
        case let .stringB(string):
            return "stringB(\(string))"
        }
    }
}


struct TrieElement: TriePrefixing, CustomStringConvertible {
    let prompt: String
    
    let components: [TrieElementComponent]
    
    init(prompt: String, components: [TrieElementComponent] = []) {
        self.prompt = prompt
        self.components = components
    }
    
    static func == (lhs: TrieElement, rhs: TrieElement) -> Bool {
        return lhs.prompt == rhs.prompt && lhs.components == rhs.components
    }
    
    var triePrefixes: [TriePrefix] { return components }
    
    typealias TriePrefix = TrieElementComponent
    
    var description: String {
        return "\(prompt) => \(components.map{$0.description}.joined(separator: ", "))"
    }
}
