import Foundation
import UIKit

class ConnectionController
{
    static let BASE_URL = "http://76.183.125.29:8080"

    static let NEARBY_DROPS_URL = "getDrops"
    static let ADD_DROP_URL = "postDrop"
    static let GET_DROP_URL = "getDisplayDrop"

    static let instance = ConnectionController()

    var minimalDrops = [MinimalDrop]()

    var curDrop : DetailDrop?

    func drop(title : String, dropText : String, onSuccess : @escaping (() -> Void))
    {
        var request = URLRequest(url: URL(string: "\(ConnectionController.BASE_URL)/\(ConnectionController.ADD_DROP_URL)")!)

        request.httpMethod = "POST"
        let postString = "latitude=\(LocationController.instance.currentLocation!.coordinate.latitude)&longitude=\(LocationController.instance.currentLocation!.coordinate.longitude)&userID=1&title=\(title.replacingOccurrences(of: " ", with: "_"))&message=\(dropText.replacingOccurrences(of: " ", with: "_"))"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                print("Error creating drop")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                print("Status code error: \(httpStatus.statusCode)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            if responseString == "TRUE"
            {
                DispatchQueue.main.async
                {
                    onSuccess()
                }
            }
        }
        task.resume()
    }

    func loadNearbyDrops()
    {
        let url = URL(string: "\(ConnectionController.BASE_URL)/\(ConnectionController.NEARBY_DROPS_URL)")

        let task = URLSession.shared.dataTask(with: url!)
        {
            (data, response, error) in

            if ((error) != nil)
            {
                //TODO: Notify the user of error
                return
            }

            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String : Any]]

                self.minimalDrops.removeAll()

                for m in json
                {
                    let id = m["id"]! as! Int
                    let latitude = m["latitude"]! as! Double
                    let longitude = m["longitude"]! as! Double

                    let drop = MinimalDrop(id: id, latitude: latitude, longitude: longitude)

                    self.minimalDrops.append(drop)
                }

            }
            catch
            {
                print(error)
            }
        }

        task.resume()
    }

    func displayDrop(dropId : Int)
    {
        let url = URL(string: "\(ConnectionController.BASE_URL)/\(ConnectionController.GET_DROP_URL)?dropID=\(dropId)")

        let task = URLSession.shared.dataTask(with: url!)
        {
            (data, response, error) in

            if ((error) != nil)
            {
                return
            }

            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]

                self.curDrop = DetailDrop()

                self.curDrop!.author = json["displayName"]! as! String
                self.curDrop!.title = json["title"]! as! String
                self.curDrop!.message = json["message"]! as! String

                DispatchQueue.main.async
                {
                    TabViewController.instance.performSegue(withIdentifier: "showDrop", sender: json)
                }
             }
            catch
            {
                print(error)
            }
        }

        task.resume()
    }
}
