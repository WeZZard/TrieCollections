//
//  Array+IsEqualToContentsOf.swift
//  TrieSet
//
//  Created on 19/10/2018.
//


extension Array where Element: Equatable {
    /// Compare the contents of two arrays without considering the order
    /// of their elements.
    ///
    /// - Complexity: 0(n * m)
    ///
    func _isEqualTo(contentsOf other: [Element]) -> Bool {
        guard count == other.count else {return false}
        for each in self {
            let equalElementsCount = filter({$0 == each}).count
            let otherEqualElementsCount = other.filter({$0 == each}).count
            if equalElementsCount != otherEqualElementsCount {
                return false
            }
        }
        return true
    }
}
