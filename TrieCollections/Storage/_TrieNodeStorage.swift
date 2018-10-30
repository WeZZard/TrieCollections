//
//  _TrieNodeStorage.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


internal class _TrieNodeStorage<E: TriePrefixInterpretable> {
    internal typealias Element = E
    
    internal typealias TriePrefix = E.TriePrefix
    
    internal let prefix: TriePrefix?
    
    internal var elements: [Element]
    
    internal var nodesMap: [Int: [_TrieNode<Element>]]
    
    internal var isEmpty: Bool {
        return nodesMap.isEmpty && elements.isEmpty
    }
    
    internal init(prefix: TriePrefix?) {
        self.prefix = prefix
        elements = []
        nodesMap = [:]
    }
    
    internal init(storage: _TrieNodeStorage) {
        prefix = storage.prefix
        elements = storage.elements
        nodesMap = storage.nodesMap
    }
    
    @discardableResult
    internal func insert(
        _ element: Element,
        forces: Bool,
        with prefixes: inout [TriePrefix]
        ) -> (inserted: Bool, memberAfterInsert: Element)
    {
        if !prefixes.isEmpty {
            let prefix = prefixes.removeFirst()
            let hashValue = prefix.hashValue
            if var nodes = nodesMap[hashValue] {
                if let index = nodes.index(where: {$0.prefix == prefix}) {
                    let result = nodes[index].insert(
                        element,
                        forces: forces,
                        with: &prefixes
                    )
                    nodesMap[hashValue] = nodes
                    return result
                } else {
                    var node = _TrieNode<Element>(prefix: prefix)
                    let result = node.insert(
                        element,
                        forces: forces,
                        with: &prefixes
                    )
                    nodes.append(node)
                    nodesMap[hashValue] = nodes
                    return result
                }
            } else {
                var node = _TrieNode<Element>(prefix: prefix)
                let result = node.insert(
                    element,
                    forces: forces,
                    with: &prefixes
                )
                nodesMap[hashValue] = [node]
                return result
            }
        } else {
            if let index = elements.index(of: element) {
                let oldElement = elements[index]
                if forces {
                    elements[index] = element
                }
                return (false, oldElement)
            } else {
                elements.append(element)
                return (true, element)
            }
        }
    }
    
    @discardableResult
    internal func remove(
        _ element: Element,
        with prefixes: inout [TriePrefix]
        ) -> Element?
    {
        if !prefixes.isEmpty {
            let prefix = prefixes.removeFirst()
            let hashValue = prefix.hashValue
            if var nodes = nodesMap[hashValue] {
                if let index = nodes.index(where: {$0.prefix == prefix}) {
                    let removedElement = nodes[index].remove(
                        element,
                        with: &prefixes
                    )
                    if nodes[index].isEmpty {
                        nodes.remove(at: index)
                    }
                    if nodes.isEmpty {
                        nodesMap[hashValue] = nil
                    } else {
                        nodesMap[hashValue] = nodes
                    }
                    
                    return removedElement
                }
                return nil
            } else {
                return nil
            }
        } else {
            if let index = elements.index(of: element) {
                return elements.remove(at: index)
            } else {
                return nil
            }
        }
    }
    
    internal func removeAll() {
        elements.removeAll()
        
        for key in nodesMap.keys {
            nodesMap[key]!.removeAll()
        }
        
        nodesMap.removeAll()
    }
}


extension _TrieNodeStorage: Equatable {
    internal static func == (lhs: _TrieNodeStorage, rhs: _TrieNodeStorage)
        -> Bool
    {
        if lhs === rhs { return true }
        
        if lhs.prefix != rhs.prefix {
            return false
        }
        
        if !lhs.elements._isEqualTo(contentsOf: rhs.elements) {
            return false
        }
        
        if lhs.nodesMap.count != rhs.nodesMap.count {
            return false
        }
        
        let keys = Set(lhs.nodesMap.keys).union(rhs.nodesMap.keys)
        
        for key in keys {
            guard let lhsNodes = lhs.nodesMap[key] else { return false }
            guard let rhsNodes = rhs.nodesMap[key] else { return false }
            
            if !lhsNodes._isEqualTo(contentsOf: rhsNodes) {
                return false
            }
        }
        
        return true
    }
}
