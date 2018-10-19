//
//  TrieTests.swift
//  TrieSet
//
//  Created on 7/30/18.
//

import XCTest

@testable
import TrieSet


// MARK: - _TrieSetStorage
class _TrieSetStorageTests: XCTestCase {
    func testInitDoesNotThrow() {
        XCTAssertNoThrow(_TrieSetStorage<TrieElement>())
    }
    
    func testInit() {
        let storage = _TrieSetStorage<TrieElement>()
        XCTAssert(storage.node.isEmpty)
        XCTAssert(storage.count == 0)
    }
    
    func testInsertElement() {
        let storage = _TrieSetStorage<TrieElement>()
        
        let element = TrieElement(prompt: "")
        
        XCTAssert(storage.count == 0)
        XCTAssert(!storage.contains(element))
        
        storage.insert(element)
        
        XCTAssert(storage.contains(element))
        XCTAssert(storage.count == 1)
    }
    
    func testInsertElement_doesNotChangeCountWithSameElement() {
        let storage = _TrieSetStorage<TrieElement>()
        
        let element = TrieElement(prompt: "")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
    }
    
    func testRemoveElement_subtractsCount() {
        let storage = _TrieSetStorage<TrieElement>()
        
        let element = TrieElement(prompt: "")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.remove(element)
        
        XCTAssert(storage.count == 0)
    }
    
    func testRemoveElement_doesNotChangeCountWithSameElement() {
        let storage = _TrieSetStorage<TrieElement>()
        
        let element = TrieElement(prompt: "")
        
        XCTAssert(storage.count == 0)
        
        storage.insert(element)
        
        XCTAssert(storage.count == 1)
        
        storage.remove(element)
        
        XCTAssert(storage.count == 0)
        
        storage.remove(element)
        
        XCTAssert(storage.count == 0)
    }
}


// MARK: - _TrieNode
class _TrieNodeTests: XCTestCase {
    func testInitDoesNotThrow() {
        XCTAssertNoThrow(_TrieNode<TrieElement>(prefix: nil))
    }
    
