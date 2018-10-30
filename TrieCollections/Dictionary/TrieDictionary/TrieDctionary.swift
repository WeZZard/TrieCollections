//
//  TrieDictionary.swift
//  TrieCollection
//
//  Created on 7/24/18.
//


// MARK: TrieDictionary
public struct TrieDictionary<K: TriePrefixInterpretable, V> {
    public typealias Key = K
    public typealias Value = V
    public typealias TriePrefix = K.TriePrefix
    
    internal typealias _KeyValueContainer = _TrieKeyValueContainer<K, V>
    internal typealias _Storage = _TrieStorage<_KeyValueContainer>
    
    internal var _storage: _Storage
    
    /// Creates an empty trie-dictionary.
    ///
    public init() {
        _storage = .init()
    }
    
    /// Creates a trie-dictionary with given elements.
    ///
    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
    
    internal mutating func _withDedicatedStorage<R>(
        _ closure: (_Storage) -> R
        ) -> R
    {
        if !isKnownUniquelyReferenced(&_storage) {
            _storage = .init(storage: _storage)
        }
        return closure(_storage)
    }
}


extension TrieDictionary {
    /// Accesses the value associated with the given key for reading and
    /// writing.
    ///
    /// - Parameter key: The key to find in the dictionary.
    ///
    /// - Returns: The value associated with `key` if `key` is in the
    /// dictionary; otherwise, `nil`.
    ///
    public subscript (key: Key) -> Value? {
        get { return _storage.member(.init(key: key))?.value }
        mutating set {
            if let newValue = newValue {
                updateValue(newValue, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    /// Accesses the value with the given key. If the dictionary doesn’t
    /// contain the given key, accesses the provided default value as if
    /// the key and default value existed in the dictionary.
    ///
    /// - Parameter key: The key the look up in the dictionary.
    ///
    /// - Parameter defaultValue: The default value to use if `key`
    /// doesn’t exist in the dictionary.
    ///
    /// - Returns: The value associated with `key` in the dictionary;
    /// otherwise, `defaultValue`.
    ///
    public subscript (
        key: Key,
        default defaultValue: @autoclosure () -> Value
        ) -> Value?
    {
        get { return _storage.member(.init(key: key))?.value }
        mutating set {
            updateValue(newValue ?? defaultValue(), forKey: key)
        }
    }
}


extension TrieDictionary {
    /// Updates the value stored in the dictionary for the given key, or
    /// adds a new key-value pair if the key does not exist.
    ///
    /// - Parameter value: The new value to add to the dictionary.
    ///
    /// - Parameter key: The key to associate with `value`. If `key`
    /// already exists in the dictionary, `value` replaces the existing
    /// associated value. If `key` isn’t already a key of the dictionary,
    /// the `(key, value)` pair is added.
    ///
    /// - Returns: The value that was replaced, or `nil` if a new key-
    /// value pair was added.
    ///
    @discardableResult
    public mutating func updateValue(_ value: Value, forKey key: Key)
        -> Value?
    {
        return _withDedicatedStorage { (storage) in
            let (isInserted, elementAfterInsert) = storage.insert(
                .init(key: key, value: value)
            )
            if isInserted {
                return nil
            } else {
                return elementAfterInsert.value
            }
        }
    }
    
    /// Removes the given key and its associated value from the
    /// dictionary.
    ///
    /// - Parameter key: The key to remove along with its associated
    /// value.
    ///
    /// - Returns: The value that was removed, or `nil` if the key was not
    /// present in the dictionary.
    ///
    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        return _withDedicatedStorage { (storage) in
            storage.remove(.init(key: key))?.value
        }
    }
    
    /// Returns the index for the given key.
    ///
    /// - Parameter key: The key to find in the dictionary.
    ///
    /// - Returns: The index for `key` and its associated value if `key`
    /// is in the dictionary; otherwise, `nil`.
    ///
    public func index(forKey key: Key) -> Index? {
        for (offset, keyValue) in self.enumerated() {
            if key == keyValue.key {
                return TrieIndex(offset: offset)
            }
        }
        return nil
    }
    
    /// Removes and returns the key-value pair at the specified index.
    ///
    /// - Parameter index: The position of the key-value pair to remove.
    /// `index` must be a valid index of the dictionary, and must not
    /// equal the dictionary’s end index.
    ///
    /// - Returns: The key-value pair that correspond to index.
    ///
    @discardableResult
    public mutating func remove(at index: Index) -> Element {
        let (key, value) = self[index]
        return _withDedicatedStorage { (storage) in
            storage.remove(.init(key: key, value: value))
            return (key, value)
        }
    }
    
    /// Removes all key-value pairs from the dictionary.
    ///
    /// - Parameter keepingCapacity: Currently doesn't have any effect.
    ///
    public mutating func removeAll(keepingCapacity: Bool = false) {
        return _withDedicatedStorage { (storage) in
            return storage.removeAll(keepingCapacity: keepingCapacity)
        }
    }
}


// MARK: Filtering the Trie Dictionary
extension TrieDictionary {
    /// Filter elements in `TrieDictionary` with given prefixes.
    ///
    /// The order of the filtered elements is not guaranteed.
    ///
    /// - Parameter prefixes: Given prefixes
    ///
    /// - Returns: Element contains given prefix path.
    ///
    public func filter(withPrefixes prefixes: [TriePrefix]) -> [Element] {
        return _storage.filter(withPrefixes: prefixes).map({$0.keyValuePair})
    }
}


// MARK: Views
extension TrieDictionary {
    /// The breadth-first view of the `TrieDictionary`.
    ///
    /// This property is highly implementation-dependent, and is planned
    /// to be removed in future release.
    ///
    public var breadthFirstView: TrieDictionaryBreadthFirstView<K, V> {
        return .init(trieDictionary: self)
    }
    
    /// The depth-first view of the `TrieDictionary`.
    ///
    /// This property is highly implementation-dependent, and is planned
    /// to be removed in future release.
    ///
    public var depthFirstView: TrieDictionaryDepthFirstView<K, V> {
        return .init(trieDictionary: self)
    }
}


extension TrieDictionary {
    /// A collection containing just the keys of the dictionary.
    public var keys: TrieDictionaryKeys<Key, Value> {
        return .init(trieDictionary: self)
    }
    
    /// A collection containing just the values of the dictionary.
    public var values: TrieDictionaryValues<Key, Value> {
        return .init(trieDictionary: self)
    }
}


extension TrieDictionary: Sequence {
    public typealias Iterator = TrieDictionaryDepthFirstIterator<K, V>
    
    public func makeIterator() -> Iterator {
        return Iterator(trieDictionary: self)
    }
}


extension TrieDictionary: Collection {
    public typealias Element = (key: Key, value: Value)
    
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
}


extension TrieDictionary: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}


extension TrieDictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}


extension TrieDictionary: Equatable where V: Equatable {
    public static func ==(lhs: TrieDictionary, rhs: TrieDictionary)
        -> Bool
    {
        return _TrieStorage.isKeyValueEqual(
            lhs: lhs._storage,
            rhs: rhs._storage
        )
    }
}
