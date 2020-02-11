import Foundation

import UIKit

protocol BaseRouter {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
}

protocol RouterProtocol: BaseRouter {
    func setInitialViewController()
    func showDetail(result: GenerationResult)
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    
    var moduleBuilder: ModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func setInitialViewController() {
        guard let navigationController = navigationController,
            let initialViewController = moduleBuilder?.createInitialModule(router: self) else { return }
        
        navigationController.viewControllers = [initialViewController]
    }
    
    func showDetail(result: GenerationResult) {
        guard let navigationController = navigationController,
            let resultDetailsViewController = moduleBuilder?.createResultDetailsModule(result: result) else { return }
        
        navigationController.pushViewController(resultDetailsViewController, animated: true)
    }
}
