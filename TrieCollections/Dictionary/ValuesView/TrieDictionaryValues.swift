//
//  TrieDictionaryValues.swift
//  TrieCollections
//
//  Created on 30/10/2018.
//


public struct TrieDictionaryValues<K: TriePrefixInterpretable, V>:
    Collection
{
    public typealias Key = K
    public typealias Value = V
    public typealias TriePrefix = K.TriePrefix
    
    internal typealias _KeyValueContainer = _TrieKeyValueContainer<K, V>
    internal typealias _Storage = _TrieStorage<_KeyValueContainer>
    
    internal let _trieDictionary: TrieDictionary<K, V>
    
    public init(trieDictionary: TrieDictionary<K, V>) {
        _trieDictionary = trieDictionary
    }
    
    public typealias Iterator = TrieDictionaryValuesIterator<K, V>
    
    public func makeIterator() -> Iterator {
        return Iterator(view: self)
    }
    
    public typealias Index = TrieDictionary<K, V>.Index
    
    public var startIndex: Index { return _trieDictionary.startIndex }
    
    public var endIndex: Index { return _trieDictionary.endIndex }
    
    public func index(after i: Index) -> Index {
        return _trieDictionary.index(after: i)
    }
    
    public subscript(position: Index) -> Element {
        return _trieDictionary[position].value
    }
}
