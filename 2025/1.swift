import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input1",
    encoding: .utf8
)

let lines = input.split(separator: "\n")
let positions = lines.reductions(
    50,
    {
        let dir = $1.first!
        let count = Int($1.dropFirst())!
        return if dir == "L" {
            $0 - count
        } else {
            $0 + count
        }
    }
)

print(positions.count(where: { $0 % 100 == 0 }))
let allPositions = zip(positions, positions.dropFirst()).flatMap({
    let (from, to) = $0
    return if from < to {
        Array(from...to - 1)
    } else {
        Array((to + 1...from).reversed())
    }
})
print(allPositions.count(where: { $0 % 100 == 0 }))
