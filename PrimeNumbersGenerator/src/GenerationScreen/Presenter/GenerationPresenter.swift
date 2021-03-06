import Foundation

protocol GenerationPresenterProtocol: class {
    init(view: GenerationViewProtocol, dataManager: DataManagerProtocol, numbersGenerator: NumbersGeneratorProtocol, router: RouterProtocol)
    var results: [GenerationResult]? { get set }
    func loadResults()
    func generateNumbersFor(upperBoundText: String?, threadsCountText: String?)
    func clearResults()
    func showDetails(result: GenerationResult)
}

class GenerationPresenter: GenerationPresenterProtocol {
    var results: [GenerationResult]?
    
    private weak var view: GenerationViewProtocol?
    private let dataManager: DataManagerProtocol!
    private let numbersGenerator: NumbersGeneratorProtocol!
    private var router: RouterProtocol?
    
    private let dataValidator = GenerationDataValidator()
    
    required init(view: GenerationViewProtocol, dataManager: DataManagerProtocol, numbersGenerator: NumbersGeneratorProtocol, router: RouterProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.numbersGenerator = numbersGenerator
        self.router = router
    }
    
    func loadResults() {
        view?.showSpinner()
        dataManager.loadGenerationResults(completion: { results in
            self.results = results
            self.view?.update()
        })
    }
    
    func generateNumbersFor(upperBoundText: String?, threadsCountText: String?) {
        
        let startDate = Date()
        let initialTime = DispatchTime.now()
        
        view?.endEditing()
        view?.showSpinner()
        
        if let errorText = dataValidator.validate(upperBoundNumberText: upperBoundText, threadsCountText: threadsCountText) {
            view?.showErrorWith(text: errorText)
        } else {
            let upperBound = Int(upperBoundText!)!
            let threadsCount = Int(threadsCountText!)!
            
            dataManager.loadMaxUpperBound { loadedMaxUpperBound in
                var lowerBoundForGeneration = 0
                if let loadedMaxUpperBound = loadedMaxUpperBound, loadedMaxUpperBound > 1 {
                    lowerBoundForGeneration = loadedMaxUpperBound
                }
                
                self.numbersGenerator.generateNumbersFor(lowerBound: lowerBoundForGeneration, upperBound: upperBound, threadsCount: threadsCount) { newNumbers in
                    if let newNumbers = newNumbers {
                        self.dataManager.updateGeneratedNumbersResultWith(newGeneratedNumbers: newNumbers, maxUpperBound: upperBound)
                    }
                    
                    let elapsedTimeBeforeSavingToDB = Double((DispatchTime.now().uptimeNanoseconds - initialTime.uptimeNanoseconds)) / 1_000_000 // в миллисекундах
                    
                    let generationResult = GenerationResult()
                    generationResult.fillWith(upperBoundNumber: upperBound, threadsCount: threadsCount, startDate: startDate, elapsedTime: elapsedTimeBeforeSavingToDB)
                    
                    self.dataManager.save(result: generationResult)
                    
                    self.loadResults()
                    
                    // пересчитываем суммарно затраченное время (с учетом времени сохранения в БД, перерисовки и т.д.) и перезаписываем результат
                    let totalElapsedTime = Double((DispatchTime.now().uptimeNanoseconds - initialTime.uptimeNanoseconds)) / 1_000_000 // в миллисекундах
                    
                    self.dataManager.update(result: generationResult, with: totalElapsedTime)
                    
                    self.loadResults()
                }
            }
        }
    }
    
    func clearResults() {
        view?.endEditing()
        view?.showSpinner()
        dataManager.clearResults()
        loadResults()
    }
    
    func showDetails(result: GenerationResult) {
        router?.showDetail(result: result)
    }
}
