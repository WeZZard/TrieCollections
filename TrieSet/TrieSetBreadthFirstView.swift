//
//  TrieSetBreadthFirstView.swift
//  TrieSet
//
//  Created on 19/10/2018.
//


public struct TrieSetBreadthFirstView<E: TriePrefixing>: Sequence {
    public typealias Iterator = TrieSetBreadthFirstIterator<E>
    
    internal let _trieSet: TrieSet<E>
    
    public init(trieSet: TrieSet<E>) {
        _trieSet = trieSet
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(trieSetBreadFirstView: self)
    }
}
