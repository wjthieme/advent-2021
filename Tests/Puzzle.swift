//
//  Puzzle.swift
//  Tests
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation
@testable import Advent

extension Puzzle {
    var testInput: String { return Inputs.value(forKey: rawValue) as? String ?? "" }
    var expectedTestOutput: String { return Outputs.value(forKey: rawValue) as? String ?? "0" }
}

class Inputs: NSObject {
    override static func value(forUndefinedKey key: String) -> Any? { return nil }
}

class Outputs: NSObject {
    override static func value(forUndefinedKey key: String) -> Any? { return nil }
}
