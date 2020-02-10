import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var upperBoundLabel: UILabel!
    @IBOutlet private weak var threadsCountLabel: UILabel!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!

    static func identifier() -> String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ResultTableViewCell.identifier(), bundle: nil)
    }
    
    class func initAsHeader() -> ResultTableViewCell {
        let instance = nib().instantiate(withOwner: nil, options: nil)[0] as! ResultTableViewCell
        instance.startDateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        instance.upperBoundLabel.font = UIFont.boldSystemFont(ofSize: 13)
        instance.threadsCountLabel.font = UIFont.boldSystemFont(ofSize: 13)
        instance.elapsedTimeLabel.font = UIFont.boldSystemFont(ofSize: 13)

        return instance
    }
    
    func updateWith(result: GenerationResult) {
        startDateLabel.text = Utils.stringFrom(date: result.startDate)
        upperBoundLabel.text = String(result.upperBoundNumber)
        threadsCountLabel.text = String(result.threadsCount)
        elapsedTimeLabel.text = String(format:"%.2f", result.elapsedTime)
    }
}
