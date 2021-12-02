//
//  02.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day02a: Solve = { input in
        let instructions = processInput(input)
        let position = moveShip(instructions)
        return "\(position.depth * position.distance)"
    }
    
    @objc static let day02b: Solve = { input in
        let instructions = processInput(input)
        let position = moveShipWithAim(instructions)
        return "\(position.depth * position.distance)"
    }
}

fileprivate func processInput(_ str: String) -> [(String, Int)] {
    return str.split(separator: "\n").compactMap({ processLine(String($0)) })
}

fileprivate func processLine(_ str: String) -> (String, Int)? {
    let split = str.split(separator: " ")
    guard let second = Int(split[1]) else { return nil }
    let first = String(split[0])
    return (first, second)
}

fileprivate func moveShip(_ arr: [(String, Int)]) -> (depth: Int, distance: Int) {
    var depth = 0
    var distance = 0
    for (direction, amount) in arr {
        switch direction {
        case "forward": distance += amount
        case "up": depth -= amount
        case "down": depth += amount
        default: break
        }
    }
    return (depth, distance)
}

fileprivate func moveShipWithAim(_ arr: [(String, Int)]) -> (depth: Int, distance: Int) {
    var depth = 0
    var distance = 0
    var aim = 0
    for (direction, amount) in arr {
        switch direction {
        case "forward":
            distance += amount
            depth += aim * amount
        case "up": aim -= amount
        case "down": aim += amount
        default: break
        }
    }
    return (depth, distance)
}
