//
//  ImArrayTests.swift
//  ImStructures
//
//  Created by Terry Lewis II on 6/8/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

import XCTest
import ImStructures

class ImArrayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImArrayInit() {
        let withArray = ImArray(array: [1,2,3,4,5])
        let withItems = ImArray(items: 1,2,3,4,5)
        
        XCTAssert(withArray == withItems, "Should be equal")
        
        let single = ImArray(item: 1)
        XCTAssert(single.count == 1, "Should be 1")
    }
    
    func testJoin() {
        let withArray = ImArray(array: [1,2,3,4,5])
        let joined = withArray.join([6,7,8])
        XCTAssert(joined == ImArray(items: 1,2,3,4,5,6,7,8), "Should be equal")
    }
    
    func testAppend() {
        let withArray = ImArray(array: [1,2,3,4,5])
        let joined = withArray += 6
        XCTAssert(joined == ImArray(items: 1,2,3,4,5,6), "Should be equal")
    }
}
