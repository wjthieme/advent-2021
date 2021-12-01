//
//  01.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day01a: Solve = { input in
        let integers = processInput(input)
        let result = countIncreases(integers)
        return "\(result)"
    }
    
    @objc static let day01b: Solve = { input in
        let integers = processInput(input)
        let result = countIncreases(integers, window: 3)
        return "\(result)"
    }
}


fileprivate func processInput(_ str: String) -> [Int] {
    return str.split(separator: "\n").compactMap { Int($0) }
}

fileprivate func countIncreases(_ arr: [Int], window: Int = 1) -> Int {
    var previous = Int.max
    var count = 0
    for n in 0...arr.count-window {
        var sum = 0
        for k in 0..<window {
            sum += arr[n + k]
        }
        if sum > previous {
            count += 1
        }
        previous = sum
    }
    return count
}
