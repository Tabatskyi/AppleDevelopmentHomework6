import Foundation

func withdrawsWithoutSync(account: BankAccount) {
    let queue = DispatchQueue(label: "withdrawalAsync", attributes: .concurrent)
    for _ in 0..<10 {
        queue.async {
            _ = account.withdraw(amount: 200)
        }
    }
    print("Final balance after race condition: \(account.balance)")
}
/// https://www.avanderlee.com/swift/concurrent-serial-dispatchqueue/
func withdrawsWithSync(account: BankAccount) {
    let queue = DispatchQueue(label: "withdrawalSync", attributes: .concurrent)
    for _ in 0..<10 {
        queue.sync {
            _ = account.withdraw(amount: 200)
        }
    }
    print("Final balance after thread-safe withdrawals: \(account.balance)")
}
