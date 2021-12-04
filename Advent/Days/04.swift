//
//  04.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day04a: Solve = { input in
        let numbers = getBingoNumbers(input)
        let cards = getBingoCards(input)
        let result = winningBoard(numbers, cards: cards)
        return "\(result)"
    }
    
    @objc static let day04b: Solve = { input in
        let numbers = getBingoNumbers(input)
        let cards = getBingoCards(input)
        let result = losingBoard(numbers, cards: cards)
        return "\(result)"
    }
}


fileprivate func getBingoNumbers(_ str: String) -> [Int] {
    return str.components(separatedBy: "\n\n")[0].split(separator: ",").compactMap({ Int($0) })
}

fileprivate func getBingoCards(_ str: String) -> [[[Int]]] {
    let splits = str.components(separatedBy: "\n\n")
    return (1..<splits.count).map({ processBingoCard(splits[$0]) })
}

fileprivate func processBingoCard(_ str: String) -> [[Int]] {
    return str.split(separator: "\n").map({ $0.split(separator: " ").compactMap({ Int($0) }) })
}

fileprivate func winningBoard(_ numbers: [Int], cards: [[[Int]]]) -> Int {
    var bingos = cards
    var index = 0
    while findBingo(bingos) == -1 {
        for z in (0..<bingos.count) {
            for x in (0..<5) {
                for y in (0..<5) {
                    if bingos[z][x][y] == numbers[index] {
                        bingos[z][x][y] = -1
                    }
                }
            }
        }
        index += 1
    }
    let bingo = findBingo(bingos)
    let sum = bingos[bingo].flatMap({ $0 }).filter({ $0 != -1 }).reduce(0, +)
    return sum * numbers[index-1]
}

fileprivate func losingBoard(_ numbers: [Int], cards: [[[Int]]]) -> Int {
    var bingos = cards
    var index = 0
    var lastBingo = -1
    var foundBingos = Set<Int>()
    while foundBingos.count != bingos.count {
        for z in (0..<bingos.count).reversed() {
            for x in (0..<5) {
                for y in (0..<5) {
                    if bingos[z][x][y] == numbers[index] {
                        bingos[z][x][y] = -1
                    }
                }
            }
            if hasBingo(bingos[z]) && !foundBingos.contains(z) {
                foundBingos.update(with: z)
                lastBingo = z
            }
        }
        index += 1
    }
    let sum = bingos[lastBingo].flatMap({ $0 }).filter({ $0 != -1 }).reduce(0, +)
    return sum * numbers[index-1]
}

fileprivate func findBingo(_ bingos: [[[Int]]]) -> Int {
    for z in (0..<bingos.count) {
        if hasBingo(bingos[z]) {
            return z
        }
    }
    return -1
}

fileprivate func hasBingo(_ bingo: [[Int]]) -> Bool {
    for n in (0..<5) {
        let rowSum = (0..<5).map({ bingo[n][$0] }).reduce(0, +)
        let colSum = (0..<5).map({ bingo[$0][n] }).reduce(0, +)
        if rowSum == -5 || colSum == -5 {
            return true
        }
    }
    return false
}
