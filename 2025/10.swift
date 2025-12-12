import Foundation

struct Machine {
    let lights: [Bool]
    let buttons: [[Int]]
    let joltages: [Int]
}

func createMachine(_ s: Substring) -> Machine {
    let parts = s.split(separator: " ")
    let lights = parts[0].dropFirst().dropLast().map({ $0 == "#" })
    let buttons = parts.dropFirst().dropLast().map({ buttonString in
        buttonString.dropFirst().dropLast().split(separator: ",").map({
            Int($0)!
        })
    })
    let joltages = parts.last!.dropFirst().dropLast().split(separator: ",").map(
        { Int($0)! })
    return Machine(lights: lights, buttons: buttons, joltages: joltages)
}

func generateBoolArrays(count: Int) -> [[Bool]] {
    if count == 0 {
        return [[]]
    }
    return generateBoolArrays(count: count - 1).flatMap {
        return [[true] + $0, [false] + $0]
    }
}

func calcButtons(_ m: Machine) -> Int {
    return generateBoolArrays(count: m.buttons.count)
        .compactMap({ boolArray in
            let lightsToggled = zip(m.buttons, boolArray).lazy
                .filter(\.1)
                .flatMap(\.0)
                .reduce(into: m.lights) { a, i in a[i] = !a[i] }
            return lightsToggled.allSatisfy({ !$0 })
                ? boolArray.count(where: { $0 })
                : nil
        }).min()!
}

func generatePartitions(total: Int, count: Int) -> [[Int]] {
    if count == 1 { return [[total]] }
    return (0...total).flatMap { first in
        generatePartitions(total: total - first, count: count - 1)
            .map { rest in
                [first] + rest
            }
    }
}

// Probably works but takes FOREVER
func calcJoltagesSlow(_ m: Machine) -> Int {
    let initialJoltage = Array(repeating: 0, count: m.joltages.count)
    for totalPresses in 0... {
        for presses in generatePartitions(
            total: totalPresses,
            count: m.buttons.count
        ) {
            let joltageIncs = zip(m.buttons, presses).flatMap({
                Array(repeating: $0.0, count: $0.1)
            }).flatMap({ $0 })
            let totalJoltage = joltageIncs.reduce(into: initialJoltage) {
                js,
                i in
                js[i] += 1
            }
            if totalJoltage == m.joltages {
                return totalPresses
            }
        }
    }
    return 0
}

// This one's even slower!
func calcJoltagesSlow2(_ m: Machine) -> Int {
    var presses = 0
    var achievable = Set([Array(repeating: 0, count: m.joltages.count)])
    var seen = achievable

    while true {
        presses += 1
        let newAchievable = Set(
            achievable
                .flatMap({ origin in
                    m.buttons.map({ button in
                        button.reduce(into: origin, { $0[$1] += 1 })
                    })
                })
                .filter({
                    zip($0, m.joltages).allSatisfy({ $0.0 <= $0.1 })
                })
        ).subtracting(seen)
        if newAchievable.contains(where: {
            zip($0, m.joltages).allSatisfy({ $0.0 == $0.1 })
        }) {
            return presses
        }
        achievable = newAchievable
        seen.formUnion(achievable)
    }
}

func calcJoltages(_ m: Machine) -> Int {
    print("Hello")
    struct Position {
        let joltages: [Int]
        let maxButtonPressed: Int
        let totalButtonsPressed: Int
    }

    let start = Position(
        joltages: Array(
            repeating: 0,
            count: m.joltages.count
        ),
        maxButtonPressed: 0,
        totalButtonsPressed: 0
    )
    var seen: Set<[Int]> = []
    var queue = [start]

    while true {
        let next = queue.remove(at: 0)
        if seen.contains(next.joltages) {
            continue
        }
        if next.joltages == m.joltages {
            return next.totalButtonsPressed
        }
        if !zip(next.joltages, m.joltages).allSatisfy({ $0.0 <= $0.1 }) {
            continue
        }

        seen.update(with: next.joltages)
        for nextButton in (next.maxButtonPressed..<m.buttons.count) {
            let newJoltages = m.buttons[nextButton].reduce(
                into: next.joltages,
                { $0[$1] += 1 }
            )
            queue.append(
                Position(
                    joltages: newJoltages,
                    maxButtonPressed: nextButton,
                    totalButtonsPressed: next.totalButtonsPressed + 1
                )
            )
        }
    }
}

let input = try String.init(
    contentsOfFile: "input10",
    encoding: .utf8
)

let machines = input.split(separator: "\n").map({ createMachine($0) })
print(machines.map(calcButtons).reduce(0, +))
//print(calcJoltagesSlow(machines[0]))
//print(calcJoltagesSlow2(machines[0]))
print(calcJoltages(machines[0]))
print(machines.map(calcJoltages).reduce(0, +))
