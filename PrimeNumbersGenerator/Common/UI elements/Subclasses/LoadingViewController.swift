import UIKit

class LoadingViewController: UIViewController {
    
    private var spinnerView = SpinnerView()
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.spinnerView.frame = self.view.frame
            
            self.view.addSubview(self.spinnerView)
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinnerView.removeFromSuperview()
        }
    }
}
