//
//  Tests.swift
//  Tests
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import XCTest
@testable import Advent

class Tests: XCTestCase {
    
    private var puzzle: Puzzle!
    
    override open class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        for puzzle in Puzzle.allCases {
            
            let block: @convention(block) () -> Void = {
                let testOutput = puzzle.solve(puzzle.testInput)
                XCTAssertEqual(testOutput, puzzle.expectedTestOutput)
            }
            let imp = imp_implementationWithBlock(block)
            let selector = NSSelectorFromString("test_\(puzzle.rawValue)")
            class_addMethod(self, selector, imp, "v@:")

        }
        for invocation in testInvocations {
            let testCase = Tests(invocation: invocation)
            testSuite.addTest(testCase)
        }
        return testSuite
    }

}
