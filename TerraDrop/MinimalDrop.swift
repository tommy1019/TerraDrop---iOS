import Foundation

class MinimalDrop
{
    let dropId : Int
    let latitude : Double
    let longitude : Double

    init(id : Int, latitude : Double, longitude : Double)
    {
        self.dropId = id
        self.latitude = latitude
        self.longitude = longitude
    }
}