    func testInit() {
        let node = _TrieNode<TrieElement>(prefix: nil)
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.isEmpty)
    }
    
    func test_withDedicatedStorage() {
        var node = _TrieNode<TrieElement>(prefix: nil)
        
        unowned let storage1 = node._storage
        
        XCTAssertNoThrow(node._withDedicatedStorage({ _ in }))
        
        unowned let storage2 = node._storage
        
        XCTAssert(storage1 === storage2)
        
        let copiedNode = node
        
        XCTAssertNoThrow(node._withDedicatedStorage({ _ in }))
        
        XCTAssert(storage1 === copiedNode._storage)
    }
    
    func testContainsElementWithPrefixes_emptyStorage_zeroLengthElement() {
        let storage = _TrieNode<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        XCTAssert(!storage.contains(element, with: &triePrefixes))
    }
    
    func testContainsElementWithPrefixes_storageWithZeroLengthElement_zeroLengthElement() {
        var node = _TrieNode<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = node.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(node.elements.contains(element))
        XCTAssert(node.nodesMap.isEmpty)
        
        XCTAssert(node.contains(element, with: &triePrefixes))
    }
    
    func testContainsElementWithPrefixes_storageWithZeroLengthElement_oneLengthElement() {
        var node = _TrieNode<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = node.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(node.elements.contains(element))
        XCTAssert(node.nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(!node.contains(element2, with: &triePrefixes2))
    }
    
    func testContainsElementWithPrefixes_storageWithOneLengthElement_zeroLengthElement() {
        var node = _TrieNode<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = node.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.count == 1)
        XCTAssert(node.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(node.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(node.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "")
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(!node.contains(element2, with: &triePrefixes2))
    }
    
    func testContainsElementWithPrefixes_storageWithOneLengthElement_oneLengthElement() {
        var node = _TrieNode<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = node.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.count == 1)
        XCTAssert(node.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(node.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(node.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(node.contains(element2, with: &triePrefixes2))
    }
}


// MARK: - _TrieNodeStorage
class _TrieNodeStorageTests: XCTestCase {
    func testInitDoesNotThrow() {
        XCTAssertNoThrow(_TrieNodeStorage<TrieElement>(prefix: nil))
    }
    
    func testInit() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testInitWithStorage() {
        let prefix = TrieElementComponent.stringA("")
        let storage = _TrieNodeStorage<TrieElement>(prefix: prefix)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == prefix)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        _ = storage.insert(element, with: &triePrefixes)
        
        let copiedStorage = _TrieNodeStorage(storage: storage)
        
        XCTAssert(storage.prefix == copiedStorage.prefix)
        XCTAssert(storage.elements == copiedStorage.elements)
        XCTAssert(storage.nodesMap == copiedStorage.nodesMap)
    }
    
    func testInsertElementWithPrefixes_zeroLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(isInserted)
        XCTAssert(memberAfterInsert == element)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_zeroLengthElement_multiple_equal() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        var triePrefixes2 = element.triePrefixes
        let (isInserted2, memberAfterInsert2) = storage.insert(element, with: &triePrefixes2)
        
        XCTAssert(memberAfterInsert2 == element)
        XCTAssert(!isInserted2)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_zeroLengthElement_multiple_inequal() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(isInserted)
        XCTAssert(memberAfterInsert == element)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "1")
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(element != element2)
        XCTAssert(element.triePrefixes == element2.triePrefixes)
        
        let (isInserted2, memberAfterInsert2) = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(isInserted2)
        XCTAssert(memberAfterInsert2 == element2)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 2)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.elements.contains(element2))
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_oneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("1")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["1".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_oneLengthElement_multiple_unidenticalPrefix() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("1")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["1".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["1".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringB("1")])
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(element.triePrefixes.map({$0.hashValue}) == element2.triePrefixes.map({$0.hashValue}))
        XCTAssert(element != element2)
        XCTAssert("1".hashValue == "1".hashValue)
        
        let (isInserted2, memberAfterInsert2) = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(memberAfterInsert2 == element2)
        XCTAssert(isInserted2)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["1".hashValue]!.count == 2)
        XCTAssert(storage.nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["1".hashValue]![0].nodesMap.isEmpty)
        XCTAssert(storage.nodesMap["1".hashValue]![1].prefix == .stringB("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![1].elements.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![1].elements.contains(element2))
        XCTAssert(storage.nodesMap["1".hashValue]![1].nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_oneLengthElement_multiple_inequal() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("1")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["1".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["1".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "1", components: [.stringA("1")])
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(element.triePrefixes == element2.triePrefixes)
        XCTAssert(element != element2)
        XCTAssert("1".hashValue == "1".hashValue)
        
        let (isInserted2, memberAfterInsert2) = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(memberAfterInsert2 == element2)
        XCTAssert(isInserted2)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["1".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.count == 2)
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element2))
        XCTAssert(storage.nodesMap["1".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_twoLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0"), .stringA("1")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.isEmpty)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["1".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["1".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["1".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["1".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testInsertElementWithPrefixes_zeroLengthElement_oneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("1")])
        var triePrefixes2 = element2.triePrefixes
        
        let (isInserted2, memberAfterInsert2) = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(memberAfterInsert2 == element2)
        XCTAssert(isInserted2)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.count == 1)
        
        XCTAssert(storage.nodesMap["1".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].prefix == .stringA("1"))
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["1".hashValue]![0].elements.contains(element2))
        XCTAssert(storage.nodesMap["1".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_emptyStorage_zeroLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let removedElement = storage.remove(element, with: &triePrefixes)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithZeroLengthElement_zeroLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        var triePrefixes2 = element.triePrefixes
        let removedElement = storage.remove(element, with: &triePrefixes2)
        
        XCTAssert(removedElement == element)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithZeroLengthElement_zeroLengthElement_inequal() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "1")
        var triePrefixes2 = element2.triePrefixes
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithZeroLengthElement_oneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "")
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.count == 1)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithOneLengthElement_zeroLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "")
        var triePrefixes2 = element2.triePrefixes
        
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithOneLengthElement_oneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == element)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithOneLengthElement_oneLengthElement_inequal() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "1", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithOneLengthElements_oneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        let element2 = TrieElement(prompt: "1", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        _ = storage.insert(element, with: &triePrefixes1)
        _ = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 2)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element2))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        var triePrefixes2Prime = element2.triePrefixes
        let removedElement2 = storage.remove(element2, with: &triePrefixes2Prime)
        
        XCTAssert(removedElement2 == element2)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithOneLengthElement_oneLengthElement_unidenticalPrefixes() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        let element2 = TrieElement(prompt: "1", components: [.stringB("0")])
        var triePrefixes2 = element2.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        _ = storage.insert(element, with: &triePrefixes1)
        _ = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 2)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        XCTAssert(storage.nodesMap["0".hashValue]![1].prefix == .stringB("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![1].elements.contains(element2))
        XCTAssert(storage.nodesMap["0".hashValue]![1].nodesMap.isEmpty)
        
        var triePrefixes2Prime = element2.triePrefixes
        let removedElement2 = storage.remove(element2, with: &triePrefixes2Prime)
        
        XCTAssert(removedElement2 == element2)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithTwoLengthElement_zeroLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0"), .stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.isEmpty)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "")
        var triePrefixes2 = element2.triePrefixes
        
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.isEmpty)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveElementWithPrefixes_storageWithTwoLengthElement_oneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0"), .stringA("0")])
        var triePrefixes1 = element.triePrefixes
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes1)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.isEmpty)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        let removedElement = storage.remove(element2, with: &triePrefixes2)
        
        XCTAssert(removedElement == nil)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.isEmpty)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].nodesMap.isEmpty)
    }
    
    func testRemoveAll_emptyStorage() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveAll_storageWithZeroLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [])
        var triePrefixes = element.triePrefixes
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.contains(element))
        XCTAssert(storage.nodesMap.isEmpty)
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveAll_storageWithOneLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes = element.triePrefixes
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testRemoveAll_storageWithMultiLengthElement() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        let element = TrieElement(prompt: "", components: [.stringA("0")])
        var triePrefixes = element.triePrefixes
        
        let (isInserted, memberAfterInsert) = storage.insert(element, with: &triePrefixes)
        
        XCTAssert(memberAfterInsert == element)
        XCTAssert(isInserted)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        let element2 = TrieElement(prompt: "", components: [.stringA("0"), .stringA("0")])
        var triePrefixes2 = element2.triePrefixes
        
        let (isInserted2, memberAfterInsert2) = storage.insert(element2, with: &triePrefixes2)
        
        XCTAssert(memberAfterInsert2 == element2)
        XCTAssert(isInserted2)
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].elements.contains(element))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]!.count == 1)
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].prefix == .stringA("0"))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].elements.contains(element2))
        XCTAssert(storage.nodesMap["0".hashValue]![0].nodesMap["0".hashValue]![0].nodesMap.isEmpty)
        
        
        storage.removeAll()
        
        XCTAssert(storage.prefix == nil)
        XCTAssert(storage.elements.isEmpty)
        XCTAssert(storage.nodesMap.isEmpty)
    }
    
    func testEqual_equals_identicalReference() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        XCTAssert(storage == storage)
    }
    
    func testEqual_doesNotEqual_differentPrefix() {
        let storage1 = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieElement>(prefix: .stringA(""))
        
        XCTAssert(storage1 != storage2)
        XCTAssert(storage2 != storage1)
    }
    
    func testEqual_doesNotEqual_differentElement() {
        let storage1 = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
        
        let element = TrieElement(prompt: "", components: [])
        var elementPrifixes = element.triePrefixes
        storage2.insert(element, with: &elementPrifixes)
        
        XCTAssert(storage1 != storage2)
        XCTAssert(storage2 != storage1)
    }
    
    func testEqual_equals_sameElements_identicalInsertionOrder() {
        let storage1 = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
        
        let element1 = TrieElement(prompt: "A", components: [])
        let element2 = TrieElement(prompt: "B", components: [])
        
        var p11 = element1.triePrefixes
        var p12 = element2.triePrefixes
        storage1.insert(element1, with: &p11)
        storage1.insert(element2, with: &p12)
        
        var p21 = element1.triePrefixes
        var p22 = element2.triePrefixes
        storage2.insert(element1, with: &p21)
        storage2.insert(element2, with: &p22)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_equals_sameElements_differenceInsertionOrder() {
        let storage1 = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
        
        let element1 = TrieElement(prompt: "A", components: [])
        let element2 = TrieElement(prompt: "B", components: [])
        
        var p11 = element1.triePrefixes
        var p12 = element2.triePrefixes
        storage1.insert(element1, with: &p11)
        storage1.insert(element2, with: &p12)
        
        var p21 = element1.triePrefixes
        var p22 = element2.triePrefixes
        storage2.insert(element2, with: &p22)
        storage2.insert(element1, with: &p21)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_equals_sameChildNodes_identicalInsertionOrder() {
        let storage1 = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
        
        let element1 = TrieElement(prompt: "", components: [.stringA("")])
        let element2 = TrieElement(prompt: "", components: [.stringB("")])
        
        var p11 = element1.triePrefixes
        var p12 = element2.triePrefixes
        storage1.insert(element1, with: &p11)
        storage1.insert(element2, with: &p12)
        
        var p21 = element1.triePrefixes
        var p22 = element2.triePrefixes
        storage2.insert(element1, with: &p21)
        storage2.insert(element2, with: &p22)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_equals_sameChildNodes_differentInsertionOrder() {
        let storage1 = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storage2 = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
        
        let element1 = TrieElement(prompt: "", components: [.stringA("")])
        let element2 = TrieElement(prompt: "", components: [.stringB("")])
        
        var p11 = element1.triePrefixes
        var p12 = element2.triePrefixes
        storage1.insert(element1, with: &p11)
        storage1.insert(element2, with: &p12)
        
        var p21 = element1.triePrefixes
        var p22 = element2.triePrefixes
        storage2.insert(element2, with: &p22)
        storage2.insert(element1, with: &p21)
        
        XCTAssert(storage1 == storage2)
        XCTAssert(storage2 == storage1)
    }
    
    func testEqual_doesNotEqual_differentChildNodes() {
        let storage = _TrieNodeStorage<TrieElement>(prefix: nil)
        let storageWithNodes = _TrieNodeStorage<TrieElement>(prefix: nil)
        
        XCTAssert(storage == storageWithNodes)
        XCTAssert(storageWithNodes == storage)
        
        let element = TrieElement(prompt: "", components: [.stringA("")])
        var elementPrifixes = element.triePrefixes
        storageWithNodes.insert(element, with: &elementPrifixes)
        
        XCTAssert(storage != storageWithNodes)
        XCTAssert(storageWithNodes != storage)
    }
}


class _TrieNodeBreadthFirstIteratorImplTests: XCTestCase {
    func testInitWithStorage() {
        let storage = _TrieSetStorage<TrieElement>()
        
        let impl = _TrieSetBreadthFirstIteratorImpl(storage: storage)
        XCTAssert(impl._stack == [storage.node])
        XCTAssert(impl._elements == [])
    }
    
    func testInitWithImpl() {
        let storage = _TrieSetStorage<TrieElement>()
        let element1 = TrieElement(
            prompt: "",
            components: [.stringA("1")]
        )
        storage.insert(element1)
        
        let impl = _TrieSetBreadthFirstIteratorImpl(storage: storage)
        
        let copiedImplInitial = _TrieSetBreadthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack == copiedImplInitial._stack)
        XCTAssert(impl._elements == copiedImplInitial._elements)
        
        _ = impl.next()
        
        let copiedImplNext = _TrieSetBreadthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack == copiedImplNext._stack)
        XCTAssert(impl._elements == copiedImplNext._elements)
    }
    
    func testNext() {
        let storage = _TrieSetStorage<TrieElement>()
        let element0 = TrieElement(
            prompt: "",
            components: []
        )
        let element1 = TrieElement(
            prompt: "",
            components: [.stringA("1")]
        )
        let element12 = TrieElement(
            prompt: "",
            components: [.stringA("1"), .stringA("2")]
        )
        let element123 = TrieElement(
            prompt: "",
            components: [.stringA("1"), .stringA("2"), .stringA("3")]
        )
        let element2 = TrieElement(
            prompt: "",
            components: [.stringA("2")]
        )
        let element22 = TrieElement(
            prompt: "",
            components: [.stringA("2"), .stringA("2")]
        )
        
        storage.insert(element0)
        storage.insert(element1)
        storage.insert(element12)
        storage.insert(element123)
        storage.insert(element2)
        storage.insert(element22)
        
        let impl = _TrieSetBreadthFirstIteratorImpl(storage: storage)
        
        let popped1 = impl.next()
        XCTAssert(popped1 == element0)
        
        let popped2 = impl.next()
        let popped3 = impl.next()
        XCTAssert((popped2 == element1 && popped3 == element2) || (popped2 == element2 && popped3 == element1))
        
        let popped4 = impl.next()
        let popped5 = impl.next()
        XCTAssert((popped4 == element12 && popped5 == element22) || (popped4 == element22 && popped5 == element12))
        
        let popped6 = impl.next()
        XCTAssert(popped6 == element123)
        
        let popped7 = impl.next()
        XCTAssert(popped7 == nil)
    }
}


