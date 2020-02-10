import Foundation

class GenerationDataValidator {
    func validate(upperBoundNumberText: String?, threadsCountText: String?) -> String? {
        
        guard let upperBoundNumberText = upperBoundNumberText, !upperBoundNumberText.isEmpty else {
            return StringConstants.upperBoundTextIsEmpty
        }
        
        guard let upperBoundNumber = Int(upperBoundNumberText) else {
            return StringConstants.upperBoundTextIsNotNumber
        }
        
        if upperBoundNumber < 0 {
            return StringConstants.incorrectUpperBound
        }
        
        guard let threadsCountText = threadsCountText, !threadsCountText.isEmpty else {
            return StringConstants.threadsCountTextIsEmpty
        }
        
        guard let threadsCount = Int(threadsCountText) else {
            return StringConstants.threadsCountTextIsNotNumber
        }
        
        if threadsCount < 1 || threadsCount > 10 {
            return StringConstants.incorrectThreadsCount
        }
        
        return nil
    }
}
