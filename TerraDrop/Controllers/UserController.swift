import Foundation

class UserController
{
    static let USERNAME_SAVE = "USERNAME"

    static let instance = UserController()

    var username : String?
    var displayName : String?

    func load()
    {
        username = UserDefaults.standard.object(forKey: UserController.USERNAME_SAVE) as? String

        
    }
}
