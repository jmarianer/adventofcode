import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input6",
    encoding: .utf8
)

let split = input.split(separator: "\n").map({
    $0.split(whereSeparator: { $0.isWhitespace })
})
let numbers = split[0..<split.count - 1].map({$0.map({ Int($0)! })})
let operators = split[split.count - 1]

let totals = (0..<operators.count).map({ i in
    if operators[i] == "*" {
        return numbers.reduce(1, { $0 * $1[i] })
    } else {
        return numbers.reduce(0, { $0 + $1[i] })
    }
})

print(totals.reduce(0, +))


// Iterative approach to part II
let split1 = input.split(separator: "\n")
let lines = split1[0..<split.count - 1]
var total = 0
var problemNo = 0
var column = 0
while problemNo < operators.count {
    var currentTotal = operators[problemNo] == "*" ? 1 : 0
    while true {
        if column >= lines[0].count {
            break
        }
        var currentNumber = 0
        (0..<lines.count).forEach {
            let line = lines[$0]
            let digit = line[line.index(line.startIndex, offsetBy: column)]
            if digit != " " {
                currentNumber = currentNumber * 10 + Int(String(digit))!
            }
        }
        column += 1
        if currentNumber == 0 {
            break
        }
        if operators[problemNo] == "*" {
            currentTotal *= currentNumber
        } else {
            currentTotal += currentNumber
        }
    }
    problemNo += 1
    total += currentTotal
}
print(total)
