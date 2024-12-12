import Foundation

/// https://medium.com/@pragmaticprogramming2022/unleashing-the-power-of-swift-the-ultimate-prime-number-detector-7e77c533ab61
func isPrime(_ num: Int) -> Bool {
    if num <= 1 { return false }
    if num <= 3 { return true}
    
    var div = 2
    while div * div <= num {
        if num % div == 0 { return false }
        div += 1
    }
    return true
}

func chunked(numbers: [Int], chunkSize: Int) -> [[Int]] {
    var chunks = [[Int]]()
    var currentChunk = [Int]()
    for (index, number) in numbers.enumerated() {
        currentChunk.append(number)
        if (index + 1) % chunkSize == 0 || index == numbers.count - 1 {
            chunks.append(currentChunk)
            currentChunk = []
        }
    }
    return chunks
}

func findPrimes(numbers: [Int]) {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = ProcessInfo.processInfo.activeProcessorCount
    var results = Array(repeating: false, count: numbers.count)
    
    var chunkSize = numbers.count / ProcessInfo.processInfo.activeProcessorCount
    if chunkSize <= 1 { chunkSize = 1 }
    let chunks = chunked(numbers: numbers, chunkSize: chunkSize)
    
    for (chunkIndex, chunk) in chunks.enumerated() {
        queue.addOperation {
            let startIndex = chunkIndex * chunkSize
            for (offset, number) in chunk.enumerated() {
                results[startIndex + offset] = isPrime(number)
            }
        }
    }
    
    queue.waitUntilAllOperationsAreFinished()
    
    var primes = [Int]()
    for (index, number) in numbers.enumerated() where results[index] {
        primes.append(number)
    }
    print("Prime numbers: \(primes)")
}
