import UIKit

protocol ResultDetailsViewProtocol: class {
    func showText(text: String)
    func showSpinner()
    func hideSpinner()
}

class ResultDetailsViewController: LoadingViewController {
    
    var presenter: ResultDetailsPresenterProtocol!
    
    @IBOutlet private weak var generatedNumberTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = StringConstants.resultDetailsViewControllerTitle

        presenter.setResult()
    }
}

extension ResultDetailsViewController: ResultDetailsViewProtocol {
    func showText(text: String) {
        generatedNumberTextView.text = text
    }
    
    func showSpinner() {
        showActivityIndicator()
    }
    
    func hideSpinner() {
        hideActivityIndicator()
    }
}
