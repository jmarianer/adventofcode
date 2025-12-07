import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input4",
    encoding: .utf8
)
let lines = input.split(separator: "\n").map({".\($0).".split(separator: "")})
let border = String(repeating: ".", count: lines[0].count).split(separator: "")


var linesWithBorder = [border] + lines + [border]
var grandTotal = 0
while true {
    var total = 0
    var toDelete: [(Int, Int)] = []
    (0..<linesWithBorder.count).forEach({ i in
        (0..<linesWithBorder[i].count).forEach({ j in
            if linesWithBorder[i][j] == "." {
                return
            }
            var totalNeighbors = -1  // Because we're going to count ourselves
            (-1...1).forEach({ di in
                (-1...1).forEach({ dj in
                    if linesWithBorder[i + di][j + dj] == "@" {
                        totalNeighbors += 1
                    }
                })
            })
            if totalNeighbors < 4 {
                total += 1
                toDelete.append((i, j))
            }
        })
    })
    print(total)
    toDelete.forEach({(i, j) in linesWithBorder[i][j] = "."})
    grandTotal += total
    if total == 0 {
        break
    }
}
print(grandTotal)
