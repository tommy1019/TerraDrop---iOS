import UIKit

class SplashViewController : UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        UserController.instance.load()

        self.performSegue(withIdentifier: "loggedIn", sender: self)
    }
}
