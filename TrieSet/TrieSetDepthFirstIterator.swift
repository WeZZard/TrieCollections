//
//  TrieSetDepthFirstIterator.swift
//  TrieSet
//
//  Created on 19/10/2018.
//


public struct TrieSetDepthFirstIterator<E: TriePrefixing>:
    IteratorProtocol
{
    public typealias Element = E
    
    internal typealias _Impl = _TrieSetDepthFirstIteratorImpl<Element>
    
    internal var _impl: _Impl
    
    public init(trieSetDepthFirstView: TrieSetDepthFirstView<E>) {
        self = .init(trieSet: trieSetDepthFirstView._trieSet)
    }
    
    public init(trieSet: TrieSet<E>) {
        _impl = .init(storage: trieSet._storage)
    }
    
    internal mutating func _withDedicatedImpl<R>(_ closure: (_Impl) -> R)
        -> R
    {
        if !isKnownUniquelyReferenced(&_impl) {
            _impl = .init(impl: _impl)
        }
        return closure(_impl)
    }
    
    public mutating func next() -> Element? {
        return _withDedicatedImpl({$0.next()})
    }
}
