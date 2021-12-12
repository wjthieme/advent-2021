//
//  12.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day12a: Solve = { input in
        let map = Map(input)
        let paths = recursivePaths(map)
        return "\(paths.count)"
    }
    
    @objc static let day12b: Solve = { input in
        let map = Map(input)
        let paths = recursivePaths(map, allowDoubleVisit: true)
        return "\(paths.count)"
    }
}


fileprivate func recursivePaths(_ map: Map, node: Node? = nil, path: Path = [], allowDoubleVisit: Bool = false) -> [Path] {
    let node = node ?? map.startNode
    var path = path
    path.append(node)
    if node == map.endNode { return [path] }
    let options = node.connections.filter({ canVisit(map, node: $0, path: path, allowDoubleVisit: allowDoubleVisit) })
    return options.flatMap({ recursivePaths(map, node: $0, path: path, allowDoubleVisit: allowDoubleVisit) })
}

fileprivate func canVisit(_ map: Map, node: Node, path: Path, allowDoubleVisit: Bool) -> Bool {
    if node.isBigCave { return true }
    let canVisitSmallCaveTwice = path.filter({ !$0.isBigCave }).isUnique
    if node == map.startNode || node == map.endNode { return !path.contains(node) }
    if allowDoubleVisit && canVisitSmallCaveTwice { return true }
    return !path.contains(node)
}


fileprivate class Map {
    let nodes: Set<Node>
    
    init(_ str: String) {
        let paths = str.split(separator: "\n").map({ $0.split(separator: "-") })
        nodes = Set(paths.flatMap({  $0.map({ Node(String($0)) }) }))
        for (one, two) in paths.map({ (String($0[0]), String($0[1])) }) {
            let first = nodes.first(where: { $0.id == one })!
            let second = nodes.first(where: { $0.id == two })!
            first.connections.update(with: second)
            second.connections.update(with: first)
        }
    }
    
    var startNode: Node { nodes.first(where: { $0.id == "start" })! }
    var endNode: Node { nodes.first(where: { $0.id == "end" })! }
}

fileprivate class Node: Hashable, CustomStringConvertible {
    static func == (lhs: Node, rhs: Node) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    var description: String { id }
    
    let id: String
    var connections: Set<Node> = []
    
    init(_ str: String) {
        id = str
    }
    
    var isBigCave: Bool { id.uppercased() == id }
}

fileprivate typealias Path = [Node]
fileprivate extension Path {
    var description: String { map({ String(describing: $0) }).joined(separator: ",") }
    var isUnique: Bool {
        var seen = Set<Int>()
        return allSatisfy { seen.insert($0.hashValue).inserted }
    }
}
