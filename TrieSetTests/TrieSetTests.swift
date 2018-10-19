//
//  TrieSetTests.swift
//  TrieSet
//
//  Created on 7/29/18.
//

import XCTest

@testable
import TrieSet


class TrieSetTests: XCTestCase {
    func testInitDoesNotThrow() {
        XCTAssertNoThrow(TrieSet<TrieElement>())
    }
    
    func testInit() {
        let trieSet = TrieSet<TrieElement>()
        
        XCTAssert(trieSet.isEmpty)
    }
    
    func testInsertDoesNotThrow() {
        var trieSet = TrieSet<TrieElement>()
        XCTAssertNoThrow(trieSet.insert(TrieElement(prompt: "")))
    }
    
    func testInsertToEmptyTrieSet() {
        
    }
    
    func testInsertWithRepetition() {
        
    }
}
