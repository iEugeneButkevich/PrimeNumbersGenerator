import Foundation

protocol NumbersGeneratorProtocol {
    func generateNumbersFor(lowerBound: Int, upperBound: Int, threadsCount: Int, completion: @escaping ([Int]?) -> ())
}
