//
//  05.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

fileprivate typealias Line = (x1: Int, y1: Int, x2: Int, y2: Int)
fileprivate typealias Map = [[Int]]

extension Solvers {
    @objc static let day05a: Solve = { input in
        let lines = processInput(input).filter({ isHorizontal($0) || isVertical($0) })
        let map = drawLines(lines)
        let overlaps = countOverlaps(map)
        return "\(overlaps)"
    }
    
    @objc static let day05b: Solve = { input in
        let lines = processInput(input).filter({ isHorizontal($0) || isVertical($0) || isDiagonal($0) })
        let map = drawLines(lines)
        let overlaps = countOverlaps(map)
        return "\(overlaps)"
    }
}

fileprivate func processInput(_ str: String) -> [Line] {
    return str.split(separator: "\n").map({ processLine(String($0)) })
}

fileprivate func processLine(_ str: String) -> Line {
    let splits = str.components(separatedBy: " -> ")
    let first = splits[0].split(separator: ",").compactMap({ Int($0) })
    let second = splits[1].split(separator: ",").compactMap({ Int($0) })
    return (first[0], first[1], second[0], second[1])
}

fileprivate func isHorizontal(_ line: Line) -> Bool { line.y1 == line.y2 }
fileprivate func isVertical(_ line: Line) -> Bool { line.x1 == line.x2 }
fileprivate func isDiagonal(_ line: Line) -> Bool { abs(line.x1 - line.x2) == abs(line.y1 - line.y2) }

fileprivate func drawLines(_ lines: [Line]) -> Map {
    var map = Map(repeating: [Int](repeating: 0, count: 1000), count: 1000)
    for line in lines {
        if isHorizontal(line) {
            for x in min(line.x1, line.x2)...max(line.x1, line.x2) {
                map[line.y1][x] += 1
            }
        }
        if isVertical(line) {
            for y in min(line.y1, line.y2)...max(line.y1, line.y2) {
                map[y][line.x1] += 1
            }
        }
        if isDiagonal(line) {
            let diff = abs(line.x1 - line.x2)
            let xDir = line.x2 > line.x1 ? Int.addingReportingOverflow : Int.subtractingReportingOverflow
            let yDir = line.y2 > line.y1 ? Int.addingReportingOverflow : Int.subtractingReportingOverflow
            
            for n in 0...diff {
                let y = yDir(line.y1)(n).partialValue
                let x = xDir(line.x1)(n).partialValue
                map[y][x] += 1
            }
        }
    }
    return map
}

fileprivate func countOverlaps(_ map: Map) -> Int {
    return map.flatMap({ $0 }).filter({ $0 > 1 }).count
}


