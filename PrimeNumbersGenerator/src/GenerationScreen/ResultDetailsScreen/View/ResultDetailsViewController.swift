import UIKit

protocol ResultDetailsViewProtocol: class {
    func showInfoFor(result: GenerationResult?)
}

class ResultDetailsViewController: UIViewController {
    
    var presenter: ResultDetailsPresenterProtocol!
    
    @IBOutlet private weak var generatedNumberTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = StringConstants.resultDetailsViewControllerTitle

        presenter.setResult()
    }
}

extension ResultDetailsViewController: ResultDetailsViewProtocol {
    func showInfoFor(result: GenerationResult?) {
        if let resultString = result?.generatedNumbers.map({ String($0) }).joined(separator: ",") {
            generatedNumberTextView.text = "[" + resultString + "]"
        } else {
            generatedNumberTextView.text = "[]"
        }
    }
}
