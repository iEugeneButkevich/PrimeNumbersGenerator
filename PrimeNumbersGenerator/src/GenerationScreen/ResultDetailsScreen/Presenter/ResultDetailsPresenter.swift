import Foundation

protocol ResultDetailsPresenterProtocol: class {
    init(view: ResultDetailsViewProtocol, dataManager: DataManagerProtocol, result: GenerationResult)
    func setResult()
}

class ResultDetailsPresenter: ResultDetailsPresenterProtocol {
    
    private weak var view: ResultDetailsViewProtocol?
    private var result: GenerationResult!
    
    private let dataManager: DataManagerProtocol!

    required init(view: ResultDetailsViewProtocol, dataManager: DataManagerProtocol, result: GenerationResult) {
        self.view = view
        self.result = result
        self.dataManager = dataManager
    }
    
    func setResult() {
        view?.showSpinner()
        dataManager.loadGeneratedNumbersFor(upperBound: result.upperBoundNumber) { generatedNumbers in
            var text: String!
            
            if let resultString = generatedNumbers?.map({ String($0) }).joined(separator: ",") {
                text = "[" + resultString + "]"
            } else {
                text = "[]"
            }
            
            self.view?.hideSpinner()
            self.view?.showText(text: text)
        }
    }
}
