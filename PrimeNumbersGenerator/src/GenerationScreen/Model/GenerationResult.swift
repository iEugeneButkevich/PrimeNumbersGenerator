import Foundation
import RealmSwift

class GenerationResult: Object {
    
    @objc dynamic var resultId = UUID().uuidString
    @objc dynamic var upperBoundNumber = Int()
    @objc dynamic var threadsCount = Int()
    @objc dynamic var startDate = Date()
    @objc dynamic var elapsedTime = Double()
    
    override static func primaryKey() -> String? {
        return #keyPath(GenerationResult.resultId)
    }
    
    func fillWith(upperBoundNumber: Int, threadsCount: Int, startDate: Date, elapsedTime: Double) {
        self.upperBoundNumber = upperBoundNumber
        self.threadsCount = threadsCount
        self.startDate = startDate
        self.elapsedTime = elapsedTime
    }
}
