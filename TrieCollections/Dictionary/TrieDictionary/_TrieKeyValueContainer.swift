//
//  _TrieKeyValueContainer.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//


internal struct _TrieKeyValueContainer<K: TriePrefixInterpretable, V>:
    TriePrefixInterpretable
{
    
    internal typealias Key = K
    internal typealias Value = V
    internal typealias TriePrefix = K.TriePrefix
    
    internal let key: Key
    
    internal let value: Value!
    
    internal init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
    
    internal init(key: Key) {
        self.key = key
        self.value = nil
    }
    
    internal var triePrefixes: [TriePrefix] { return key.triePrefixes }
    
    internal static func == (
        lhs: _TrieKeyValueContainer,
        rhs: _TrieKeyValueContainer
        ) -> Bool
    {
        return lhs.key == rhs.key
    }
    
    internal var keyValuePair: (key: Key, value: Value) {
        return (key, value)
    }
}
