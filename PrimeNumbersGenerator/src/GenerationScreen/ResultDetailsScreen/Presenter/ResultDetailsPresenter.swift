import Foundation

protocol ResultDetailsPresenterProtocol: class {
    init(view: ResultDetailsViewProtocol, result: GenerationResult?)
    func setResult()
}

class ResultDetailsPresenter: ResultDetailsPresenterProtocol {
    
    private weak var view: ResultDetailsViewProtocol?
    private var result: GenerationResult?
    
    required init(view: ResultDetailsViewProtocol, result: GenerationResult?) {
        self.view = view
        self.result = result
    }
    
    func setResult() {
        self.view?.showInfoFor(result: result)
    }
}
