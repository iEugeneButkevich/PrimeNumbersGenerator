import Foundation
import RealmSwift

protocol DataManagerProtocol {
    func loadGenerationResults(completion:@escaping ([GenerationResult]?) -> Void)
    func loadGeneratedNumbersFor(upperBound: Int, completion:@escaping (_ upperBound:Int?, _ generatedNumbers:[Int]?) -> Void)
    func save(result: GenerationResult)
    func update(result: GenerationResult, with elapsedTime: Double)
    func clearResults()
}

class RealmDataManager: DataManagerProtocol {
    
    private let concurrentQueue = DispatchQueue(label: "by.EugeneButkevich.primeNumberGenerator.userInitiated", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem)
    
    init() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }
    
    func loadGenerationResults(completion:@escaping ([GenerationResult]?) -> Void) {
        concurrentQueue.async {
            let realm = try! Realm()
            
            let results = realm.objects(GenerationResult.self).sorted(byKeyPath: #keyPath(GenerationResult.startDate), ascending: false)
            
            let resultsRef = ThreadSafeReference(to: results)
            DispatchQueue.main.async {
                let realm = try! Realm()
                let resultsInMain = realm.resolve(resultsRef)
                
                if let resultsInMain = resultsInMain {
                    completion(Array(resultsInMain))
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func loadGeneratedNumbersFor(upperBound: Int, completion:@escaping (_ upperBound:Int?, _ generatedNumbers:[Int]?) -> Void) {
        concurrentQueue.async {
            let realm = try! Realm(configuration: .defaultConfiguration)
            
            if let result = realm.objects(GenerationResult.self).sorted(byKeyPath: #keyPath(GenerationResult.upperBoundNumber), ascending: false).first {
                
                let generatedNumbers = Array(result.generatedNumbers.filter( { $0 < upperBound }))
                
                let resultRef = ThreadSafeReference(to: result)

                DispatchQueue.main.async {
                    let realm = try! Realm()
                    
                    guard let resultInMain = realm.resolve(resultRef) else {
                        completion(nil, nil)
                        return
                    }
                    
                    completion(resultInMain.upperBoundNumber, generatedNumbers)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func save(result: GenerationResult) {
        let realm = try! Realm(configuration: .defaultConfiguration)
        
        try! realm.write {
            realm.add(result, update: .modified)
        }
    }
    
    func update(result: GenerationResult, with elapsedTime: Double) {
        let realm = try! Realm(configuration: .defaultConfiguration)

        try! realm.write {
            result.elapsedTime = elapsedTime
            realm.add(result, update: .modified)
        }
    }

    func clearResults() {
        let realm = try! Realm(configuration: .defaultConfiguration)

        try! realm.write {
            realm.deleteAll()
        }
    }
}
