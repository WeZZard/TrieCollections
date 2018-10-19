//
//  _TrieSetIteratorImpl.swift
//  TrieSet
//
//  Created on 19/10/2018.
//


/// An abstract class for trie set iterators.
///
internal class _TrieSetIteratorImpl<E: TriePrefixing> {
    internal typealias Element = E
    
    internal typealias TriePrefix = E.TriePrefix
    
    var _elements: [Element]
    
    internal init(storage: _TrieSetStorage<Element>) {
        _elements = []
    }
    
    internal init(impl: _TrieSetIteratorImpl) {
        _elements = impl._elements
    }
    
    internal func next() -> Element? {
        while _elements.isEmpty {
            if let node = _getNode() {
                _elements.append(contentsOf: node.elements)
            } else {
                return nil
            }
        }
        
        if _elements.isEmpty {
            return nil
        } else {
            let element = _elements.removeFirst()
            return element
        }
    }
    
    internal func _getNode() -> _TrieNode<Element>? {
        _abstract(self)
    }
}
