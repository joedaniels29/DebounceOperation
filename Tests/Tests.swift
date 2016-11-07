//
//  Tests.swift
//  DebounceOperation
//
//  Created by Károly Lőrentey on 2016-03-08.
//  Copyright © 2016 Károly Lőrentey.
//

import XCTest
@testable import DebounceOperation

class DebounceOperationTests: XCTestCase {
    
    var isTrue: Bool = false
    
    var pq = OperationQueue()
    func testDebounce() {
        let expectation = self.expectation(description: "fulfill")
        let  db = DebouncingOperation(delay:3){
            self.isTrue = true
            expectation.fulfill()
        }
        pq.addOperation(db)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){db.debounce()}
        self.waitForExpectations(timeout: 10, handler: { err in
          
        })
    }
}
