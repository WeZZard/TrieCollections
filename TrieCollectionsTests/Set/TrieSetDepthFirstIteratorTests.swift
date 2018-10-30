//
//  TrieSetDepthFirstIteratorTests.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//

import XCTest

@testable
import TrieCollections


class TrieSetDepthFirstIteratorTests: XCTestCase {
    typealias Iterator = TrieSetDepthFirstIterator<TrieKey>
    
    func test_withDedicatedImpl_doesNotCopyImpl_whenImplWasUniquelyReferenced() {
        let trieSet = TrieSet<TrieKey>()
        var iterator = Iterator(trieSet: trieSet)
        unowned let impl = iterator._impl
        
        XCTAssert(iterator._impl === impl)
        iterator._withDedicatedImpl({ _ in })
        XCTAssert(iterator._impl === impl)
    }
    
    func test_withDedicatedImpl_copiesImpl_whenImplWasNotUniquelyReferenced() {
        let trieSet = TrieSet<TrieKey>()
        var iterator = Iterator(trieSet: trieSet)
        let copiedIterator = iterator
        
        XCTAssert(iterator._impl === copiedIterator._impl)
        iterator._withDedicatedImpl({ _ in })
        XCTAssert(iterator._impl !== copiedIterator._impl)
    }
    
    func testNext_doesNotTriggerCOW_whenImplWasUniquelyReferenced() {
        let trieSet = TrieSet<TrieKey>()
        var iterator = Iterator(trieSet: trieSet)
        unowned let impl = iterator._impl
        
        XCTAssert(iterator._impl === impl)
        _ = iterator.next()
        XCTAssert(iterator._impl === impl)
    }
    
    func testNext_triggersCOW_whenImplWasNotUniquelyReferenced() {
        let trieSet = TrieSet<TrieKey>()
        var iterator = Iterator(trieSet: trieSet)
        let copiedIterator = iterator
        
        XCTAssert(iterator._impl === copiedIterator._impl)
        _ = iterator.next()
        XCTAssert(iterator._impl !== copiedIterator._impl)
    }
}
