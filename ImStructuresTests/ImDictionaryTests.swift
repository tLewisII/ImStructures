//
//  ImDictionaryTests.swift
//  ImStructures
//
//  Created by Terry Lewis II on 6/13/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

import XCTest
import ImStructures

class ImDictionaryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        
        XCTAssert(dict == ImDictionary(dict: [1:2, 3:4, 5:6]), "Should be equal")
    }
    
    func testUpdate() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        
        let newDict = dict.update(1, v: 10)
        
        XCTAssert(newDict == ImDictionary(dict: [1:10, 3:4, 5:6]), "Should be equal")
        XCTAssert(dict == ImDictionary(dict:[1:2, 3:4, 5:6]), "Should not be changed")
    }
    
    func testProperties() {
        let empty = ImDictionary<Int, Int>()
        XCTAssert(empty.null == true, "Should be true")
        
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        
        XCTAssert(dict.count == 3, "Should be 3 key/value pairs")

        XCTAssert(dict.keys.count == 3, "Should be 3")
        XCTAssert(dict.values.count == 3, "Should be 3")
    }
    
    func testFindWithDefault() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        
        XCTAssert(dict.findWithDefault(10, def: -1) == -1, "Should be -1")
        XCTAssert(dict.findWithDefault(1, def: -1) == 2, "Should be -1")
    }
    
    func testRemove() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        let newDict = dict.remove(3)
        
        XCTAssert(newDict == ImDictionary(dict: [1:2, 5:6]), "Should be equal")
        XCTAssert(dict == ImDictionary(dict: [1:2, 3:4, 5:6]), "Should be equal")
    }
    
    func testFilter() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        let newDict = dict.filter{$0 == 3 && $1 == 4}
        
        XCTAssert(newDict == ImDictionary(dict: [3:4]), "Should be equal")
    }
    
    func testMap() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        let newDict = dict.map{($0 + 1, $1 + 1)}
        
        XCTAssert(newDict == ImDictionary(dict: [2:3, 4:5, 6:7]), "Should be equal")
    }
    
    func testReduce() {
        let dict:ImDictionary<Int, Int> = [1:2, 3:4, 5:6]
        
        XCTAssert(dict.reduce(0){$0 + $1 + $2} == 21, "Should be 21")
    }
}
