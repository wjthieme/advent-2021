//
//  11.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day11a: Solve = { input in
        let map = Map(str: input)
        let flashes = simulateSteps(map, 100)
        return "\(flashes)"
    }
    
    @objc static let day11b: Solve = { input in
        let map = Map(str: input)
        let step = allFlashing(map)
        return "\(step)"
    }
}

fileprivate func allFlashing(_ map: Map) -> Int {
    var map = map
    var counter = 0
    while map.contains(where: { map[$0] != 0 }) {
        _ = simulateStep(&map)
        counter += 1
    }
    return counter
}

fileprivate func simulateSteps(_ map: Map, _ steps: Int) -> Int {
    var flashes = 0
    var map = map
    for _ in 0..<steps {
        flashes += simulateStep(&map)
    }
    return flashes
}

fileprivate func simulateStep(_ map: inout Map) -> Int {
    for point in map { map[point] += 1 }
    recursiveFlashes(&map)
    return flash(&map)
}

fileprivate func recursiveFlashes(_ map: inout Map, flashed: Set<Point> = []) {
    let points = map.filter({ map[$0] > 9 && !flashed.contains($0) })
    if points.isEmpty { return }
    points.forEach({ map.adjecentIndexes(to: $0).forEach({ map[$0] += 1 }) })
    let flashed = Set(points).union(flashed)
    recursiveFlashes(&map, flashed: flashed)
}

fileprivate func flash(_ map: inout Map) -> Int {
    let points = map.filter({ map[$0] > 9 })
    points.forEach({ map[$0] = 0 })
    return points.count
}

fileprivate struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

fileprivate struct Map: Sequence, CustomStringConvertible {
    var description: String { return arr.map({ "\($0)" }).joined(separator: "\n") }
    private var arr: [[Int]]
    
    init(str: String) {
        arr = str.split(separator: "\n").map({ $0.compactMap({ Int(String($0)) }) })
    }
    
    func makeIterator() -> Array<Point>.Iterator {
        (0..<height).flatMap({ y in (0..<width).map({ x in Point(x, y) }) }).makeIterator()
    }
    
    func adjecentIndexes(to point: Point) -> [Point] {
        return [
            Point(point.x-1, point.y-1),
            Point(point.x, point.y-1),
            Point(point.x+1, point.y-1),
            Point(point.x-1, point.y),
            Point(point.x+1, point.y),
            Point(point.x-1, point.y+1),
            Point(point.x, point.y+1),
            Point(point.x+1, point.y+1),
        ].filter({ $0.x >= 0 && $0.x < width && $0.y >= 0 && $0.y < height })
    }
    
    subscript(_ point: Point) -> Int {
        get { return arr[point.y][point.x] }
        set { arr[point.y][point.x] = newValue }
    }
    
    var height: Int { arr.count }
    var width: Int { arr[0].count }
}
