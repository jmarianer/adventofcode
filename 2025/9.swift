import Foundation

func rectArea(_ p1: [Int], _ p2: [Int]) -> Int {
    return (abs(p1[0] - p2[0]) + 1) * (abs(p1[1] - p2[1]) + 1)
}

let input = try String.init(
    contentsOfFile: "input9",
    encoding: .utf8
)

let points = input.split(separator: "\n").map({
    $0.split(separator: ",").map({ Int($0)! })
})

print(points.flatMap({ p1 in
    points.map({p2 in
        rectArea(p1, p2)
    })
}).max()!)
