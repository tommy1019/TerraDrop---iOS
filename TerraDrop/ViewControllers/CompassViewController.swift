import UIKit
import CoreLocation

class CompassViewController: UIViewController, HeadingUpdateDelegate
{
    @IBOutlet weak var compassView: CompassView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        ConnectionController.instance.loadNearbyDrops()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        LocationController.instance.headingDelegate = self
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        LocationController.instance.headingDelegate = nil
    }

    @IBAction func onDropPress(_ sender: Any)
    {
        
    }
    
    func onHeadingUpdate(angle: Double)
    {
        compassView.headingAngle = -angle - .pi / 2
        compassView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
