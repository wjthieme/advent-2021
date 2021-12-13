//
//  13.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day13a: Solve = { input in
        var paper = Paper(input)
        let fold = processFolds(input)[0]
        paper.fold(fold)
        return "\(paper.count)"
    }
    
    @objc static let day13b: Solve = { input in
        var paper = Paper(input)
        processFolds(input).forEach({ paper.fold($0) })
        return "\(paper.count)"
    }
}


fileprivate func processFolds(_ str: String) -> [Fold] {
    return str.components(separatedBy: "\n\n")[1].split(separator: "\n").map({ processFold(String($0)) })
}

fileprivate func processFold(_ str: String) -> Fold {
    let split = str.split(separator: "=")
    let axis = split[0].last ?? Character("")
    let line = Int(split[1]) ?? 0
    return (axis, line)
}


fileprivate typealias Fold = (axis: Character, line: Int)
fileprivate struct Paper: CustomStringConvertible {
    private var dots: Set<Dot>
    
    init(_ str: String) {
        dots = Set(str.components(separatedBy: "\n\n")[0].split(separator: "\n").map({ Dot(String($0)) }))
    }
    
    mutating func fold(_ fold: Fold) {
        switch fold.axis {
        case "x":
            dots = dots.filter({ $0.x != fold.line })
            dots = Set(dots.map({ $0.x > fold.line ? Dot(fold.line - ($0.x - fold.line), $0.y) : $0 }))
        case "y":
            dots = dots.filter({ $0.y != fold.line })
            dots = Set(dots.map({ $0.y > fold.line ? Dot($0.x, fold.line - ($0.y - fold.line)) : $0 }))
        default: break
        }
    }
    
    var count: Int { return dots.count }
    var height: Int { return dots.max(by: { $0.y < $1.y })?.y ?? 0 }
    var width: Int { return dots.max(by: { $0.x < $1.x })?.x ?? 0 }
    var description: String { (0...height).map({ y in (0...width).map({ x in dots.contains(Dot(x, y)) ? "#" : "." }).joined() }).joined(separator: "\n") }
}

fileprivate struct Dot: Hashable {
    let x: Int
    let y: Int
    
    init(_ str: String) {
        let split = str.split(separator: ",")
        x = Int(split[0]) ?? 0
        y = Int(split[1]) ?? 0
    }
                
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
