//
//  08.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

fileprivate typealias InputOutput = (input: [Set<Character>], output: [Set<Character>])

extension Solvers {
    @objc static let day08a: Solve = { input in
        let values = processInput(input)
        let count = countOutputValues(values)
        return "\(count)"
    }
    
    @objc static let day08b: Solve = { input in
        let values = processInput(input)
        let decoded = decodeOutput(values)
        let sum = decoded.reduce(0, +)
        return "\(sum)"
    }
}

fileprivate func processInput(_ str: String) -> [InputOutput] {
    return str.split(separator: "\n").map({ processLine(String($0)) })
}

fileprivate func processLine(_ str: String) -> InputOutput {
    let split = str.components(separatedBy: " | ")
    let first = split[0].split(separator: " ").map({ Set($0) })
    let second = split[1].split(separator: " ").map({ Set($0) })
    return (first, second)
}

fileprivate func countOutputValues(_ arr: [InputOutput]) -> Int {
    let outputs = arr.flatMap({ $0.1 })
    let ones = outputs.filter({ $0.count == 2 }).count
    let fours = outputs.filter({ $0.count == 4 }).count
    let sevens = outputs.filter({ $0.count == 3 }).count
    let eights = outputs.filter({ $0.count == 7 }).count
    return ones + fours + sevens + eights
}

fileprivate func decodeOutput(_ arr: [InputOutput]) -> [Int] {
    var outputs: [Int] = []
    for line in arr {
        let one = line.input.first(where: { $0.count == 2 })!
        let four = line.input.first(where: { $0.count == 4 })!
        let seven = line.input.first(where: { $0.count == 3 })!
        let eight = line.input.first(where: { $0.count == 7 })!
        let three = line.input.first(where: { $0.count == 5 && $0.intersection(one) == one })!
        let nine = three.union(four)
        let five = line.input.first(where: { $0.count == 5 && $0.union(one) == nine })!
        let two = line.input.first(where: { $0.count == 5 && $0 != five && $0 != three })!
        let zero = line.input.first(where: { $0.count == 6 && $0.intersection(one) == one && $0 != nine })!
        let six = line.input.first(where: { $0.count == 6 && $0 != zero && $0 != nine })!
        let decoder = [zero, one, two, three, four, five, six, seven, eight, nine].enumerated()
        let number = line.output.map({ x in "\(decoder.first(where: { $0.element == x })!.offset)" }).joined()
        if let integer = Int(number) {
            outputs.append(integer)
        }
    }
    return outputs
}

