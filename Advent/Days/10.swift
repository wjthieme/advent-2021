//
//  10.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day10a: Solve = { input in
        let code = processInput(input)
        let corruption = code.compactMap({ $0.corruption() })
        let score = corruption.compactMap({ corruptionMap[$0] }).reduce(0, +)
        return "\(score)"
    }
    
    @objc static let day10b: Solve = { input in
        let code = processInput(input)
        let incomplete = code.filter({ $0.corruption() == nil })
        let completion = incomplete.map({ $0.autocomplete() })
        let score = completion.map({ scoreAutocompletion($0) }).sorted()
        let median = score[Int(score.count/2)]
        return "\(median)"
    }
}

fileprivate func processInput(_ str: String) -> [Code] {
    return str.split(separator: "\n").map({ Code(String($0)) })
}

fileprivate func scoreAutocompletion(_ str: String) -> Int {
    var score = 0
    for character in str {
        score *= 5
        score += autiocompletionMap[character] ?? 0
    }
    return score
}


fileprivate struct Code {
    
    private let line: String
    init(_ str: String) { line = str }
    
    func corruption() -> Character? {
        var open: String = ""
        for character in line {
            if openSet.contains(character) {
                open.append(character)
            } else {
                if open.last == closeMap[character] {
                    open.removeLast()
                } else {
                    return character
                }
            }
        }
        return nil
    }
    
    func autocomplete() -> String {
        var open: String = ""
        for character in line {
            if openSet.contains(character) {
                open.append(character)
            } else {
                if open.last == closeMap[character] {
                    open.removeLast()
                }
            }
        }
        return open.reversed().map({ String(openMap[$0] ?? Character("")) }).joined()
    }
    

    
}
fileprivate var openSet: Set<Character> = Set(["(", "[", "{", "<"])
fileprivate var openMap: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
fileprivate var closeMap: [Character: Character] = [")": "(", "]": "[", "}": "{", ">": "<"]
fileprivate var corruptionMap: [Character: Int] = [ ")": 3, "]": 57, "}": 1197, ">": 25137 ]
fileprivate var autiocompletionMap: [Character: Int] = [ ")": 1, "]": 2, "}": 3, ">": 4 ]
