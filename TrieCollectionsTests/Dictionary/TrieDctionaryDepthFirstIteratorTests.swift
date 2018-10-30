//
//  TrieDctionaryDepthFirstIteratorTests.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//

import XCTest

@testable
import TrieCollections


class TrieDctionaryDepthFirstIteratorTests: XCTestCase {
    typealias Iterator = TrieDictionaryDepthFirstIterator<TrieKey, Int>
    
    func test_withDedicatedImpl_doesNotCopyImpl_whenImplWasUniquelyReferenced() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        var iterator = Iterator(trieDictionary: trieDictionary)
        unowned let impl = iterator._impl
        
        XCTAssert(iterator._impl === impl)
        iterator._withDedicatedImpl({ _ in })
        XCTAssert(iterator._impl === impl)
    }
    
    func test_withDedicatedImpl_copiesImpl_whenImplWasNotUniquelyReferenced() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        var iterator = Iterator(trieDictionary: trieDictionary)
        let copiedIterator = iterator
        
        XCTAssert(iterator._impl === copiedIterator._impl)
        iterator._withDedicatedImpl({ _ in })
        XCTAssert(iterator._impl !== copiedIterator._impl)
    }
    
    func testNext_doesNotTriggerCOW_whenImplWasUniquelyReferenced() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        var iterator = Iterator(trieDictionary: trieDictionary)
        unowned let impl = iterator._impl
        
        XCTAssert(iterator._impl === impl)
        _ = iterator.next()
        XCTAssert(iterator._impl === impl)
    }
    
    func testNext_triggersCOW_whenImplWasNotUniquelyReferenced() {
        let trieDictionary = TrieDictionary<TrieKey, Int>()
        var iterator = Iterator(trieDictionary: trieDictionary)
        let copiedIterator = iterator
        
        XCTAssert(iterator._impl === copiedIterator._impl)
        _ = iterator.next()
        XCTAssert(iterator._impl !== copiedIterator._impl)
    }
}
