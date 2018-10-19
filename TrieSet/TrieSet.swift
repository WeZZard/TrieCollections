//
//  TrieSet.swift
//  TrieSet
//
//  Created on 7/24/18.
//


// MARK: TrieSet
public struct TrieSet<E: TriePrefixing> {
    public typealias TriePrefix = E.TriePrefix
    
    internal var _storage: _TrieSetStorage<E>
    
    public init() {
        _storage = .init()
    }
    
    public init<S: Sequence>(_ elements: S) where S.Element == E {
        _storage = .init()
        for eachElement in elements {
            insert(eachElement)
        }
    }
    
    mutating func _withDedicatedStorage<R>(
        _ closure: (_TrieSetStorage<E>) -> R
        ) -> R
    {
        if !isKnownUniquelyReferenced(&_storage) {
            _storage = .init(storage: _storage)
        }
        return closure(_storage)
    }
}


extension TrieSet {
    @discardableResult
    public mutating func insert(_ element: Element)
        -> (inserted: Bool, memberAfterInsert: Element)
    {
        return _withDedicatedStorage { (storage) in
            return storage.insert(element)
        }
    }
    
    @discardableResult
    public mutating func remove(_ element: Element) -> Element? {
        return _withDedicatedStorage { (storage) in
            return storage.remove(element)
        }
    }
    
    @discardableResult
    public mutating func remove(at index: Index) -> Element {
        let element = self[index]
        return _withDedicatedStorage { (storage) in
            storage.remove(element)
            return element
        }
    }
    
    public mutating func removeAll(keepingCapacity: Bool = false) {
        return _withDedicatedStorage { (storage) in
            return storage.removeAll(keepingCapacity: keepingCapacity)
        }
    }
}


// MARK: Views
extension TrieSet {
    public var breadthFirstView: TrieSetBreadthFirstView<E> {
        return .init(trieSet: self)
    }
    
    public var depthFirstView: TrieSetDepthFirstView<E> {
        return .init(trieSet: self)
    }
}


// MARK: Partitioning the Trie Set
extension TrieSet {
    public func partitions(by depth: Int) -> [[Element]] {
        return _storage.partitions(by: depth)
    }
}


// MARK: Filtering the Trie Set
extension TrieSet {
    public func filter(withPrefixes prefixes: [TriePrefix]) -> [Element] {
        return _storage.filter(withPrefixes: prefixes)
    }
}


extension TrieSet: Sequence {
    public typealias Iterator = TrieSetDepthFirstIterator<Element>
    
    public func makeIterator() -> Iterator {
        return Iterator(trieSet: self)
    }
}


extension TrieSet: Collection {
    public typealias Element = E
    
    public typealias Index = TrieSetIndex
    
    public var startIndex: Index {
        return Index(offset: 0)
    }
    
    public var endIndex: Index {
        return Index(offset: _storage.count)
    }
    
    public subscript(index: Index) -> Element {
        var iterator = makeIterator()
        var element: Element?
        for _ in 0...index._offset {
            element = iterator.next()
        }
        return element!
    }
    
    public func index(after i: Index) -> Index {
        return Index(offset: i._offset + 1)
    }
    
    public func contains(_ element: Element) -> Bool {
        return _storage.contains(element)
    }
}


extension TrieSet: Equatable {
    public static func == (lhs: TrieSet, rhs: TrieSet) -> Bool {
        return lhs._storage == rhs._storage
    }
}


extension TrieSet: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}
