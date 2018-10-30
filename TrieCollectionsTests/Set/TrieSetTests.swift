//
//  TrieSetTests.swift
//  TrieSet
//
//  Created on 7/29/18.
//

import XCTest

@testable
import TrieCollections


class TrieSetTests: XCTestCase {
    // MARK: Initialization
    func testInit_createsEmptyTrieSet() {
        let trieSet = TrieSet<TrieKey>()
        
        XCTAssert(trieSet.isEmpty)
        XCTAssert(trieSet.count == 0)
    }
    
    func testInitWithElements_createsEmptyTrieSet_withSequenceOfNoElements() {
        let trieSet = TrieSet<TrieKey>([])
        
        XCTAssert(trieSet.isEmpty)
        XCTAssert(trieSet.count == 0)
    }
    
    func testInitWithElements_createsTrieSetOfElements_withSequenceOfElements() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        let trieSet = TrieSet<TrieKey>([trieKey])
        
        XCTAssert(!trieSet.isEmpty)
        XCTAssert(trieSet.contains(trieKey))
        XCTAssert(trieSet.count == 1)
    }
    
    // MARK: COW Utility
    func test_withDedicatedStorage_copiesStorage_whenStorageWasNonUniquelyReferenced() {
        var trieSet = TrieSet<TrieKey>()
        unowned let storage = trieSet._storage
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === storage)
        XCTAssert(copiedTrieSet._storage === storage)
        
        trieSet._withDedicatedStorage({_ in })
        
        XCTAssert(copiedTrieSet._storage === storage)
        XCTAssert(trieSet._storage !== storage)
    }
    
    func test_withDedicatedStorage_doesNotCopiesStorage_whenStorageWasUniquelyReferenced() {
        var trieSet = TrieSet<TrieKey>()
        unowned let storage = trieSet._storage
        
        XCTAssert(trieSet._storage === storage)
        
        trieSet._withDedicatedStorage({_ in })
        
        XCTAssert(trieSet._storage === storage)
    }
    
    // MARK: Insertion Element
    func testInsertElement_triggersCOW_whenStorageWasUniquelyReferences() {
        var trieSet = TrieSet<TrieKey>()
        let copiedTrieSet = trieSet
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        trieSet.insert(trieKey)
        XCTAssert(trieSet._storage !== copiedTrieSet._storage)
    }
    
    func testInsertElement_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        var trieSet = TrieSet<TrieKey>()
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        unowned let storage = trieSet._storage
        
        XCTAssert(trieSet._storage === storage)
        trieSet.insert(trieKey)
        XCTAssert(trieSet._storage === storage)
    }
    
    // MARK: Remove Element
    func testRemoveElement_triggersCOW_whenStorageWasUniquelyReferences() {
        var trieSet = TrieSet<TrieKey>()
        let copiedTrieSet = trieSet
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        trieSet.remove(trieKey)
        XCTAssert(trieSet._storage !== copiedTrieSet._storage)
    }
    
    func testRemoveElement_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        var trieSet = TrieSet<TrieKey>()
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        unowned let storage = trieSet._storage
        
        XCTAssert(trieSet._storage === storage)
        trieSet.remove(trieKey)
        XCTAssert(trieSet._storage === storage)
    }
    
    // MARK: Remove at Index
    func testRemoveAtIndex_triggersCOW_whenStorageWasUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieSet = TrieSet<TrieKey>([trieKey])
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        trieSet.remove(at: trieSet.startIndex)
        XCTAssert(trieSet._storage !== copiedTrieSet._storage)
    }
    
    func testRemoveAtIndex_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieSet = TrieSet<TrieKey>([trieKey])
        unowned let storage = trieSet._storage
        
        XCTAssert(trieSet._storage === storage)
        trieSet.remove(at: trieSet.startIndex)
        XCTAssert(trieSet._storage === storage)
    }
    
    func testRemoveAtIndex_returnsElement() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieSet = TrieSet<TrieKey>([trieKey])
        
        let removed = trieSet.remove(at: trieSet.startIndex)
        
        XCTAssert(removed == trieKey)
    }
    
    func testRemoveAtIndex_removesElement() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieSet = TrieSet<TrieKey>([trieKey])
        
        XCTAssert(trieSet.contains(trieKey))
        
        trieSet.remove(at: trieSet.startIndex)
        
        XCTAssert(!trieSet.contains(trieKey))
    }
    
    // MARK: Remove All
    func testRemoveAll_triggersCOW_whenStorageWasUniquelyReferences() {
        var trieSet = TrieSet<TrieKey>()
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        trieSet.removeAll()
        XCTAssert(trieSet._storage !== copiedTrieSet._storage)
    }
    
    func testRemoveAll_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        var trieSet = TrieSet<TrieKey>()
        unowned let storage = trieSet._storage
        
        XCTAssert(trieSet._storage === storage)
        trieSet.removeAll()
        XCTAssert(trieSet._storage === storage)
    }
    
    // MARK: Filter With Prefixes
    func testFilterWithPrefixes_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieSet = TrieSet<TrieKey>()
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        _ = trieSet.filter(withPrefixes: [.stringA("")])
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
    }
    
    // MARK: Test Collection
    func testStartIndex_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieSet = TrieSet<TrieKey>()
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        _ = trieSet.startIndex
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
    }
    
    func testStartIndex() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let trieSet1 = TrieSet<TrieKey>([trieKey1])
        let trieSet2 = TrieSet<TrieKey>([trieKey1, trieKey2])
        let trieSet3 = TrieSet<TrieKey>([trieKey1, trieKey2, trieKey3])
        
        XCTAssert(trieSet1.startIndex == TrieIndex(offset: 0))
        XCTAssert(trieSet2.startIndex == TrieIndex(offset: 0))
        XCTAssert(trieSet3.startIndex == TrieIndex(offset: 0))
    }
    
    func testEndIndex_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieSet = TrieSet<TrieKey>()
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        _ = trieSet.endIndex
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
    }
    
    func testEndIndex() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let trieSet1 = TrieSet<TrieKey>([trieKey1])
        let trieSet2 = TrieSet<TrieKey>([trieKey1, trieKey2])
        let trieSet3 = TrieSet<TrieKey>([trieKey1, trieKey2, trieKey3])
        
        XCTAssert(trieSet1.endIndex == TrieIndex(offset: 1))
        XCTAssert(trieSet2.endIndex == TrieIndex(offset: 2))
        XCTAssert(trieSet3.endIndex == TrieIndex(offset: 3))
    }
    
    func testSubscriptIndexGet_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        let trieSet = TrieSet<TrieKey>([trieKey])
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        _ = trieSet[TrieIndex(offset: 0)]
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
    }
    
    func testSubscriptIndexGet() {
        let trieKey = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieSet = TrieSet<TrieKey>([trieKey])
        
        XCTAssert(trieSet[trieSet.startIndex] == trieKey)
    }
    
    func testIndexAfter_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieSet = TrieSet<TrieKey>([trieKey])
        let copiedTrieSet = trieSet
        
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
        _ = trieSet.index(after: trieSet.startIndex)
        XCTAssert(trieSet._storage === copiedTrieSet._storage)
    }
    
    func testIndexAfter() {
        let trieKey = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieSet = TrieSet<TrieKey>([trieKey])
        
        XCTAssert(trieSet.index(after: trieSet.startIndex) == trieSet.endIndex)
    }
    
    // MARK: Equatable
    func testEquatable_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let set = TrieSet<TrieKey>()
        let copiedSet = set
        
        XCTAssert(set._storage === copiedSet._storage)
        
        XCTAssert(set == copiedSet)
        XCTAssert(copiedSet == set)
        
        XCTAssert(set._storage === copiedSet._storage)
    }
    
    // MARK: ExpressibleByArrayLiteral
    func testInitWithArrayLiteral() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let trieSet1: TrieSet<TrieKey> = [trieKey1, trieKey2, trieKey3]
        let trieSet2 = TrieSet<TrieKey>([trieKey1, trieKey2, trieKey3])
        
        XCTAssert(trieSet1 == trieSet2)
    }
}
