//
//  _TrieNodeStorageTests.swift
//  TrieCollections
//
//  Created on 28/10/2018.
//

import XCTest

@testable
import TrieCollections


class _TrieNodeStorageTests: XCTestCase {
    // MARK: Init
    func testInit_doesNotThrow() {
        XCTAssertNoThrow(_TrieNodeStorage<TrieKey>(prefix: nil))
    }
    
    func testInit_createsEmptyStorage() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    // MARK: Init with Storage
    func testInitWithStorage_createsStorageOfTheSameContent() {
        let prefix = TrieKeyPrefix.stringA("")
        let storage = _TrieNodeStorage<TrieKey>(prefix: prefix)
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == prefix)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        _ = storage.insert(element, forces: false, with: &triePrefixes)
        
        let copiedStorage = _TrieNodeStorage(storage: storage)
        
        XCTAssert(storage.prefix == copiedStorage.prefix)
        XCTAssert(storage.elements == copiedStorage.elements)
        XCTAssert(storage.nodesMap == copiedStorage.nodesMap)
    }
    
    // MARK: Insert Element Forces with Prefixes
    func testInsertElementForcesWithPrefixes_returnsTrueAndInsertedElement_withNotContainedElementAndFalse_whosePrefixPathLengthIsZero() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsTrueAndInsertedElement_withNotContainedElementAndTrue_whosePrefixPathLengthIsZero() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: true, with: &prefixes)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsTrueAndInsertedElement_withNotContainedElementAndFalse_whosePrefixPathLengthIsZero_whereThereIsAnElementOfZeroPrefix() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element0 = TrieKey(prompt: "")
        var prefixes0 = element0.triePrefixes
        storage.insert(element0, forces: false, with: &prefixes0)
        
        let element = TrieKey(prompt: "A")
        var prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsTrueAndInsertedElement_withNotContainedElementAndTrue_whosePrefixPathLengthIsZero_whereThereIsAnElementOfZeroPrefix() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element0 = TrieKey(prompt: "")
        var prefixes0 = element0.triePrefixes
        storage.insert(element0, forces: false, with: &prefixes0)
        
        let element = TrieKey(prompt: "A")
        var prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: true, with: &prefixes)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsTrueAndInsertedElement_withNotContainedElementAndFalse_whosePrefixPathLengthIsOne_whereThereIsAnElementOfZeroPrefix() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element0 = TrieKey(prompt: "")
        var prefixes0 = element0.triePrefixes
        storage.insert(element0, forces: false, with: &prefixes0)
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsTrueAndInsertedElement_withNotContainedElementAndTrue_whosePrefixPathLengthIsOne_whereThereIsAnElementOfZeroPrefix() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element0 = TrieKey(prompt: "")
        var prefixes0 = element0.triePrefixes
        storage.insert(element0, forces: false, with: &prefixes0)
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: true, with: &prefixes)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsFalseAndOldElement_withContainedElementAndFalse() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(!isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsFalseAndOldElement_withContainedElementAndTrue() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        prefixes = element.triePrefixes
        
        let (isInserted, elementAfterInsert) = storage.insert(element, forces: true, with: &prefixes)
        
        XCTAssert(!isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsFalseAndOldElement_withElementWhichEqualsToSomeMemeberButWithDifferentReferenceAndFalse() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        
        var prefixes = element.triePrefixes
        var anotherPrefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let (isInserted, elementAfterInsert) = storage.insert(anotherElement, forces: false, with: &anotherPrefixes)
        
        XCTAssert(!isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_returnsFalseAndOldElement_withElementWhichEqualsToSomeMemeberButWithDifferentReferenceAndTrue() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        
        var prefixes = element.triePrefixes
        var anotherPrefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let (isInserted, elementAfterInsert) = storage.insert(anotherElement, forces: true, with: &anotherPrefixes)
        
        XCTAssert(!isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElementForcesWithPrefixes_exhaustsPrefixes() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes = element.triePrefixes
        
        XCTAssert(!prefixes.isEmpty)
        
        storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(prefixes.isEmpty)
    }
    
    func testInsertElementForcesWithPrefixes_insertsElement_withNotContainedElementAndFalse() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [])
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [element])
        XCTAssert(storage.nodesMap == [:])
    }
    
    func testInsertElementForcesWithPrefixes_insertsElement_withNotContainedElementAndTrue() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [])
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: true, with: &prefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [element])
        XCTAssert(storage.nodesMap == [:])
    }
    
    func testInsertElementForcesWithPrefixes_doesNotInsertElement_withElementWhichEqualsToSomeMemeberButWithDifferentReferenceAndFalse() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [])
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let anotherElement = TrieKey(prompt: "", components: [])
        var anotherPrefixes = anotherElement.triePrefixes
        
        storage.insert(anotherElement, forces: false, with: &anotherPrefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [element])
        XCTAssert(storage.nodesMap == [:])
    }
    
    func testInsertElementForcesWithPrefixes_insertsElement_withElementWhichEqualsToSomeMemeberButWithDifferentReferenceAndTrue() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [])
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let anotherElement = TrieKey(prompt: "", components: [])
        var anotherPrefixes = anotherElement.triePrefixes
        
        storage.insert(anotherElement, forces: true, with: &anotherPrefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [anotherElement])
        XCTAssert(storage.nodesMap == [:])
    }
    
    func testInsertElementForcesWithPrefixes_buildsNodeMap_withElementHasPrefixesGreaterThanZero() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes = element.triePrefixes
        
        XCTAssert(storage.nodesMap == [:])
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let prefixesI = element.triePrefixes
        
        let node2 = _TrieNode<TrieKey>(prefix: prefixesI[0])
        node2._storage.elements = [element]
        node2._storage.nodesMap = [:]
        
        XCTAssert(storage.nodesMap == [prefixesI[0].hashValue : [node2]])
    }
    
    // MARK: Remove Element with Prefixes
    func testRemoveElementWithPrefixes_returnsNil_withNotContainedElement() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        let removedElement = storage.remove(element, with: &prefixes)
        
        XCTAssert(removedElement == nil)
    }
    
    func testRemoveElementWithPrefixes_returnsElement_withContainedElement() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        prefixes = element.triePrefixes
        
        let removedElement = storage.remove(element, with: &prefixes)
        
        XCTAssert(removedElement === element)
    }
    
    func testRemoveElementWithPrefixes_returnsElement_withElementWhichEqualsToSomeMemeberButWithDifferentReference() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        let anotherElement = TrieKey(prompt: "")
        var anotherPrefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        prefixes = element.triePrefixes
        
        let removedElement = storage.remove(anotherElement, with: &anotherPrefixes)
        
        XCTAssert(removedElement === element)
    }
    
    func testRemoveElementWithPrefixes_exhaustsPrefixes() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes = element.triePrefixes
        
        XCTAssert(!prefixes.isEmpty)
        
        storage.remove(element, with: &prefixes)
        
        XCTAssert(prefixes.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_removesElement_withContainedElement() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        prefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [element])
        XCTAssert(storage.nodesMap == [:])
        
        storage.remove(element, with: &prefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [])
        XCTAssert(storage.nodesMap == [:])
    }
    
    func testRemoveElementWithPrefixes_removesElement_withElementWhichEqualsToSomeMemeberButWithDifferentReference() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        
        let anotherElement = TrieKey(prompt: "")
        var anotherPrefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        prefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [element])
        XCTAssert(storage.nodesMap == [:])
        
        storage.remove(anotherElement, with: &anotherPrefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [])
        XCTAssert(storage.nodesMap == [:])
    }
    
    // MARK: Remove All
    func testRemoveAll_removesAllElements_withElementOfZeroPrefixes() {
        let element = TrieKey(prompt: "")
        
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [element])
        XCTAssert(storage.nodesMap.isEmpty)
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveAll_removesAllElements_withElementOfOnePrefix() {
        let element = TrieKey(prompt: "", components: [.stringA("")])
        
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let prefixesI = element.triePrefixes
        
        let node2 = _TrieNode<TrieKey>(prefix: prefixesI[0])
        node2._storage.elements = [element]
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [])
        XCTAssert(storage.nodesMap == [prefixesI[0].hashValue : [node2]])
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveAll_removesAllElements_withElementOfTwoPrefixes() {
        let element = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        var prefixes = element.triePrefixes
        
        storage.insert(element, forces: false, with: &prefixes)
        
        let prefixesI = element.triePrefixes
        
        let node3 = _TrieNode<TrieKey>(prefix: prefixesI[1])
        node3._storage.elements = [element]
        
        let node2 = _TrieNode<TrieKey>(prefix: prefixesI[0])
        node2._storage.nodesMap = [prefixesI[0].hashValue: [node3]]
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements == [])
        XCTAssert(storage.nodesMap == [prefixesI[0].hashValue : [node2]])
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    // MARK: Equal
    func testEqual_returnsTrue_withEmptyNodes() {
        let storage1 = _TrieNodeStorage<TrieKey>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_returnsTrue_withStorageOfSameReferences() {
        let storage = _TrieNodeStorage<TrieKey>(prefix: nil)
        XCTAssert(storage == storage)
    }
    
    func testEqual_returnsFalse_withDifferentPrefixes() {
        let storage1 = _TrieNodeStorage<TrieKey>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieKey>(prefix: .stringA(""))
        
        XCTAssert(storage1 != storage2)
        XCTAssert(storage2 != storage1)
    }
    
    func testEqual_returnsTrue_withSameElementsAndSameInsertionOrder() {
        let storage1 = _TrieNodeStorage<TrieKey>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element1 = TrieKey(prompt: "")
        var prefixes1 = element1.triePrefixes
        var prefixes1Prime = element1.triePrefixes
        
        let element2 = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes2 = element2.triePrefixes
        var prefixes2Prime = element2.triePrefixes
        
        let element3 = TrieKey(prompt: "", components: [.stringA(""), .stringB("")])
        var prefixes3 = element3.triePrefixes
        var prefixes3Prime = element3.triePrefixes
        
        storage1.insert(element1, forces: false, with: &prefixes1)
        storage2.insert(element1, forces: false, with: &prefixes1Prime)
        
        storage1.insert(element2, forces: false, with: &prefixes2)
        storage2.insert(element2, forces: false, with: &prefixes2Prime)
        
        storage1.insert(element3, forces: false, with: &prefixes3)
        storage2.insert(element3, forces: false, with: &prefixes3Prime)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_returnsTrue_withSameElementsAndDifferentInsertionOrder() {
        let storage1 = _TrieNodeStorage<TrieKey>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element1 = TrieKey(prompt: "")
        var prefixes1 = element1.triePrefixes
        var prefixes1Prime = element1.triePrefixes
        
        let element2 = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes2 = element2.triePrefixes
        var prefixes2Prime = element2.triePrefixes
        
        let element3 = TrieKey(prompt: "", components: [.stringA(""), .stringB("")])
        var prefixes3 = element3.triePrefixes
        var prefixes3Prime = element3.triePrefixes
        
        storage1.insert(element1, forces: false, with: &prefixes1)
        storage1.insert(element2, forces: false, with: &prefixes2)
        storage1.insert(element3, forces: false, with: &prefixes3)
        
        storage2.insert(element3, forces: false, with: &prefixes3Prime)
        storage2.insert(element2, forces: false, with: &prefixes2Prime)
        storage2.insert(element1, forces: false, with: &prefixes1Prime)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_returnsFalse_withDifferentElements() {
        let storage1 = _TrieNodeStorage<TrieKey>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieKey>(prefix: nil)
        
        let element1 = TrieKey(prompt: "")
        var prefixes1 = element1.triePrefixes
        var prefixes1Prime = element1.triePrefixes
        
        let element2 = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes2 = element2.triePrefixes
        
        let element3 = TrieKey(prompt: "", components: [.stringA(""), .stringB("")])
        var prefixes3 = element3.triePrefixes
        
        storage1.insert(element1, forces: false, with: &prefixes1)
        storage1.insert(element2, forces: false, with: &prefixes2)
        storage1.insert(element3, forces: false, with: &prefixes3)
        
        storage2.insert(element1, forces: false, with: &prefixes1Prime)
        
        XCTAssert(storage1 != storage2)
        XCTAssert(storage2 != storage1)
    }
}

