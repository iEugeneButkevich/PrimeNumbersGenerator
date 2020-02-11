import UIKit

protocol GenerationViewProtocol: class {
    func update()
    func showErrorWith(text: String)
    func endEditing()
    func showSpinner()
    func hideSpinner()
}

class GenerationViewController: LoadingViewController {
    
    var presenter: GenerationPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upperNumberTextField: UITextField!
    @IBOutlet weak var threadsCountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = StringConstants.generationViewControllerTitle
        
        tableView.register(ResultTableViewCell.nib(), forCellReuseIdentifier: ResultTableViewCell.identifier())
        
        tableView.tableHeaderView = ResultTableViewCell.initAsHeader()
        
        presenter.loadResults()

    }
    
    @IBAction func generateAction(_ sender: UIButton) {
        presenter.generateNumbersFor(upperBoundText: upperNumberTextField.text, threadsCountText: threadsCountTextField.text)
    }
    
    @IBAction func clearResultsAction(_ sender: UIButton) {
        presenter.clearResults()
    }
}

extension GenerationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier(), for: indexPath) as! ResultTableViewCell
        
        if let result = presenter.results?[indexPath.row] {
            cell.updateWith(result: result)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension GenerationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = presenter.results?[indexPath.row] else { return }
        
        presenter.showDetails(result: result)
    }
}

extension GenerationViewController: GenerationViewProtocol {
    func update() {
        hideActivityIndicator()
        tableView.reloadData()
    }
    
    func showErrorWith(text: String) {
        hideActivityIndicator()
        showAlert(withTitle: nil, message: text)
    }
    
    func endEditing() {
        view.endEditing(true)
        upperNumberTextField.text?.removeAll()
        threadsCountTextField.text?.removeAll()
    }
    
    func showSpinner() {
        showActivityIndicator()
    }
    
    func hideSpinner() {
        hideActivityIndicator()
    }
}
