//
//  07.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day07a: Solve = { input in
        let crabs = processInput(input)
        let geometricMedian = findGeometricMedian(crabs, sumDistance)
        let sum = sumDistance(crabs, to: geometricMedian)
        return "\(sum)"
    }
    
    @objc static let day07b: Solve = { input in
        let crabs = processInput(input)
        let geometricMedian = findGeometricMedian(crabs, exponentialSumDistance)
        let sum = exponentialSumDistance(crabs, to: geometricMedian)
        return "\(sum)"
    }
}

fileprivate let exponentialDistances = (0...2000).map({ (0...$0).reduce(0, +) })

fileprivate func processInput(_ str: String) -> [Int] {
    return str.replacingOccurrences(of: "\n", with: "").split(separator: ",").compactMap({ Int($0) })
}

fileprivate func findGeometricMedian(_ arr: [Int], _ distancer: (([Int], Int) -> Int)) -> Int {
    let distances = (0..<1500).map({ distancer(arr, $0) })
    guard let min = distances.enumerated().min(by: { $0.element < $1.element })?.offset else { return 0 }
    return min
}

fileprivate func sumDistance(_ arr: [Int], to point: Int) -> Int {
    return arr.map({ abs($0 - point) }).reduce(0, +)
}

fileprivate func exponentialSumDistance(_ arr: [Int], to point: Int) -> Int {
    return arr.map({ exponentialDistances[abs($0 - point)] }).reduce(0, +)
}
