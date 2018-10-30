//
//  TrieCollectionDepthFirstView.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


public struct TrieSetDepthFirstView<E: TriePrefixInterpretable>:
    Collection
{
    public typealias Iterator = TrieSetDepthFirstIterator<E>
    
    internal let _trieSet: TrieSet<E>
    
    public init(trieSet: TrieSet<E>) {
        _trieSet = trieSet
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(view: self)
    }
    
    public typealias Index = TrieSet<E>.Index
    
    public var startIndex: Index { return _trieSet.startIndex }
    
    public var endIndex: Index { return _trieSet.endIndex }
    
    public func index(after i: Index) -> Index {
        return _trieSet.index(after: i)
    }
    
    public subscript(position: Index) -> Element {
        return _trieSet[position]
    }
}
