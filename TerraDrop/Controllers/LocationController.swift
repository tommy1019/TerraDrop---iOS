import CoreLocation

protocol HeadingUpdateDelegate
{
    func onHeadingUpdate(angle : Double)
}

protocol LocationUpdateDelegate
{
    func onLocationUpdate(location : CLLocation)
}

class LocationController : NSObject, CLLocationManagerDelegate
{
    static let PICKUP_DISTANCE = 20

    static let instance = LocationController()

    let locationManager : CLLocationManager

    let headingAvailable : Bool
    var locationAvailable : Bool

    var currentHeading : CLHeading?
    var currentLocation : CLLocation?

    var headingDelegate : HeadingUpdateDelegate?
    var loactionDelegate : LocationUpdateDelegate?

    var accurateData = false

    override init()
    {
        locationManager = CLLocationManager()
        headingAvailable = CLLocationManager.headingAvailable()
        locationAvailable = CLLocationManager.locationServicesEnabled()

        super.init()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        locationManager.startUpdatingLocation()

        if headingAvailable
        {
            locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        currentHeading = newHeading

        if let delegate = headingDelegate
        {
            delegate.onHeadingUpdate(angle: toRadians(newHeading.magneticHeading))
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations.first
        accurateData = currentLocation?.horizontalAccuracy ?? 16.0 < 15.0

        if let delegate = loactionDelegate
        {
            delegate.onLocationUpdate(location: currentLocation!)
        }

        var toRemove = -1

        for i in 0 ..< ConnectionController.instance.minimalDrops.count
        {
            let mDrop = ConnectionController.instance.minimalDrops[i]
            if Int(getDistance(a: ((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!), b: (mDrop.latitude, mDrop.longitude))) < LocationController.PICKUP_DISTANCE
            {
                ConnectionController.instance.displayDrop(dropId: mDrop.dropId)
                toRemove = i
                break
            }
        }

        if toRemove != -1
        {
            ConnectionController.instance.minimalDrops.remove(at: toRemove)
        }
    }
}
