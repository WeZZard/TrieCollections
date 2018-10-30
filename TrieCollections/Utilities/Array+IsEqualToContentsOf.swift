//
//  Array+IsEqualToContentsOf.swift
//  TrieCollection
//
//  Created on 19/10/2018.
//


extension Array {
    /// Predicates the contents of two arrays without considering the
    /// order of their elements.
    ///
    /// - Complexity: 0(n * m)
    ///
    internal func _predicates(_ predicate: (Element, Element) -> Bool, contentsOf other: [Element]) -> Bool {
        guard count == other.count else {return false}
        for each in self {
            let equalElementsCount = filter({predicate($0, each)}).count
            let otherEqualElementsCount = other.filter({predicate($0, each)}).count
            if equalElementsCount != otherEqualElementsCount {
                return false
            }
        }
        return true
    }
}


extension Array where Element: Equatable {
    internal func _isEqualTo(contentsOf other: [Element]) -> Bool {
        return _predicates(==, contentsOf: other)
    }
}


extension Array where Element: _TrieKeyValueEquatable {
    internal func _isKeyValueEqualTo(contentsOf other: [Element]) -> Bool {
        return _predicates(Element.isKeyValueEqual, contentsOf: other)
    }
}
