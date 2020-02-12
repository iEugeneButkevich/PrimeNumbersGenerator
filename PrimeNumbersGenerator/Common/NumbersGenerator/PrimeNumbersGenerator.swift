import Foundation

class PrimeNumbersGenerator: NumbersGeneratorProtocol {
    
    func generateNumbersFor(lowerBound: Int, upperBound: Int, threadsCount: Int, completion: @escaping ([Int]?) -> ()) {
        
        if lowerBound >= upperBound {
            completion(nil)
            return
        }
        
        if upperBound < 3 {
            completion([])
            return
        }
        
        Thread.detachNewThread {
            var resultPrimes = [Int]()
            
            let sqrtOfUpperBound = Int(sqrt(Double(upperBound)))

            // Находим простые числа до корня из UpperBound
            let sqrtPrimes = self.primeNumbersFor(n: sqrtOfUpperBound)
            
            if threadsCount > 1 && threadsCount < upperBound - lowerBound {
                let numbersCountInRangeForGeneration = (upperBound - lowerBound) / (threadsCount - 1)
                
                let lock = NSLock()
                let dispatchGroup = DispatchGroup()
                
                var threadsPrimeNumbers = [[Int]]()
                
                for i in 1...threadsCount - 1 {
                    dispatchGroup.enter()
                    
                    let lowerBoundForThread = lowerBound + (i - 1)*numbersCountInRangeForGeneration
                    let upperBoundForThread = i == threadsCount - 1 ? upperBound - 1 : lowerBoundForThread + numbersCountInRangeForGeneration - 1
                    
                    Thread.detachNewThread {
                        let threadPrimeNumbers = self.primeNumbers(from: lowerBoundForThread, to: upperBoundForThread, sqrtPrimes: sqrtPrimes)
                        
                        lock.lock()
                        if !threadPrimeNumbers.isEmpty {
                            threadsPrimeNumbers.append(threadPrimeNumbers)
                        }
                        lock.unlock()
                        
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.wait()
                
                threadsPrimeNumbers = threadsPrimeNumbers.sorted { $0[0] < $1[0] }
                for primes in threadsPrimeNumbers {
                    resultPrimes = resultPrimes + primes
                }
                
                DispatchQueue.main.async {
                    completion(resultPrimes)
                }
            } else {
                resultPrimes = self.primeNumbers(from: lowerBound, to: upperBound - 1, sqrtPrimes: sqrtPrimes)
                DispatchQueue.main.async {
                    completion(resultPrimes)
                }
            }
        }
    }
    
    private func primeNumbersFor(n: Int) -> [Int] {
        var data = Array(repeating: true, count: n + 1)
        data[0] = false
        data[1] = false
        
        let sqrtN = Int(sqrt(Double(n)))
        
        if sqrtN > 1 {
            for currentPrime in (2...sqrtN) {
                if !data[currentPrime] {
                    continue
                }
                
                for multiple in stride(from:currentPrime.powerOf2(), through: n, by: currentPrime) {
                    data[multiple] = false
                }
            }
        } else if n < 2 {
            return []
        }
        
        let primes = (2...n).filter{data[$0]}
        
        return primes
    }
    
    private func primeNumbers(from lowerBound: Int, to upperBound: Int, sqrtPrimes:[Int]) -> [Int] {
        var secondarySieve = Array(repeating: true, count: upperBound - lowerBound + 1)
        
        if lowerBound == 0 {
            secondarySieve[0] = false
            secondarySieve[1] = false
        }
        
        for currentPrime in sqrtPrimes {
            var startNumber = 0
            if lowerBound <= currentPrime {
                startNumber = 2 * currentPrime - lowerBound
            } else {
                let h = lowerBound % currentPrime
                startNumber = h == 0 ? 0 : currentPrime - h
            }
            
            for multiple in stride(from:startNumber, through: secondarySieve.count - 1, by: currentPrime) {
                secondarySieve[multiple] = false
            }
        }
        
        let primes = (lowerBound...upperBound).filter{secondarySieve[$0 - lowerBound]}
        
        return primes
    }
}

extension Int {
    func powerOf2() -> Int {
        return self * self
    }
}
