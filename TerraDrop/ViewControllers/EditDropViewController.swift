import UIKit
import CoreLocation

class EditDropViewController : UIViewController, LocationUpdateDelegate
{
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var messageInput: UITextView!

    

    override func viewDidLoad()
    {

    }

    override func viewDidAppear(_ animated: Bool)
    {
        LocationController.instance.loactionDelegate = self

        dropButton.isEnabled = LocationController.instance.accurateData
        dataLabel.isHidden = LocationController.instance.accurateData
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        LocationController.instance.loactionDelegate = nil
    }

    func onLocationUpdate(location: CLLocation)
    {
        dropButton.isEnabled = LocationController.instance.accurateData
        dataLabel.isHidden = LocationController.instance.accurateData
    }
    
    @IBAction func onCancel(_ sender: Any)
    {
        dismiss(animated: true, completion: {})
    }
    @IBAction func onDrop(_ sender: Any)
    {
        ConnectionController.instance.drop(title: titleInput.text ?? "", dropText: messageInput.text)
        {
            self.dismiss(animated: true, completion: {})
        }
    }
}
