//
//  _TrieDepthFirstIteratorImpl.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


/// Depth-First Iterator Implementation for a `TrieSet`.
///
/// - Note: Because for a hashed collection, there isn't a promised
/// dterministic order for a sequence of given inputs, this class just
/// named depth-first but not pre-order, in-order or post-order.
///
internal class _TrieDepthFirstIteratorImpl<E: TriePrefixInterpretable>:
    _TrieIteratorImpl<E>
{
    internal typealias _NodeIndex = Dictionary<Int, [_TrieNode<E>]>.Index
    
    internal override init(storage: _TrieStorage<Element>) {
        _stack = [(storage.node, storage.node.nodesMap.startIndex)]
        _stack.reserveCapacity(storage.count)
        super.init(storage: storage)
    }
    
    internal init(impl: _TrieDepthFirstIteratorImpl) {
        _stack = impl._stack
        super.init(impl: impl)
    }
    
    internal var _stack: [(_TrieNode<Element>, _NodeIndex)]
    
    internal override func _getNode() -> _TrieNode<Element>? {
        while !_stack.isEmpty {
            let (lastNode, index) = _stack.removeLast()
            if index < lastNode.nodesMap.endIndex {
                let appendingNode = lastNode.nodesMap[index].value.reversed()
                let nextIndex = lastNode.nodesMap.index(after: index)
                _stack.append((lastNode, nextIndex))
                _stack.append(contentsOf: appendingNode.map({($0, $0.nodesMap.startIndex)}))
            } else {
                return lastNode
            }
        }
        return nil
    }
}