class _TrieNodeDepthFirstIteratorImplTests: XCTestCase {
    func testInitWithStorage() {
        let storage = _TrieSetStorage<TrieElement>()
        
        let impl = _TrieSetDepthFirstIteratorImpl(storage: storage)
        XCTAssert(impl._stack.elementsEqual([(storage.node, storage.node.nodesMap.startIndex)], by: {$0.0 == $1.0 && $0.1 == $1.1}))
        XCTAssert(impl._elements == [])
    }
    
    func testInitWithImpl() {
        let storage = _TrieSetStorage<TrieElement>()
        let element1 = TrieElement(
            prompt: "",
            components: [.stringA("1")]
        )
        storage.insert(element1)
        
        let impl = _TrieSetDepthFirstIteratorImpl(storage: storage)
        
        let copiedImplInitial = _TrieSetDepthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack.elementsEqual(copiedImplInitial._stack, by: {$0.0 == $1.0 && $0.1 == $1.1}))
        XCTAssert(impl._elements == copiedImplInitial._elements)
        
        _ = impl.next()
        
        let copiedImplNext = _TrieSetDepthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack.elementsEqual(copiedImplNext._stack, by: {$0.0 == $1.0 && $0.1 == $1.1}))
        XCTAssert(impl._elements == copiedImplNext._elements)
    }
    
    func testNext() {
        let storage = _TrieSetStorage<TrieElement>()
        let element0 = TrieElement(
            prompt: "",
            components: []
        )
        let element1 = TrieElement(
            prompt: "",
            components: [.stringA("1")]
        )
        let element12 = TrieElement(
            prompt: "",
            components: [.stringA("1"), .stringA("2")]
        )
        let element123 = TrieElement(
            prompt: "",
            components: [.stringA("1"), .stringA("2"), .stringA("3")]
        )
        let element2 = TrieElement(
            prompt: "",
            components: [.stringA("2")]
        )
        let element22 = TrieElement(
            prompt: "",
            components: [.stringA("2"), .stringA("2")]
        )
        
        storage.insert(element0)
        storage.insert(element1)
        storage.insert(element12)
        storage.insert(element123)
        storage.insert(element2)
        storage.insert(element22)
        
        let impl = _TrieSetDepthFirstIteratorImpl(storage: storage)
        
        let popped1 = impl.next()
        let popped2 = impl.next()
        let popped3 = impl.next()
        
        let popped4 = impl.next()
        let popped5 = impl.next()
        
        XCTAssert(
            (
                popped1 == element123 &&
                popped2 == element12 &&
                popped3 == element1 &&
                popped4 == element22 &&
                popped5 == element2
            ) || (
                popped1 == element22 &&
                popped2 == element2 &&
                popped3 == element123 &&
                popped4 == element12 &&
                popped5 == element1
            )
        )
        
        let popped6 = impl.next()
        XCTAssert(popped6 == element0)
        
        let popped7 = impl.next()
        XCTAssert(popped7 == nil)
    }
    
    func testNext_another() {
        let storage = _TrieSetStorage<TrieElement>()
        let element11 = TrieElement(
            prompt: "",
            components: [.stringA("1"), .stringA("1")]
        )
        let element12 = TrieElement(
            prompt: "",
            components: [.stringA("1"), .stringA("2")]
        )
        let element21 = TrieElement(
            prompt: "",
            components: [.stringA("2"), .stringA("1")]
        )
        let element22 = TrieElement(
            prompt: "",
            components: [.stringA("2"), .stringA("2")]
        )
        
        storage.insert(element11)
        storage.insert(element12)
        storage.insert(element21)
        storage.insert(element22)
        
        let impl = _TrieSetDepthFirstIteratorImpl(storage: storage)
        
        let popped1 = impl.next()
        let popped2 = impl.next()
        let popped3 = impl.next()
        let popped4 = impl.next()
        let popped5 = impl.next()
        
        let sequence = [popped1, popped2, popped3, popped4].compactMap({$0})
        
        let allValid = [
            [element11, element12, element21, element22],
            [element11, element12, element22, element21],
            [element12, element11, element21, element22],
            [element12, element11, element22, element21],
            [element22, element21, element12, element11],
            [element22, element21, element11, element12],
            [element21, element22, element12, element11],
            [element21, element22, element11, element12],
        ]
        
        XCTAssert(allValid.contains(sequence), "\(sequence)")
        XCTAssert(popped5 == nil, "\(popped5.map{"\($0)"} ?? "nil")")
    }
}
