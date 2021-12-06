//
//  06.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day06a: Solve = { input in
        let fish = processInput(input)
        let fishCount = countFish(fish, days: 80)
        return "\(fishCount)"
    }
    
    @objc static let day06b: Solve = { input in
        let fish = processInput(input)
        let fishCount = countFish(fish, days: 256)
        return "\(fishCount)"
    }
}

fileprivate func processInput(_ str: String) -> [Int] {
    return str.replacingOccurrences(of: "\n", with: "").split(separator: ",").compactMap({ Int($0) })
}

fileprivate func countFish(_ fish: [Int], days: Int) -> Int {
    var fish = (0..<9).map({ x in fish.filter({ $0 == x }).count })
    for _ in 1...days {
        let bornFish = fish[0]
        fish.removeFirst()
        fish[6] += bornFish
        fish.append(bornFish)
    }
    return fish.reduce(0, +)
}

