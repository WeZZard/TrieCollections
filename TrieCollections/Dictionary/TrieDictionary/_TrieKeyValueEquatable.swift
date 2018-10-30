//
//  _TrieKeyValueEquatable.swift
//  TrieCollections
//
//  Created on 30/10/2018.
//


internal protocol _TrieKeyValueEquatable {
    static func isKeyValueEqual(lhs: Self, rhs: Self) -> Bool
}


extension _TrieStorage: _TrieKeyValueEquatable where
    E: _TrieKeyValueEquatable
{
    internal static func isKeyValueEqual(
        lhs: _TrieStorage,
        rhs: _TrieStorage
        ) -> Bool
    {
        return _TrieNode.isKeyValueEqual(lhs: lhs.node, rhs: rhs.node)
    }
}


extension _TrieNode: _TrieKeyValueEquatable where
    E: _TrieKeyValueEquatable
{
    internal static func isKeyValueEqual(lhs: _TrieNode, rhs: _TrieNode)
        -> Bool
    {
        return _TrieNodeStorage.isKeyValueEqual(
            lhs: lhs._storage,
            rhs: rhs._storage
        )
    }
}


extension _TrieNodeStorage: _TrieKeyValueEquatable where
    E: _TrieKeyValueEquatable
{
    internal static func isKeyValueEqual(
        lhs: _TrieNodeStorage,
        rhs: _TrieNodeStorage
        ) -> Bool
    {
        if self === rhs { return true }
        
        if lhs.prefix != rhs.prefix {
            return false
        }
        
        if !lhs.elements._isKeyValueEqualTo(contentsOf: rhs.elements) {
            return false
        }
        
        if lhs.nodesMap.count != rhs.nodesMap.count {
            return false
        }
        
        let keys = Set(lhs.nodesMap.keys).union(rhs.nodesMap.keys)
        
        for key in keys {
            guard let selfNodes = lhs.nodesMap[key] else { return false }
            guard let rhsNodes = rhs.nodesMap[key] else { return false }
            
            if !selfNodes._isEqualTo(contentsOf: rhsNodes) {
                return false
            }
        }
        
        return true
    }
}


extension _TrieKeyValueContainer: _TrieKeyValueEquatable where
    V: Equatable
{
    internal static func isKeyValueEqual(
        lhs: _TrieKeyValueContainer,
        rhs: _TrieKeyValueContainer
        ) -> Bool
    {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}
