//
//  09.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Foundation

extension Solvers {
    @objc static let day09a: Solve = { input in
        let map = Map(str: input)
        let hotspots = findHotspots(map)
        let risk = hotspots.map({ map[$0] + 1 }).reduce(0, +)
        return "\(risk)"
    }
    
    @objc static let day09b: Solve = { input in
        let map = Map(str: input)
        let basins = findBasins(map)
        let risk = basins.map({ $0.count }).reduce(1, *)
        return "\(risk)"
    }
}

fileprivate func findHotspots(_ map: Map) -> [Point] {
    var hotspots: [Point] = []
    for coord in map {
        let adjecent = map.adjecentIndexes(to: coord)
        if adjecent.contains(where: { map[$0] <= map[coord] }) {
            continue
        }
        hotspots.append(coord)
    }
    return hotspots
}

fileprivate func findBasins(_ map: Map) -> [[Point]] {
    var basins: [[Point]] = []
    var seen: Set<Point> = []
    for coord in map {
        basins.append(expandBasin(map, coord: coord, seen: &seen))
    }
    let orderdBasins = basins.sorted(by: { $0.count > $1.count })
    return Array(orderdBasins[0..<3])
}

fileprivate func expandBasin(_ map: Map, coord: Point, seen: inout Set<Point>) -> [Point] {
    if map[coord] == 9 { return [] }
    if seen.contains(coord) { return [] }
    seen.update(with: coord)
    let adjecent = map.adjecentIndexes(to: coord)
    return [coord] + adjecent.flatMap({ expandBasin(map, coord: $0, seen: &seen) })
}

fileprivate struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

fileprivate struct Map: Sequence {
    private var arr: [[Int]]
    
    init(str: String) {
        arr = str.split(separator: "\n").map({ $0.compactMap({ Int(String($0)) }) })
    }
    
    func makeIterator() -> Array<Point>.Iterator {
        (0..<height).flatMap({ y in (0..<width).map({ x in Point(x, y) }) }).makeIterator()
    }
    
    func adjecentIndexes(to point: Point) -> [Point] {
        return [
            Point(point.x-1, point.y),
            Point(point.x+1, point.y),
            Point(point.x, point.y-1),
            Point(point.x, point.y+1)
        ].filter({ $0.x >= 0 && $0.x < width && $0.y >= 0 && $0.y < height })
    }
    
    subscript(_ point: Point) -> Int {
        get { return arr[point.y][point.x] }
        set { arr[point.y][point.x] = newValue }
    }
    
    var height: Int { arr.count }
    var width: Int { arr[0].count }
}
