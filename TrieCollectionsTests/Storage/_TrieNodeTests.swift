//
//  _TrieNodeTests.swift
//  TrieCollections
//
//  Created on 28/10/2018.
//

import XCTest

@testable
import TrieCollections


class _TrieNodeTests: XCTestCase {
    // MARK: Init with Prefix
    func testInitWithPrefix_doesNotThrow() {
        XCTAssertNoThrow(_TrieNode<TrieKey>(prefix: nil))
    }
    
    func testInitWithPrefix() {
        let node = _TrieNode<TrieKey>(prefix: nil)
        XCTAssert(node.elements.isEmpty)
        XCTAssert(node.nodesMap.isEmpty)
    }
    
    // MARK: with Dedicated Storage
    func test_withDedicatedStorage_doesNotThrow() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        XCTAssertNoThrow(node._withDedicatedStorage({ _ in }))
        
        let copiedNode = node
        XCTAssertNoThrow(node._withDedicatedStorage({ _ in }))
        XCTAssertNoThrow(copiedNode) // Implementation artifact
    }
    
    func test_withDedicatedStorage_doesNotCopiesStorage_whenStorageWasUniquelyReferenced() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        
        unowned let storage = node._storage
        
        node._withDedicatedStorage({ _ in })
        
        XCTAssert(node._storage === storage)
    }
    
    func test_withDedicatedStorage_copiesStorage_whenStorageWasNotUniquelyReferenced() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        let copiedNode = node
        
        XCTAssert(node._storage === copiedNode._storage)
        
        node._withDedicatedStorage({ _ in })
        
        XCTAssert(node._storage !== copiedNode._storage)
    }
    
    // MARK: Insert Element Forces with Prefixes
    func testInsertElementForcesWithPrefixes_doesNotTriggerCOW_whenStorageWasUniquelyReferences() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        unowned let storage = node._storage
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node._storage === storage)
        
        node.insert(element, forces: false, with: &triePrefixes)
        
        XCTAssert(node._storage === storage)
    }
    
    func testInsertElementForcesWithPrefixes_triggersCOW_whenStorageWasNotUniquelyReferences() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        let copiedNode = node
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node._storage === copiedNode._storage)
        
        node.insert(element, forces: false, with: &triePrefixes)
        
        XCTAssert(node._storage !== copiedNode._storage)
    }
    
    // MARK: Remove Element with Prefixes
    func testRemoveElementWithPrefixes_doesNotTriggerCOW_whenStorageWasUniquelyReferences() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        unowned let storage = node._storage
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node._storage === storage)
        
        node.remove(element, with: &triePrefixes)
        
        XCTAssert(node._storage === storage)
    }
    
    func testRemoveElementWithPrefixes_triggersCOW_whenStorageWasNotUniquelyReferences() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        let copiedNode = node
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(node._storage === copiedNode._storage)
        
        node.remove(element, with: &triePrefixes)
        
        XCTAssert(node._storage !== copiedNode._storage)
    }
    
    // MARK: Remove All
    func testRemoveAll_doesNotTriggerCOW_whenStorageWasUniquelyReferences() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        unowned let storage = node._storage
        
        XCTAssert(node._storage === storage)
        
        node.removeAll()
        
        XCTAssert(node._storage === storage)
    }
    
    func testRemoveAll_triggersCOW_whenStorageWasNotUniquelyReferences() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        let copiedNode = node
        
        XCTAssert(node._storage === copiedNode._storage)
        
        node.removeAll()
        
        XCTAssert(node._storage !== copiedNode._storage)
    }
    
    // MARK: Memeber with Trie Prefixes
    func testMemeberWithPrefixes_returnsNil_withNotContainedElement() {
        let storage = _TrieNode<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        XCTAssert(storage.member(element, with: &triePrefixes) == nil)
    }
    
    func testMemeberWithPrefixes_returnsElement_withContainedElement() {
        var node = _TrieNode<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "")
        var triePrefixes = element.triePrefixes
        
        node.insert(element, forces: false, with: &triePrefixes)
        
        XCTAssert(node.member(element, with: &triePrefixes) === element)
    }
    
    func testMemeberWithPrefixes_exhausesPrefixes() {
        let storage = _TrieNode<TrieKey>(prefix: nil)
        
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var triePrefixes = element.triePrefixes
        
        XCTAssert(!triePrefixes.isEmpty)
        
        _ = storage.member(element, with: &triePrefixes)
        
        XCTAssert(!triePrefixes.isEmpty)
    }
        
    // MARK: All Elements
    func testAllElements_returnsAllElementsOnTheTree_withElementOfZeroPrefixes() {
        let element = TrieKey(prompt: "")
        var prefixes = element.triePrefixes
        var node = _TrieNode<TrieKey>(prefix: nil)
        node.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(node.allElements == [element])
    }
    
    func testAllElements_returnsAllElementsOnTheTree_withElementOfOnePrefix() {
        let element = TrieKey(prompt: "", components: [.stringA("")])
        var prefixes = element.triePrefixes
        var node = _TrieNode<TrieKey>(prefix: nil)
        node.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(node.allElements == [element])
    }
    
    func testAllElements_returnsAllElementsOnTheTree_withElementOfTowPrefixes() {
        let element = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        var prefixes = element.triePrefixes
        var node = _TrieNode<TrieKey>(prefix: nil)
        node.insert(element, forces: false, with: &prefixes)
        
        XCTAssert(node.allElements == [element])
    }
    
    // MARK: Equal
    func testEqual_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let node1 = _TrieNode<TrieKey>(prefix: nil)
        let node2 = node1
        
        XCTAssert(node1._storage === node2._storage)
        
        XCTAssert(node1 == node2)
        XCTAssert(node2 == node1)
        
        XCTAssert(node1._storage === node2._storage)
    }
}
