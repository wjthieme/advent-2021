//
//  03.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day03a: Solve = { input in
        let config = processInput(input)
        let (gamma, epsilon) = powerComponents(config)
        return "\(gamma * epsilon)"
    }
    
    @objc static let day03b: Solve = { input in
        let config = processInput(input)
        let o2 = airRates(config, comparator: >=)
        let co2 = airRates(config, comparator: <)
        return "\(o2 * co2)"
    }
}

fileprivate func processInput(_ str: String) -> [[Int]] {
    return str.split(separator: "\n").map({ $0.compactMap({ Int(String($0)) }) })
}

fileprivate func powerComponents(_ arr: [[Int]]) -> (Int, Int) {
    let bitLength = arr[0].count
    let cutoff = arr.count / 2
    var count = Array<Int>(repeating: 0, count: bitLength)
    for bits in arr {
        (0..<bitLength).forEach({ count[$0] += bits[$0] })
    }
    let gammaBits = count.map({ String($0 > cutoff ? 1 : 0) }).joined()
    let gamma = Int(gammaBits, radix: 2) ?? 0
    let epsilonBits = count.map({ String($0 <= cutoff ? 1 : 0) }).joined()
    let epsilon = Int(epsilonBits, radix: 2) ?? 0
    return (gamma, epsilon)
}

fileprivate func airRates(_ arr: [[Int]], comparator: (Float, Float) -> Bool) -> Int {
    var remaining = arr
    var counter = 0
    while remaining.count > 1 {
        let cutoff = Float(remaining.count) * 0.5
        var count = Float(0)
        for bits in remaining {
            count += Float(bits[counter])
        }
        let target = comparator(count, cutoff) ? 1 : 0
        remaining.removeAll(where: { $0[counter] != target })
        counter += 1
    }
    let bits = remaining[0].map({ String($0) }).joined()
    let rate = Int(bits, radix: 2) ?? 0
    return rate
}
