import Foundation
import RealmSwift

class GenerationResult: Object {
    
    @objc dynamic var resultId = UUID().uuidString
    @objc dynamic var upperBoundNumber = Int()
    @objc dynamic var threadsCount = Int()
    var generatedNumbers = List<Int>()
    @objc dynamic var startDate = Date()
    @objc dynamic var elapsedTime = Double()
    
    override static func primaryKey() -> String? {
        return #keyPath(GenerationResult.resultId)
    }
    
    func fillWith(upperBoundNumber: Int, threadsCount: Int, generatedNumbers: [Int], startDate: Date, elapsedTime: Double) {
        self.upperBoundNumber = upperBoundNumber
        self.threadsCount = threadsCount
        for generatedNumber in generatedNumbers {
            self.generatedNumbers.append(generatedNumber)
        }
        self.startDate = startDate
        self.elapsedTime = elapsedTime
    }
}
