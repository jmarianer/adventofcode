import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

func distance(_ p1: [Int], _ p2: [Int]) -> Float {
    let squares = zip(p1, p2).map({ Float(($0 - $1) * ($0 - $1)) })
    return sqrt(squares.reduce(0, +))
}

let input = try String.init(
    contentsOfFile: "input8",
    encoding: .utf8
)

let points = input.split(separator: "\n").map({
    $0.split(separator: ",").map({ Int($0)! })
})
let distances = (0..<points.count).flatMap({ p1 in
    ((p1 + 1)..<points.count).map({ p2 in
        (distance(points[p1], points[p2]), points[p1], points[p2])
    })
}).sorted(by: { a, b in a.0 < b.0 })

enum UF {
    case done(Int)
    case next([Int])
}

var unionFind: [[Int]: UF] = [:]
points.forEach({ unionFind[$0] = .done(1) })

func find(_ p: [Int]) -> [Int] {
    switch unionFind[p]! {
    case .done:
        return p
    case .next(let n):
        let ret = find(n)
        unionFind[p] = .next(ret)
        return ret
    }
}

func union(_ p1: [Int], _ p2: [Int]) {
    let p1 = find(p1)
    let p2 = find(p2)
    guard p1 != p2 else { return }
    switch unionFind[p1]! {
    case .done(let s):
        unionFind[p1] = .next(p2)
        inc(p2, count: s)
    case .next(let n):
        union(n, p2)
    }
}

func inc(_ p: [Int], count: Int) {
    switch unionFind[p]! {
    case .done(let s):
        unionFind[p] = .done(s + count)
    case .next(let n):
        inc(n, count: count)
    }
}

distances[0..<1000].forEach({ _, p1, p2 in
    union(p1, p2)
})
func circuitSizes() -> [Int] {
    unionFind.values.compactMap({
        switch $0 {
        case .done(let v): return v
        case .next: return nil
        }
    })
}
print(circuitSizes().sorted().reversed()[0..<3].reduce(1, *))

for i in 1000... {
    let (_, p1, p2) = distances[i]
    union(p1, p2)
    if circuitSizes().count == 1 {
        print(p1[0] * p2[0])
        break
    }
}
