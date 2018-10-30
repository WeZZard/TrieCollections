//
//  TrieDictionaryTests.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//

import XCTest

@testable
import TrieCollections


class TrieDictionaryTests: XCTestCase {
    // MARK: Initialization
func testInit_createsEmptyTrieSet() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        
        XCTAssert(trieDictionary.isEmpty)
        XCTAssert(trieDictionary.count == 0)
    }
    
    func testInitWithElements_createsEmptyTrieSet_withSequenceOfNoElements() {
        let trieDictionary = TrieDictionary<TrieKey, Int>([])
        
        XCTAssert(trieDictionary.isEmpty)
        XCTAssert(trieDictionary.count == 0)
    }
    
    func testInitWithElements_createsTrieSetOfElements_withSequenceOfElements() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        
        XCTAssert(!trieDictionary.isEmpty)
        XCTAssert(trieDictionary[trieKey] == 1)
        XCTAssert(trieDictionary.count == 1)
    }
    
    // MARK: COW Utility
    func test_withDedicatedStorage_copiesStorage_whenStorageWasNonUniquelyReferenced() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        unowned let storage = trieDictionary._storage
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === storage)
        XCTAssert(copiedTrieSet._storage === storage)
        
        trieDictionary._withDedicatedStorage({_ in })
        
        XCTAssert(copiedTrieSet._storage === storage)
        XCTAssert(trieDictionary._storage !== storage)
    }
    
    func test_withDedicatedStorage_doesNotCopiesStorage_whenStorageWasUniquelyReferenced() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        unowned let storage = trieDictionary._storage
        
        XCTAssert(trieDictionary._storage === storage)
        
        trieDictionary._withDedicatedStorage({_ in })
        
        XCTAssert(trieDictionary._storage === storage)
    }
    
    // MARK: Update Value for Key
    func testUpdateValueForKey_returnsNil_forNonExistentKey() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        
        let oldValue = trieDictionary.updateValue(1, forKey: trieKey)
        
        XCTAssert(oldValue == nil)
    }
    
    func testUpdateValueForKey_returnsOldValue_forExistentKey() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        
        let oldValue = trieDictionary.updateValue(2, forKey: trieKey)
        
        XCTAssert(oldValue == 1)
    }
    
    func testUpdateValueForKey_triggersCOW_whenStorageWasUniquelyReferences() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        let copiedTrieSet = trieDictionary
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        trieDictionary.updateValue(1, forKey: trieKey)
        XCTAssert(trieDictionary._storage !== copiedTrieSet._storage)
    }
    
    func testUpdateValueForKey_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        unowned let storage = trieDictionary._storage
        
        XCTAssert(trieDictionary._storage === storage)
        trieDictionary.updateValue(1, forKey: trieKey)
        XCTAssert(trieDictionary._storage === storage)
    }
    
    // MARK: Remove Value for Key
    func testRemoveValueForKey_triggersCOW_whenStorageWasUniquelyReferences() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        let copiedTrieSet = trieDictionary
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        trieDictionary.removeValue(forKey: trieKey)
        XCTAssert(trieDictionary._storage !== copiedTrieSet._storage)
    }
    
    func testRemoveValueForKey_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        unowned let storage = trieDictionary._storage
        
        XCTAssert(trieDictionary._storage === storage)
        trieDictionary.removeValue(forKey: trieKey)
        XCTAssert(trieDictionary._storage === storage)
    }
    
    // MARK: Index for Key
    func testIndexForKey_returnsIndex_withContainedKey() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 1), (trieKey3, 1)])
        
        XCTAssert(trieDictionary[trieDictionary.index(forKey: trieKey1)!].key == trieKey1)
        XCTAssert(trieDictionary[trieDictionary.index(forKey: trieKey2)!].key == trieKey2)
        XCTAssert(trieDictionary[trieDictionary.index(forKey: trieKey3)!].key == trieKey3)
    }
    
    func testIndexForKey_doesNotReturnIndex_withContainedKey() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        
        let index = trieDictionary.index(forKey: trieKey)
        
        XCTAssert(index == nil)
    }
    
    // MARK: Remove at Index
    func testRemoveAtIndex_returnsElement() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        
        let removed = trieDictionary.remove(at: trieDictionary.startIndex)
        
        XCTAssert(removed == (trieKey, 1))
    }
    
    func testRemoveAtIndex_removesElement() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        
        XCTAssert(trieDictionary[trieKey] == 1)
        
        trieDictionary.remove(at: trieDictionary.startIndex)
        
        XCTAssert(trieDictionary[trieKey] == nil)
    }
    
    func testRemoveAtIndex_triggersCOW_whenStorageWasUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        trieDictionary.remove(at: trieDictionary.startIndex)
        XCTAssert(trieDictionary._storage !== copiedTrieSet._storage)
    }
    
    func testRemoveAtIndex_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        var trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        unowned let storage = trieDictionary._storage
        
        XCTAssert(trieDictionary._storage === storage)
        trieDictionary.remove(at: trieDictionary.startIndex)
        XCTAssert(trieDictionary._storage === storage)
    }
    
    // MARK: Remove All
    func testRemoveAll_triggersCOW_whenStorageWasUniquelyReferences() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        trieDictionary.removeAll()
        XCTAssert(trieDictionary._storage !== copiedTrieSet._storage)
    }
    
    func testRemoveAll_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        var trieDictionary = TrieDictionary<TrieKey, Int>()
        unowned let storage = trieDictionary._storage
        
        XCTAssert(trieDictionary._storage === storage)
        trieDictionary.removeAll()
        XCTAssert(trieDictionary._storage === storage)
    }
    
    // MARK: Filter With Prefixes
    func testFilterWithPrefixes_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        _ = trieDictionary.filter(withPrefixes: [.stringA("")])
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
    }
    
    // MARK: Test Collection
    func testStartIndex_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        _ = trieDictionary.startIndex
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
    }
    
    func testStartIndex() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let trieDictionary1 = TrieDictionary<TrieKey, Int>([(trieKey1, 1)])
        let trieDictionary2 = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 2)])
        let trieDictionary3 = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 2), (trieKey3, 3)])
        
        XCTAssert(trieDictionary1.startIndex == TrieIndex(offset: 0))
        XCTAssert(trieDictionary2.startIndex == TrieIndex(offset: 0))
        XCTAssert(trieDictionary3.startIndex == TrieIndex(offset: 0))
    }
    
    func testEndIndex_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        _ = trieDictionary.endIndex
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
    }
    
    func testEndIndex() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let trieDictionary1 = TrieDictionary<TrieKey, Int>([(trieKey1, 1)])
        let trieDictionary2 = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 2)])
        let trieDictionary3 = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 2), (trieKey3, 3)])
        
        XCTAssert(trieDictionary1.endIndex == TrieIndex(offset: 1))
        XCTAssert(trieDictionary2.endIndex == TrieIndex(offset: 2))
        XCTAssert(trieDictionary3.endIndex == TrieIndex(offset: 3))
    }
    
    func testSubscriptIndexGet_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        _ = trieDictionary[TrieIndex(offset: 0)]
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
    }
    
    func testSubscriptIndexGet() {
        let trieKey = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        
        XCTAssert(trieDictionary[trieDictionary.startIndex] == (trieKey, 1))
    }
    
    func testIndexAfter_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let trieKey = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        let copiedTrieSet = trieDictionary
        
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
        _ = trieDictionary.index(after: trieDictionary.startIndex)
        XCTAssert(trieDictionary._storage === copiedTrieSet._storage)
    }
    
    func testIndexAfter() {
        let trieKey = TrieKey(prompt: "", components: [.stringA(""), .stringA(""), .stringA("")])
        let trieDictionary = TrieDictionary<TrieKey, Int>([(trieKey, 1)])
        
        XCTAssert(trieDictionary.index(after: trieDictionary.startIndex) == trieDictionary.endIndex)
    }
    
    // MARK: Equatable
    func testEquatable_doesNotTriggerCOW_whenStorageWasNotUniquelyReferences() {
        let set = TrieDictionary<TrieKey, Int>()
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
        let trieDictionary1: TrieDictionary<TrieKey, Int> = [(trieKey1, 1), (trieKey2, 2), (trieKey3, 3)]
        let trieDictionary2 = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 2), (trieKey3, 3)])
        
        XCTAssert(trieDictionary1 == trieDictionary2)
    }
    
    // MARK: ExpressibleByDictionaryLiteral
    func testInitWithDictionaryLiteral() {
        let trieKey1 = TrieKey(prompt: "", components: [.stringA("")])
        let trieKey2 = TrieKey(prompt: "", components: [.stringA(""), .stringA("")])
        let trieKey3 = TrieKey(prompt: "", components: [.stringB(""), .stringB(""), .stringB("")])
        let trieDictionary1: TrieDictionary<TrieKey, Int> = [trieKey1: 1, trieKey2: 2, trieKey3: 3]
        let trieDictionary2 = TrieDictionary<TrieKey, Int>([(trieKey1, 1), (trieKey2, 2), (trieKey3, 3)])
        
        XCTAssert(trieDictionary1 == trieDictionary2)
    }
}
