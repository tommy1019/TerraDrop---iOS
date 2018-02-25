import UIKit

class TabViewController : UITabBarController
{
    weak static var instance : TabViewController!

    override func viewDidLoad()
    {
        selectedIndex = 1
        TabViewController.instance = self
    }
}
