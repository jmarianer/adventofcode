import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input5",
    encoding: .utf8
)

let splits = input.split(separator: "\n\n")
let ranges = splits[0]
let ingredients = splits[1].split(separator: "\n").map({ Int($0)! })

let freshRanges = ranges.split(separator: "\n").map({
    let splits = $0.split(separator: "-").map({ Int($0)! })
    return (splits[0], splits[1])
})

print(
    ingredients.count(where: { i in
        freshRanges.contains(where: { (from, to) in
            from <= i && i <= to
        })
    })
)

let allFresh = freshRanges.flatMap({ (from, to) in
    [(from, 1), (to + 1, -1)]
}).sorted(by: { (arg0, arg1) in
    let (point2, _) = arg1
    let (point1, _) = arg0
    return point1 < point2
})

var mostRecentOn = -1
var totalFresh = 0
var depth = 0
for (point, dDepth) in allFresh {
    depth += dDepth
    if depth == 1 && dDepth == 1 {
        mostRecentOn = point
    }
    if depth == 0 && dDepth == -1 {
        totalFresh += point - mostRecentOn
    }
}
print(totalFresh)
