//
//  HTTPOperationTest.swift
//  MoviesTests
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import XCTest
@testable import Movies

class HTTPOperationTest: XCTestCase {

  var operationQueue: OperationQueue?

  override func setUp() {
    operationQueue = OperationQueue()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    operationQueue = nil
  }

  func testCorrect_URL() {
    if let url = URL(string: "https://www.google.com/") {
      let exp = expectation(description: "\(#function)\(#line)")
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        exp.fulfill()
      }

      operationQueue?.addOperation(operation)
      waitForExpectations(timeout: 40, handler: nil)
    }
    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }

  func test_combination_URLMultiple() {
    let exp = expectation(description: "\(#function)\(#line)")
    exp.expectedFulfillmentCount = 3
    if let url = URL(string: "https://www.apple.com/") {
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("1 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
    }
    if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("2 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
    }

    if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("3 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
    }

    waitForExpectations(timeout: 40, handler: nil)
  }

  func testCorrect_URLMultiple() {
    if let url = URL(string: "https://www.google.com/") {
      let exp = expectation(description: "\(#function)\(#line)")
      exp.expectedFulfillmentCount = 4
      var operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("1 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
      operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("2 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
      operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("3 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
      operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(true)
        case .failure(_):
          XCTAssert(false)
        }
        print ("4 fulfill")
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
      waitForExpectations(timeout: 40, handler: nil)
    }
    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }

  func testBad_URL() {
    if let url = URL(string: "https://www.googe.com/") {
      let exp = expectation(description: "\(#function)\(#line)")
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(false)
        case .failure(_):
          XCTAssert(true)
        }
        exp.fulfill()
      }

      operationQueue?.addOperation(operation)
      waitForExpectations(timeout: 240, handler: nil)
    }
    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }

  //Fail Method not allowed
  func test_http_URL() {
    if let url = URL(string: "http://httpbin.org/post") {
      let exp = expectation(description: "\(#function)\(#line)")
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(false)
        case .failure(_):
          XCTAssert(true)
        }
        exp.fulfill()
      }

      operationQueue?.addOperation(operation)
      waitForExpectations(timeout: 40, handler: nil)
    }
    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }

  func test_URL_cancel() {
    if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") {
      let exp = expectation(description: "\(#function)\(#line)")
      exp.isInverted = true
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(false)
        case .failure(_):
          XCTAssert(false)
        }
      }
      operationQueue?.addOperation(operation)
      XCTAssert(operation.isAsynchronous == true)
      operation.cancel()
      waitForExpectations(timeout: 5, handler: nil)
    }

    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }

  func test_URL_cancel_1() {
    if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") {
      let exp = expectation(description: "\(#function)\(#line)")
      exp.isInverted = true
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(false)
        case .failure(_):
          XCTAssert(false)
        }
      }
      operationQueue?.isSuspended = true
      operationQueue?.addOperation(operation)
      operation.cancel()
      XCTAssert(operation.isCancelled, "Operation is not Cancelled")
      operationQueue?.isSuspended = false
      XCTAssert(operation.isExecuting == false, "Operation is Executing")

      waitForExpectations(timeout: 1, handler: nil)
    }

    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }

  func test_https_URL_method_not_allowed() {
    if let url = URL(string: "https://httpbin.org/post") {
      let exp = expectation(description: "\(#function)\(#line)")
      let operation = HTTPOperation(url: url) { (result) in
        switch result {
        case .success(_):
          XCTAssert(false)
        case .failure(let error):
          if case HTTPError.badHTTPStatus(let reason, let httpCode) = error {
            XCTAssert(error.code == 405, "HTTP Error code dose not match")
            XCTAssert(error.code == httpCode, "HTTP Error code dose not match")
            XCTAssert(reason == error.localizedDescription, "HTTP Error message dose not match")
          }
          else {
            XCTAssert(false, "Invalid error type")
          }
        }
        exp.fulfill()
      }
      operationQueue?.addOperation(operation)
      waitForExpectations(timeout: 40, handler: nil)
    }
    else {
      XCTAssert(false, "Unable to intialize url")
    }
  }
}
