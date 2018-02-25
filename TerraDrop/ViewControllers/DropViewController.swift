import UIKit

class DropViewController : UIViewController
{
    var authorStr : String = ""
    var titleStr : String = ""
    var messageStr : String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var authorLabel: UILabel!

    @IBAction func onClosePress(_ sender: Any)
    {
        
        dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad()
    {
        titleLabel.text = ConnectionController.instance.curDrop?.title.replacingOccurrences(of: "_", with: " ")
        textArea.text = ConnectionController.instance.curDrop?.message.replacingOccurrences(of: "_", with: " ")
        authorLabel.text = ConnectionController.instance.curDrop?.author.replacingOccurrences(of: "_", with: " ")
    }
}
