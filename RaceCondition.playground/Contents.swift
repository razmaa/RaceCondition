import Foundation

final class Counter: @unchecked Sendable {
    private var value = 0
    private let queue = DispatchQueue(label: "Counter.serial")

    func increment() {
        queue.sync { value += 1 }
    }

    var currentValue: Int {
        queue.sync { value }
    }
}

func runCounterTask() {
    let counter = Counter()
    let group   = DispatchGroup()

    DispatchQueue.global().async(group: group) {
        for _ in 0..<1000 { counter.increment() }
    }

    DispatchQueue.global().async(group: group) {
        for _ in 0..<1000 { counter.increment() }
    }

    group.wait()
    print("Final counter value: \(counter.currentValue) (Expected: 2000)")
}

runCounterTask()

