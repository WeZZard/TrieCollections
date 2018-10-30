//
//  TrieCollectionBreadthFirstView.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


public struct TrieDictionaryBreadthFirstView<
    K: TriePrefixInterpretable,
    V
    >: Collection
{
    public typealias Iterator = TrieDictionaryBreadthFirstIterator<K, V>
    
    internal let _trieDictionary: TrieDictionary<K, V>
    
    public init(trieDictionary: TrieDictionary<K, V>) {
        _trieDictionary = trieDictionary
    }
    
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
        return _trieDictionary[position]
    }
}
