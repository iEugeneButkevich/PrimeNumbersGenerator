import Foundation
import RealmSwift

class GeneratedNumbersResult: Object {
    
    @objc dynamic var resultId = UUID().uuidString
    @objc dynamic var maxUpperBoundNumber = Int()
    var generatedNumbers = List<Int>()
    
    override static func primaryKey() -> String? {
        return #keyPath(GeneratedNumbersResult.resultId)
    }
}
