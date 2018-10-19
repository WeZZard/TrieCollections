//
//  _TrieSetStorage.swift
//  TrieSet
//
//  Created on 7/30/18.
//


/// A really naïve implementation, but works.
///
internal class _TrieSetStorage<E: TriePrefixing> {
    internal typealias Element = E
    
    internal typealias TriePrefix = E.TriePrefix
    
    internal typealias Node = _TrieNode<Element>
    
    internal var node: _TrieNode<Element>
    
    internal var count: Int
    
    internal init() {
        node = .init(prefix: nil)
        count = 0
    }
    
    internal init(storage: _TrieSetStorage) {
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
            with: &prefixes
        )
        
        if inserted {
            count += 1
        }
        
        return (inserted, elementAfterInsert)
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
    
    internal func contains(_ element: Element) -> Bool {
        var prefixes = element.triePrefixes
        
        return node.contains(element, with: &prefixes)
    }
    
    internal func removeAll(keepingCapacity: Bool) {
        node.removeAll()
    }
    
    func partitions(by depth: Int) -> [[Element]] {
        var nodes = [node]
        var nodesAtDepth = [_TrieNode<Element>]()
        
        for _ in 0...depth {
            nodesAtDepth = nodes.map({$0.nodesMap.values.flatMap({$0})})
                .flatMap({$0})
            (nodes, nodesAtDepth) = (nodesAtDepth, nodes)
        }
        
        return nodesAtDepth.map({$0.allElements})
    }
    
    func filter(withPrefixes prefixes: [TriePrefix]) -> [Element] {
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


extension _TrieSetStorage: Equatable {
    public static func == (lhs: _TrieSetStorage, rhs: _TrieSetStorage)
        -> Bool
    {
        if lhs === rhs { return true }
        
        return lhs.node == rhs.node
    }
}
