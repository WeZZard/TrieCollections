//
//  _TrieStorage.swift
//  TrieCollection
//
//  Created on 7/30/18.
//


/// A really naïve implementation, but works.
///
internal class _TrieStorage<E: TriePrefixInterpretable> {
    internal typealias Element = E
    
    internal typealias TriePrefix = E.TriePrefix
    
    internal typealias Node = _TrieNode<Element>
    
    internal var node: _TrieNode<Element>
    
    internal var count: Int
    
    internal init() {
        node = .init(prefix: nil)
        count = 0
    }
    
    internal convenience init<S: Sequence>(_ elements: S) where
        S.Element == E
    {
        self.init()
        for eachElement in elements {
            insert(eachElement)
        }
    }
    
    internal init(storage: _TrieStorage) {
        node = storage.node
        count = storage.count
    }
    
    @discardableResult
    internal func insert(_ element: Element)
        -> (inserted: Bool, memberAfterInsert: Element)
    {
        var prefixes = element.triePrefixes
        
        let (inserted, elementAfterInsert) = node.insert(
            element,
            forces: false,
            with: &prefixes
        )
        
        if inserted {
            count += 1
        }
        
        return (inserted, elementAfterInsert)
    }
    
    @discardableResult
    internal func update(with element: Element) -> Element? {
        var prefixes = element.triePrefixes
        
        let (inserted, elementAfterInsert) = node.insert(
            element,
            forces: true,
            with: &prefixes
        )
        
        if inserted {
            count += 1
        }
        
        return elementAfterInsert
    }
    
    internal func member(_ element: Element) -> Element? {
        var prefixes = element.triePrefixes
        
        return node.member(element, with: &prefixes)
    }
    
    @discardableResult
    internal func remove(_ element: Element) -> Element? {
        var prefixes = element.triePrefixes
        
        let oldElement = node.remove(element, with: &prefixes)
        
        if oldElement != nil {
            count -= 1
        }
        
        return oldElement
    }
    
    internal func removeAll(keepingCapacity: Bool) {
        node.removeAll()
        count = 0
    }
    
    internal func filter(withPrefixes prefixes: [TriePrefix]) -> [Element] {
        var node = self.node
        
        for prefix in prefixes {
            let hashValue = prefix.hashValue
            if let nodes = node.nodesMap[hashValue] {
                if let index = nodes.index(where: {$0.prefix == prefix}) {
                    node = nodes[index]
                } else {
                    return []
                }
            } else {
                return []
            }
        }
        
        return node.allElements
    }
}


extension _TrieStorage: Equatable {
    public static func == (lhs: _TrieStorage, rhs: _TrieStorage)
        -> Bool
    {
        if lhs === rhs { return true }
        
        return lhs.node == rhs.node
    }
}
