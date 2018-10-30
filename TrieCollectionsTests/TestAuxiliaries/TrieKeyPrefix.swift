//
//  TrieKeyPrefix.swift
//  TrieCollections
//
//  Created on 28/10/2018.
//

@testable
import TrieCollections


enum TrieKeyPrefix: TriePrefixProtocol, CustomStringConvertible {
    case stringA(String)
    case stringB(String)
    
    var hashValue: Int {
        switch self {
        case let .stringA(value):  return value.hashValue
        case let .stringB(value): return value.hashValue
        }
    }
    
    static func == (
        lhs: TrieKeyPrefix,
        rhs: TrieKeyPrefix
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
