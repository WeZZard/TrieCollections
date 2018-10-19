//
//  TrieSetIndex.swift
//  TrieSet
//
//  Created on 19/10/2018.
//


public struct TrieSetIndex: Comparable {
    internal let _offset: Int
    
    internal init(offset: Int) { _offset = offset }
    
    public static func == (lhs: TrieSetIndex, rhs: TrieSetIndex) -> Bool {
        return lhs._offset == rhs._offset
    }
    
    public static func < (lhs: TrieSetIndex, rhs: TrieSetIndex) -> Bool {
        return lhs._offset < rhs._offset
    }
}


extension TrieSetIndex: Hashable {
    public var hashValue: Int { return _offset }
}
