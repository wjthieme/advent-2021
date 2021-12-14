//
//  14.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

fileprivate typealias Template = [String: Int]
fileprivate typealias Rules = [String: String]

extension Solvers {
    @objc static let day14a: Solve = { input in
        let (template, rules) = processInput(input)
        let result = executeSteps(template, rules, 10)
        let counts = calculateCounts(result)
        let min = counts.min(by: { $0.value < $1.value })?.value ?? 0
        let max = counts.max(by: { $0.value < $1.value })?.value ?? 0
        return "\(max - min)"
    }
    
    @objc static let day14b: Solve = { input in
        let (template, rules) = processInput(input)
        let result = executeSteps(template, rules, 40)
        let counts = calculateCounts(result)
        let min = counts.min(by: { $0.value < $1.value })?.value ?? 0
        let max = counts.max(by: { $0.value < $1.value })?.value ?? 0
        return "\(max - min)"
    }
}

fileprivate func processInput(_ str: String) -> (Template, Rules) {
    let split = str.components(separatedBy: "\n\n")
    let template = processTemplate(split[0])
    let lines = split[1].split(separator: "\n")
    let rules = lines.map({ processRule(String($0)) }).reduce(into: [:]) { $0[$1.0] = $1.1 }
    return (template, rules)
}

fileprivate func processTemplate(_ str: String) -> Template {
    var template: Template = [:]
    for n in 1..<str.count {
        let start = str.index(str.startIndex, offsetBy: n-1)
        let end = str.index(str.startIndex, offsetBy: n)
        let bond = String(str[start...end])
        let count = template[bond] ?? 0
        template[bond] = count + 1
    }
    return template
}

fileprivate func processRule(_ str: String) -> (String, String) {
    let split = str.components(separatedBy: " -> ")
    return (split[0], split[1])
}

fileprivate func executeSteps(_ template: Template, _ rules: Rules, _ steps: Int) -> Template {
    var template = template
    for _ in 0..<steps {
        template = executeStep(template, rules)
    }
    return template
}

fileprivate func executeStep(_ template: Template, _ rules: Rules) -> Template {
    var out: Template = [:]
    for (bond, amount) in template {
        if let insert = rules[bond] {
            let start = bond.startIndex
            let end = bond.index(bond.startIndex, offsetBy: 1)
            out.increment("\(bond[start])\(insert)", with: amount)
            out.increment("\(insert)\(bond[end])", with: amount)
        } else {
            out.increment(bond, with: amount)
        }
    }
    return out
}

fileprivate func calculateCounts(_ template: Template) -> [Character: Int] {
    var starts: [Character: Int] = [:]
    var ends: [Character: Int] = [:]
    for (bond, amount) in template {
        let start = bond.startIndex
        let end = bond.index(bond.startIndex, offsetBy: 1)
        starts.increment(bond[start], with: amount)
        ends.increment(bond[end], with: amount)
    }
    let keys = Set(starts.keys).intersection(ends.keys)
    var counts: [Character: Int] = [:]
    for key in keys {
        let start = starts[key] ?? 0
        let end = ends[key] ?? 0
        counts[key] = max(start, end)
    }
    return counts
}

fileprivate extension Dictionary where Value == Int {
    mutating func increment(_ key: Key, with amount: Value) {
        let current = self[key] ?? 0
        self[key] = current + amount
    }
}
