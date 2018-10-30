//
//  TrieCollectionDepthFirstIterator.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


public struct TrieDictionaryDepthFirstIterator<
    K: TriePrefixInterpretable,
    V
    >: IteratorProtocol
{
    public typealias Key = K
    public typealias Value = V
    public typealias Element = (key: Key, value: Value)
    
    internal typealias _KeyValueContainer = _TrieKeyValueContainer<K, V>
    internal typealias _Impl = _TrieDepthFirstIteratorImpl<_KeyValueContainer>
    
    internal var _impl: _Impl
    
    public init(view: TrieDictionaryDepthFirstView<K, V>) {
        self = .init(trieDictionary: view._trieDictionary)
    }
    
    public init(trieDictionary: TrieDictionary<K, V>) {
        _impl = .init(storage: trieDictionary._storage)
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
        return _withDedicatedImpl({$0.next()?.keyValuePair})
    }
}
