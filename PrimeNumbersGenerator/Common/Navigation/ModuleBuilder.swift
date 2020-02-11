import UIKit

protocol ModuleBuilderProtocol {
    func createInitialModule(router: RouterProtocol) -> UIViewController
    func createResultDetailsModule(result: GenerationResult) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    func createInitialModule(router: RouterProtocol) -> UIViewController {
        let view = GenerationViewController()
        let presenter = GenerationPresenter(view: view, dataManager: RealmDataManager(), numbersGenerator: PrimeNumbersGenerator(), router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createResultDetailsModule(result: GenerationResult) -> UIViewController {
        let view = ResultDetailsViewController()
        let presenter = ResultDetailsPresenter(view: view, dataManager: RealmDataManager(), result: result)
        view.presenter = presenter
        
        return view
    }
}
