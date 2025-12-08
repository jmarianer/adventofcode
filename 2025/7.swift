import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input7",
    encoding: .utf8
)

let lines = input.split(separator: "\n").map({ Array($0) })
let start = lines[0].firstIndex(of: "S")!

// Part I
var current = [ start: 1 ]
var totalSplits = 0
lines.dropFirst().forEach({ line in
    let next = current.flatMap({ column, multiplicity in
        if line[column] == "^" {
            totalSplits += 1
            return [(column - 1, multiplicity), (column + 1, multiplicity)]
        } else {
            return [(column, multiplicity)]
        }
    })
    current = Dictionary(next, uniquingKeysWith: +)
})

print(totalSplits)
print(current.values.reduce(0, +))

