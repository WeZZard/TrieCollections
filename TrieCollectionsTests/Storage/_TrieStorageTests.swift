//
//  _TrieStorageTests.swift
//  TrieSet
//
//  Created on 7/30/18.
//

import XCTest

@testable
import TrieCollections


class _TrieStorageTests: XCTestCase {
    // MARK: Init
    func testInit_doesNotThrow() {
        XCTAssertNoThrow(_TrieStorage<TrieKey>())
    }
    
    func testInit_createsEmptyStorage() {
        let storage = _TrieStorage<TrieKey>()
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        XCTAssert(storage.count == 0)
    }
    
    // MARK: Init with Storage
    func testInitWithStorage_doesNotThrow() {
        let storage = _TrieStorage<TrieKey>()
        
        XCTAssertNoThrow(_TrieStorage(storage: storage))
    }
    
    func testInitWithStorage_createsStorageOfTheSameContent() {
        let element = TrieKey(prompt: "", components: [.stringA("")])
        let storage = _TrieStorage<TrieKey>([element])
        
        let anotherStorage = _TrieStorage(storage: storage)
        
        XCTAssert(storage.node._storage.prefix == anotherStorage.node._storage.prefix)
        XCTAssert(storage.node._storage.elements == anotherStorage.node._storage.elements)
        XCTAssert(storage.node._storage.nodesMap == anotherStorage.node._storage.nodesMap)
        XCTAssert(storage.count == anotherStorage.count)
    }
    
    // MARK: Init with Elements
    func testInitWithElements_createsEmptyStorage_withEmptyElements() {
        let storage = _TrieStorage<TrieKey>([])
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        XCTAssert(storage.count == 0)
    }
    
