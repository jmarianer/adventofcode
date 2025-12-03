import Algorithms  // apple/swift-algorithms ~> 1.0
import Foundation

let input = try String.init(
    contentsOfFile: "input2",
    encoding: .utf8
)
let ids = input.trimmingCharacters(in: .whitespacesAndNewlines)
    .split(separator: ",")
    .flatMap({
        let foo = $0.split(separator: "-", maxSplits: 2)
        return Int(foo[0])!...Int(foo[1])!
    })


print(
    ids.filter({
        let s = String($0)
        if s.count % 2 != 0 { return false }
        let midIndex = s.index(s.startIndex, offsetBy: s.count / 2)
        let firstHalf = s[..<midIndex]
        let secondHalf = s[midIndex...]
        return firstHalf == secondHalf
    })
    .reduce(0, +)
)

print(
    ids.filter({
        let s = String($0)
        if s.count < 2 { return false }
        Outer: for i in 2...s.count {
            if s.count % i != 0 { continue }
            var partIndex = s.index(s.startIndex, offsetBy: s.count / i)
            let firstPart = s[..<partIndex]
            for _ in 1..<i {
                let nextPartIndex = s.index(partIndex, offsetBy: s.count / i)
                let nextPart = s[partIndex..<nextPartIndex]
                if nextPart != firstPart {
                    continue Outer
                }
                partIndex = nextPartIndex
            }
            return true
        }
        return false
    })
    .reduce(0, +)
)
