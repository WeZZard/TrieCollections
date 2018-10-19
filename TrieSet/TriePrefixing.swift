//
//  TriePrefixing.swift
//  TrieSet
//
//  Created on 7/31/18.
//


public protocol TriePrefixing: Equatable {
    associatedtype TriePrefix: TriePrefixSpace
    
    var triePrefixes: [TriePrefix] { get }
}
