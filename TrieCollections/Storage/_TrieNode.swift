//
//  _TrieNode.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


internal struct _TrieNode<E: TriePrefixInterpretable> {
    internal typealias Element = E
    
    internal typealias TriePrefix = E.TriePrefix
    
    internal var _storage: _TrieNodeStorage<Element>
    
    internal init(prefix: TriePrefix?) {
        _storage = .init(prefix: prefix)
    }
    
    internal var prefix: TriePrefix? { return _storage.prefix }
    
    internal var nodesMap: [Int: [_TrieNode<Element>]] {
        return _storage.nodesMap
    }
    
    internal var elements: [Element] { return _storage.elements }
    
    internal var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    internal mutating func _withDedicatedStorage<R>(
        _ closure: (_TrieNodeStorage<Element>) -> R
        ) -> R
    {
        if !isKnownUniquelyReferenced(&_storage) {
            _storage = .init(storage: _storage)
        }
        return closure(_storage)
    }
    
    internal func member(
        _ element: Element,
        with prefixes: inout [TriePrefix]
        ) -> Element?
    {
        var node = self
        
        for prefix in prefixes {
            let hashValue = prefix.hashValue
            if let nodes = node.nodesMap[hashValue] {
                if let index = nodes.index(where: {$0.prefix == prefix}) {
                    node = nodes[index]
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        if let index = node.elements.index(of: element) {
            return node.elements[index]
        } else {
            return nil
        }
    }
    
    @discardableResult
    internal mutating func insert(
        _ element: Element,
        forces: Bool,
        with prefix: inout [TriePrefix]
        ) -> (inserted: Bool, memberAfterInsert: Element)
    {
        return _withDedicatedStorage {
            $0.insert(element, forces: forces, with: &prefix)
        }
    }
    
    @discardableResult
    internal mutating func remove(
        _ element: Element,
        with prefix: inout [TriePrefix]
        ) -> Element?
    {
        return _withDedicatedStorage {
            $0.remove(element, with: &prefix)
        }
    }
    
    internal mutating func removeAll() {
        return _withDedicatedStorage { $0.removeAll() }
    }
    
    internal var allElements: [Element] {
        let elements = nodesMap.values.map({$0.map({$0.allElements})}).flatMap({$0}).flatMap({$0})
        
        return elements + self.elements
    }
}


extension _TrieNode: CustomStringConvertible {
    internal var description: String {
        return "<\(type(of: self)): Storage = \(Unmanaged.passUnretained(_storage).toOpaque())>"
    }
}


extension _TrieNode: Equatable {
    internal static func == (lhs: _TrieNode, rhs: _TrieNode) -> Bool {
        return lhs._storage == rhs._storage
    }
}
