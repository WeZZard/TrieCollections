//
//  TriePrefixInterpretable.swift
//  TrieCollection
//
//  Created on 7/31/18.
//


/// A type that can be iterpreted into trie prefixes.
///
public protocol TriePrefixInterpretable: Equatable {
    associatedtype TriePrefix: TriePrefixProtocol
    
    var triePrefixes: [TriePrefix] { get }
}
