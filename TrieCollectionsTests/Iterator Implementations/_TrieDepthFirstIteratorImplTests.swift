//
//  _TrieDepthFirstIteratorImplTests.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//

import XCTest

@testable
import TrieCollections


class _TrieDepthFirstIteratorImplTests: XCTestCase {
    func testInitWithStorage_createsImplWithTheStackContainsInfoOfTheFirstNodeOfTheTrieStorage() {
        let storage = _TrieStorage<TrieKey>()
        
        let impl = _TrieDepthFirstIteratorImpl(storage: storage)
        XCTAssert(impl._stack.elementsEqual([(storage.node, storage.node.nodesMap.startIndex)], by: {$0.0 == $1.0 && $0.1 == $1.1}))
        XCTAssert(impl._elements == [])
    }
    
    func testInitWithImpl_createsImplOfTheSameContent() {
        let storage = _TrieStorage<TrieKey>()
        let element1 = TrieKey(
            prompt: "",
            components: [.stringA("1")]
        )
        storage.insert(element1)
        
        let impl = _TrieDepthFirstIteratorImpl(storage: storage)
        
        let copiedImplInitial = _TrieDepthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack.elementsEqual(copiedImplInitial._stack, by: {$0.0 == $1.0 && $0.1 == $1.1}))
        XCTAssert(impl._elements == copiedImplInitial._elements)
        
        _ = impl.next()
        
        let copiedImplNext = _TrieDepthFirstIteratorImpl(impl: impl)
        
        XCTAssert(impl._stack.elementsEqual(copiedImplNext._stack, by: {$0.0 == $1.0 && $0.1 == $1.1}))
        XCTAssert(impl._elements == copiedImplNext._elements)
    }
    
    func testNext_traverseInDepthFirstOrder() {
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
        
        let impl = _TrieDepthFirstIteratorImpl(storage: storage)
        
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
    
    func testNext_traverseInDepthFirstOrder2() {
        let storage = _TrieStorage<TrieKey>()
        let element11 = TrieKey(
            prompt: "",
            components: [.stringA("1"), .stringA("1")]
        )
        let element12 = TrieKey(
            prompt: "",
            components: [.stringA("1"), .stringA("2")]
        )
        let element21 = TrieKey(
            prompt: "",
            components: [.stringA("2"), .stringA("1")]
        )
        let element22 = TrieKey(
            prompt: "",
            components: [.stringA("2"), .stringA("2")]
        )
        
        storage.insert(element11)
        storage.insert(element12)
        storage.insert(element21)
        storage.insert(element22)
        
        let impl = _TrieDepthFirstIteratorImpl(storage: storage)
        
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
