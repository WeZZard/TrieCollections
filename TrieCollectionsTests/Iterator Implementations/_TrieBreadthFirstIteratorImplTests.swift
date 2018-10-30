//
//  _TrieBreadthFirstIteratorImplTests.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//

import XCTest

@testable
import TrieCollections


class _TrieBreadthFirstIteratorImplTests: XCTestCase {
    func testInitWithStorage_createsImplWithTheStackContainsTheFirstNodeOfTheTrieStorage() {
        let storage = _TrieStorage<TrieKey>()
        
        let impl = _TrieBreadthFirstIteratorImpl(storage: storage)
        XCTAssert(impl._stack == [storage.node])
        XCTAssert(impl._elements == [])
    }
    
    func testInitWithImpl_createsImplOfTheSameContent() {
        let storage = _TrieStorage<TrieKey>()
        let element1 = TrieKey(
            prompt: "",
            components: [.stringA("1")]
        )
        storage.insert(element1)
        
        let impl = _TrieBreadthFirstIteratorImpl(storage: storage)
        
        let copiedImplInitial = _TrieBreadthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack == copiedImplInitial._stack)
        XCTAssert(impl._elements == copiedImplInitial._elements)
        
        _ = impl.next()
        
        let copiedImplNext = _TrieBreadthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack == copiedImplNext._stack)
        XCTAssert(impl._elements == copiedImplNext._elements)
    }
    
    func testNext_traverseInBreadthFirstOrder() {
        let storage = _TrieStorage<TrieKey>()
        let element0 = TrieKey(
            prompt: "",
            components: []
        )
        let element1 = TrieKey(
            prompt: "",
            components: [.stringA("1")]
        )
        let element12 = TrieKey(
            prompt: "",
            components: [.stringA("1"), .stringA("2")]
        )
        let element123 = TrieKey(
            prompt: "",
            components: [.stringA("1"), .stringA("2"), .stringA("3")]
        )
        let element2 = TrieKey(
            prompt: "",
            components: [.stringA("2")]
        )
        let element22 = TrieKey(
            prompt: "",
            components: [.stringA("2"), .stringA("2")]
        )
        
        storage.insert(element0)
        storage.insert(element1)
        storage.insert(element12)
        storage.insert(element123)
        storage.insert(element2)
        storage.insert(element22)
        
        let impl = _TrieBreadthFirstIteratorImpl(storage: storage)
        
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
