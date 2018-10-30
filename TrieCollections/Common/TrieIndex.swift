//
//  TrieCollectionIndex.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


public struct TrieIndex: Comparable {
    internal let _offset: Int
    
    internal init(offset: Int) { _offset = offset }
    
    public static func == (lhs: TrieIndex, rhs: TrieIndex) -> Bool {
        return lhs._offset == rhs._offset
    }
    
    public static func < (lhs: TrieIndex, rhs: TrieIndex) -> Bool {
        return lhs._offset < rhs._offset
    }
}


extension TrieIndex: Hashable {
    public var hashValue: Int { return _offset }
}
