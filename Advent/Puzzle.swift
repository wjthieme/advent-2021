//
//  Puzzle.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

typealias Solve = @convention(block) (String) -> String

public enum Puzzle: String, CaseIterable {
    case day01a, day01b
    case day02a, day02b
    case day03a, day03b
    case day04a, day04b
    case day05a, day05b
    case day06a, day06b
    case day07a, day07b
    case day08a, day08b
    case day09a, day09b
    case day10a, day10b
    case day11a, day11b
    case day12a, day12b
    case day13a, day13b
    case day14a, day14b
    case day15a, day15b
    case day16a, day16b
    case day17a, day17b
    case day18a, day18b
    case day19a, day19b
    case day20a, day20b
    case day21a, day21b
    case day22a, day22b
    case day23a, day23b
    case day24a, day24b
    case day25a, day25b
    
    
    public func solve(_ input: String) -> String {
        let block = Solvers.value(forKey: rawValue) as AnyObject
        let solver = unsafeBitCast(block, to: Solve.self)
        return solver(input)
    }
    
}

class Solvers: NSObject {
    override static func value(forUndefinedKey key: String) -> Any? { return { _ in "-1" } as Solve }
}
