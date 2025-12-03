import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input3",
    encoding: .utf8
)

let banks =
    input
    .split(separator: "\n")
    .map({ $0.map({ Int("\($0)")! }) })

let joltages = banks.map({
    let tens = $0.dropLast().max()!
    let idx = $0.firstIndex(of: tens)!
    let ones = $0.dropFirst(idx + 1).max()!
    return tens * 10 + ones
})
print(joltages.reduce(0, +))

let joltages2 = banks.map({ bank in
    (0..<12).reversed().reduce(
        (0, 0),
        { prev, i in
            let (sum, idx) = prev
            let newDigit = bank.dropLast(i).dropFirst(idx).max()!
            let newIdx = bank.dropFirst(idx).firstIndex(of: newDigit)!
            return (sum * 10 + newDigit, newIdx + 1)
        }
    )
})
print(joltages2.map({$0.0}).reduce(0, +))
