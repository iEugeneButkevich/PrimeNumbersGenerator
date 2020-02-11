import Foundation
import RealmSwift

protocol DataManagerProtocol {
    func loadGenerationResults(completion:@escaping ([GenerationResult]?) -> Void)
    func loadGeneratedNumbersFor(upperBound: Int, completion:@escaping (_ generatedNumbers:[Int]?) -> Void)
    func save(result: GenerationResult)
    func update(result: GenerationResult, with elapsedTime: Double)
    func clearResults()
    
    func loadMaxUpperBound(completion:@escaping (_ upperBound:Int?) -> Void)
    func updateGeneratedNumbersResultWith(newGeneratedNumbers: [Int], maxUpperBound: Int)
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
    
    func loadGeneratedNumbersFor(upperBound: Int, completion:@escaping (_ generatedNumbers:[Int]?) -> Void) {
        concurrentQueue.async {
            let realm = try! Realm(configuration: .defaultConfiguration)
            
            if let generatedNumbers = realm.objects(GeneratedNumbersResult.self).first?.generatedNumbers.filter( { $0 < upperBound }) {
                let resultArray = Array(generatedNumbers)

                DispatchQueue.main.async {
                    completion(resultArray)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func loadMaxUpperBound(completion:@escaping (_ upperBound:Int?) -> Void) {
        let realm = try! Realm(configuration: .defaultConfiguration)
        
        if let maxUpperBoundNumber = realm.objects(GeneratedNumbersResult.self).first?.maxUpperBoundNumber {
            completion(maxUpperBoundNumber)
        } else {
            completion(nil)
        }
    }
    
    func updateGeneratedNumbersResultWith(newGeneratedNumbers: [Int], maxUpperBound: Int) {
        let realm = try! Realm(configuration: .defaultConfiguration)
        
        var generatedNumbersResult: GeneratedNumbersResult! = realm.objects(GeneratedNumbersResult.self).first
        
        if  generatedNumbersResult == nil {
            generatedNumbersResult = GeneratedNumbersResult()
        }

        try! realm.write {
            generatedNumbersResult.maxUpperBoundNumber = maxUpperBound
            
            for newGeneratedNumber in newGeneratedNumbers {
                generatedNumbersResult.generatedNumbers.append(newGeneratedNumber)
            }
            realm.add(generatedNumbersResult, update: .modified)
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
