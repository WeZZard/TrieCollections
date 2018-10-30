//
//  TrieKey.swift
//  TrieSet
//
//  Created on 7/30/18.
//

@testable
import TrieCollections


class TrieKey: TriePrefixInterpretable, Hashable, CustomStringConvertible {
    typealias TriePrefix = TrieKeyPrefix
    
    let prompt: String
    
    let components: [TrieKeyPrefix]
    
    init(prompt: String, components: [TrieKeyPrefix] = []) {
        self.prompt = prompt
        self.components = components
    }
    
    var triePrefixes: [TriePrefix] { return components }
    
    static func == (lhs: TrieKey, rhs: TrieKey) -> Bool {
        return lhs.prompt == rhs.prompt && lhs.components == rhs.components
    }
    
    var hashValue: Int { return prompt.hashValue }
    
    var description: String {
        return "\(prompt) => \(components.map{$0.description}.joined(separator: ", "))"
    }
}