    func testInitWithElements_createsNonEmptyStorage_withNonEmptyElements() {
        let element = TrieKey(prompt: "", components: [.stringA("")])
        let storage = _TrieStorage<TrieKey>([element])
        
        let prefixes = element.triePrefixes
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]!.count == 1)
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]![0].prefix == prefixes[0])
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]![0].elements == [element])
        XCTAssert(storage.count == 1)
    }
    
    // MARK: Insert
    func testInsertElement_returnsTrueAndInsertedElement_withNotContainedElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        
        let (isInserted, elementAfterInsert) = storage.insert(element)
        
        XCTAssert(isInserted)
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testInsertElement_returnsFalseAndOldElement_withContainedElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        
        storage.insert(element)
        
        let (isInserted2, elementAfterInsert2) = storage.insert(element)
        
        XCTAssert(!isInserted2)
        XCTAssert(elementAfterInsert2 == element)
        XCTAssert(elementAfterInsert2 === element)
    }
    
    func testInsertElement_returnsFalseAndOldElement_withElementWhichEqualsToSomeMemeberButWithDifferentReference() {
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(element == anotherElement)
        
        let (isInserted2, elementAfterInsert2) = storage.insert(anotherElement)
        
        XCTAssert(!isInserted2)
        XCTAssert(elementAfterInsert2 == element)
        XCTAssert(elementAfterInsert2 === element)
        XCTAssert(elementAfterInsert2 !== anotherElement)
    }
    
    func testInsertElement_insertsElement_withElementOfZeroPrefixes() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        
        storage.insert(element)
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [element])
    }
    
    func testInsertElement_doesNotInsertElement_withDuplicateElement() {
        
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [element])
        
        storage.insert(anotherElement)
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [element])
    }
    
    func testInsertElement_insertsElement_withElementOfOnePrefix() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        
        storage.insert(element)
        
        let prefixes = element.triePrefixes
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]!.count == 1)
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]![0].prefix == prefixes[0])
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]![0].elements == [element])
    }
    
    func testInsertElement_increaseCount_withNotEqualElement() {
        let element = TrieKey(prompt: "")
        let notEqualElement = TrieKey(prompt: "A")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.count == 1)
        
        storage.insert(notEqualElement)
        
        XCTAssert(storage.count == 2)
    }
    
    func testInsertElement_doesNotIncreaseCount_withEqualElement() {
        let element = TrieKey(prompt: "")
        let equalElement = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.count == 1)
        
        storage.insert(equalElement)
        
        XCTAssert(storage.count == 1)
    }
    
    // MARK: Update with Element
    func testUpdateWithElement_returnsInsertedElement_withNotContainedElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        
        let elementAfterInsert = storage.update(with: element)
        
        XCTAssert(elementAfterInsert == element)
        XCTAssert(elementAfterInsert === element)
    }
    
    func testUpdateWithElement_returnsOldElement_withContainedElement() {
        let element = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        let elementAfterInsert2 = storage.update(with: element)
        
        XCTAssert(elementAfterInsert2 == element)
        XCTAssert(elementAfterInsert2 === element)
    }
    
    func testUpdateWithElement_returnsOldElement_withElementWhichEqualsToSomeMemeberButWithDifferentReference() {
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(element == anotherElement)
        
        let elementAfterInsert2 = storage.update(with: anotherElement)
        
        XCTAssert(elementAfterInsert2 == element)
        XCTAssert(elementAfterInsert2 === element)
        XCTAssert(elementAfterInsert2 !== anotherElement)
    }
    
    func testUpdateWithElement_insertsElement_withElementOfZeroPrefixes() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        
        storage.update(with: element)
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [element])
    }
    
    func testUpdateWithElement_insertsElement_withDuplicateElement() {
        
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [element])
        
        storage.update(with: anotherElement)
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [anotherElement])
    }
    
    func testUpdateWithElement_insertsElement_withElementOfOnePrefix() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        
        storage.update(with: element)
        
        let prefixes = element.triePrefixes
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]!.count == 1)
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]![0].prefix == prefixes[0])
        XCTAssert(storage.node._storage.nodesMap[prefixes[0].hashValue]![0].elements == [element])
    }
    
    func testUpdateWithElement_increaseCount_withNotEqualElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        let notEqualElement = TrieKey(prompt: "A")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.update(with: notEqualElement)
        
        XCTAssert(storage.count == 2)
    }
    
    func testUpdateWithElement_doesNotIncreaseCount_withEqualElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        let equalElement = TrieKey(prompt: "")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.update(with: equalElement)
        
        XCTAssert(storage.count == 1)
    }
    
    // MARK: Memeber
    func testMember_returnsElement_withContainedElement() {
        let element = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.member(element) == element)
        XCTAssert(storage.member(element) === element)
    }
    
    func testMember_returnsElement_withElementWhichEqualsToSomeMemeberButWithDifferentReference() {
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.member(anotherElement) == element)
        XCTAssert(storage.member(anotherElement) === element)
    }
    
    func testMember_returnsNil_withNotContainedElement() {
        let element = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>()
        
        XCTAssert(storage.member(element) == nil)
    }
    
    // MARK: Remove
    func testRemoveElement_returnsElement_withContainedElement() {
        let element = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        let removed = storage.remove(element)
        
        XCTAssert(removed == element)
    }
    
    func testRemoveElement_returnsNil_withNotContainedElement() {
        let element = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>()
        
        let removed = storage.remove(element)
        
        XCTAssert(removed == nil)
    }
    
    func testRemoveElement_removesElement_withContainedElement() {
        let element = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.node.elements == [element])
        
        storage.remove(element)
        
        XCTAssert(storage.node.elements == [])
    }
    
    func testRemoveElement_removesElement_withElementWhichEqualsToSomeMemeberButWithDifferentReference() {
        let element = TrieKey(prompt: "")
        let anotherElement = TrieKey(prompt: "")
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.node.elements == [element])
        
        storage.remove(anotherElement)
        
        XCTAssert(storage.node.elements == [])
    }
    
    func testRemoveElement_doesNotDecreaseCount_withNotContainedElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        let element2 = TrieKey(prompt: "A")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.remove(element2)
        
        XCTAssert(storage.count == 1)
    }
    
    func testRemoveElement_decreasesCount_withContainedElement() {
        let storage = _TrieStorage<TrieKey>()
        
        let element = TrieKey(prompt: "")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.remove(element)
        
        XCTAssert(storage.count == 0)
    }
    
    // MARK: Remove All
    func testRemoveAll_removesNodes() {
        let element = TrieKey(prompt: "")
        
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements == [element])
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
        
        storage.removeAll(keepingCapacity: false)
        
        XCTAssert(storage.node._storage.prefix == nil)
        XCTAssert(storage.node._storage.elements.isEmpty)
        XCTAssert(storage.node._storage.nodesMap.isEmpty)
    }
    
    func testRemoveAll_clearsCount() {
        let element = TrieKey(prompt: "")
        
        let storage = _TrieStorage<TrieKey>([element])
        
        XCTAssert(storage.count == 1)
        
        storage.removeAll(keepingCapacity: false)
        
        XCTAssert(storage.count == 0)
    }
    
    // MARK: Filter With Prefixes
    func testFilterWithPrefixes_returnsArrayOfAllElements_withNoPrefixes() {
        let element1 = TrieKey(prompt: "", components: [.stringA("")])
        let element2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let element3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let storage = _TrieStorage<TrieKey>([element1, element2, element3])
        
        XCTAssert(Set(storage.filter(withPrefixes: [])) == [element1, element2, element3])
    }
    
    func testFilterWithPrefixes_returnsArrayOfNoElements_withNonExistentPrefixPath() {
        let storage = _TrieStorage<TrieKey>()
        
        XCTAssert(storage.filter(withPrefixes: [.stringA("")]) == [])
    }
    
    func testFilterWithPrefixes_returnsArrayOfElementsContainGivenPrefixPath_withPrefixPathShorterThanThoseOfSomeMemebers() {
        let element1 = TrieKey(prompt: "", components: [.stringA(""), .stringB(""), .stringB("")])
        let element2 = TrieKey(prompt: "", components: [.stringA("")])
        let storage = _TrieStorage<TrieKey>([element1, element2])
        
        XCTAssert(storage.filter(withPrefixes: [.stringA(""), .stringB("")]) == [element1])
    }
    
    // MARK: Equal
    func testEqual_returnsTrue_withStoragesOfSameReferences() {
        let storage1 = _TrieStorage<TrieKey>()
        let storage2 = storage1
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
}
