//
//  TrieSet.swift
//  TrieCollection
//
//  Created on 7/24/18.
//


// MARK: TrieSet
public struct TrieSet<E: TriePrefixInterpretable> {
    public typealias TriePrefix = E.TriePrefix
    
    internal var _storage: _TrieStorage<E>
    
    /// Creates an empty trie-set.
    ///
    public init() {
        _storage = .init()
    }
    
    /// Creates a trie-set with given elements.
    ///
    public init<S: Sequence>(_ elements: S) where S.Element == E {
        _storage = .init()
        for each in elements {
            insert(each)
        }
    }
    
    internal mutating func _withDedicatedStorage<R>(
        _ closure: (_TrieStorage<E>) -> R
        ) -> R
    {
        if !isKnownUniquelyReferenced(&_storage) {
            _storage = .init(storage: _storage)
        }
        return closure(_storage)
    }
}


extension TrieSet {
    /// Inserts the given element in the set if it is not already present.
    ///
    /// If an element equal to `element` is already contained in the set,
    /// this method has no effect.
    ///
    /// - Parameter element: An element to insert into the set.
    ///
    /// - Returns: `(true, element)` if `element` was not contained in the
    /// set. If an element equal to `element` was already contained in the
    /// set, the function returns `(false, oldElement)`, where
    /// `oldElement` is the element that was equal to element. In some
    /// cases, `oldElement` may be distinguishable from element by
    /// identity comparison or some other means.
    ///
    @discardableResult
    public mutating func insert(_ element: Element)
        -> (inserted: Bool, memberAfterInsert: Element)
    {
        return _withDedicatedStorage { (storage) in
            return storage.insert(element)
        }
    }
    
    /// Inserts the given element into the set unconditionally.
    ///
    /// If an element equal to `element` is already contained in the set,
    /// `element` replaces the existing element.
    ///
    /// - Parameter element: An element to insert into the set.
    ///
    /// - Returns: An element equal to `element` if the set already
    /// contained such a member; otherwise, `nil`. In some cases, the
    /// returned element may be distinguishable from `element` by identity
    /// comparison or some other means.
    ///
    @discardableResult
    public mutating func update(with element: Element) -> Element? {
        return _withDedicatedStorage { (storage) in
            return storage.update(with: element)
        }
    }
    
    /// Removes the specified element from the set.
    ///
    /// - Parameter member: The element to remove from the set.
    ///
    /// - Returns: The value of the `member` parameter if it was a member
    /// of the set; otherwise, `nil`.
    ///
    @discardableResult
    public mutating func remove(_ element: Element) -> Element? {
        return _withDedicatedStorage { (storage) in
            return storage.remove(element)
        }
    }
    
    /// Removes the element at the given index of the set.
    ///
    /// - Parameter index: The index of the member to remove. `index` must
    /// be a valid index of the set, and must not be equal to the set’s
    /// end index.
    ///
    /// - Returns: The element that was removed from the set.
    ///
    @discardableResult
    public mutating func remove(at index: Index) -> Element {
        let element = self[index]
        return _withDedicatedStorage { (storage) in
            storage.remove(element)
            return element
        }
    }
    
    /// Removes all members from the set.
    ///
    /// - Parameter keepingCapacity: Currently doesn't have any effect.
    ///
    public mutating func removeAll(keepingCapacity: Bool = false) {
        return _withDedicatedStorage { (storage) in
            return storage.removeAll(keepingCapacity: keepingCapacity)
        }
    }
}


// MARK: Filtering the Trie Set
extension TrieSet {
    /// Filter elements in `TrieSet` with given prefixes.
    ///
    /// The order of the filtered elements is not guaranteed.
    ///
    /// - Parameter prefixes: Given prefixes
    ///
    /// - Returns: Element contains given prefix path.
    ///
    public func filter(withPrefixes prefixes: [TriePrefix]) -> [Element] {
        return _storage.filter(withPrefixes: prefixes)
    }
}


// MARK: Views
extension TrieSet {
    /// The breadth-first view of the `TrieSet`.
    ///
    /// This property is highly implementation-dependent, and is planned
    /// to be removed in future release.
    ///
    public var breadthFirstView: TrieSetBreadthFirstView<E> {
        return .init(trieSet: self)
    }
    
    /// The depth-first view of the `TrieSet`.
    ///
    /// This property is highly implementation-dependent, and is planned
    /// to be removed in future release.
    ///
    public var depthFirstView: TrieSetDepthFirstView<E> {
        return .init(trieSet: self)
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
    
    public typealias Index = TrieIndex
    
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
    
    /// Returns a Boolean value that indicates whether the given element
    /// exists in the set.
    ///
    public func contains(_ element: Element) -> Bool {
        return _storage.member(element) != nil
    }
}


extension TrieSet: Equatable {
    public static func == (lhs: TrieSet, rhs: TrieSet) -> Bool {
        return lhs._storage == rhs._storage
    }
}


extension TrieSet: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init()
        for each in elements {
            insert(each)
        }
    }
}
