//
//  Array+IsEqualToContentsOfTests.swift
//  TrieCollections
//
//  Created on 29/10/2018.
//

import XCTest

@testable
import TrieCollections


class Array_IsEqualToContentsOfTests: XCTestCase {
    func testIsEqualToContentOf_returnsFalse_whenMemebersAreNotSame() {
        XCTAssert(![0]._isEqualTo(contentsOf: []))
        XCTAssert(![]._isEqualTo(contentsOf: [0]))
    }
    
    func testIsEqualToContentOf_returnsTrue_whenMemebersAreAllSameWithoutConsideringOrder() {
        XCTAssert([0, 1, 2]._isEqualTo(contentsOf: [2, 1, 0]))
        XCTAssert([0, 1, 2]._isEqualTo(contentsOf: [0, 1, 2]))
    }
}
