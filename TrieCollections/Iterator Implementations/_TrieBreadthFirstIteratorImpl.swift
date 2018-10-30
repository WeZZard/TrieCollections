//
//  _TrieBreadthFirstIteratorImpl.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


/// Breadth-First Iterator Implementation for a `TrieSet`.
///
internal class _TrieBreadthFirstIteratorImpl<E: TriePrefixInterpretable>:
    _TrieIteratorImpl<E>
{
    internal override init(storage: _TrieStorage<Element>) {
        _stack = [storage.node]
        _stack.reserveCapacity(storage.count)
        super.init(storage: storage)
    }
    
    internal init(impl: _TrieBreadthFirstIteratorImpl) {
        _stack = impl._stack
        super.init(impl: impl)
    }
    
    internal var _stack: [_TrieNode<Element>]
    
    internal override func _getNode() -> _TrieNode<Element>? {
        while !_stack.isEmpty {
            let firstNode = _stack.removeFirst()
            let pendingNodes = firstNode.nodesMap.values.map({$0}).flatMap({$0})
            if !pendingNodes.isEmpty {
                _stack.append(contentsOf: pendingNodes)
            }
            return firstNode
        }
        return nil
    }
}
