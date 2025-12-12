import Foundation

let input = try String.init(
    contentsOfFile: "input11",
    encoding: .utf8
)

let graph: [String: [String]] = Dictionary(
    uniqueKeysWithValues:
        input
        .split(separator: "\n")
        .map({
            let splits = $0.split(separator: ": ")
            return (
                String(splits[0]),
                splits[1].split(separator: " ").map({ String($0) })
            )
        })
)

var cache: [String: Int] = [:]
func countPaths(from: String, to: String) -> Int {
    let cacheKey = [from, to].joined(separator: "->")
    if let cached = cache[cacheKey] {
        return cached
    }

    let result =
        if from == to {
            1
        } else if let next = graph[from] {
            next.map({ countPaths(from: $0, to: to) }).reduce(0, +)
        } else {
            0
        }
    cache[cacheKey] = result
    return result
}

print(countPaths(from: "you", to: "out"))
print(
    countPaths(from: "svr", to: "dac")
    * countPaths(from: "dac", to: "fft")
    * countPaths(from: "fft", to: "out")
    
    + countPaths(from: "svr", to: "fft")
    * countPaths(from: "fft", to: "dac")
    * countPaths(from: "dac", to: "out")

)
