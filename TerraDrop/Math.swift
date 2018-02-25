import Foundation
import CoreLocation

func toRadians(_ a : Double) -> Double { return a * .pi / 180.0 }
func toDegrees(_ a : Double) -> Double { return a * 180.0 / .pi }

func getAngle(start : (Double, Double), end : (Double, Double)) -> Double
{

    let a = (toRadians(start.0), toRadians(start.1))
    let b = (toRadians(end.0), toRadians(end.1))

    let dLon = b.1 - a.1

    let y = sin(dLon) * cos(b.0)
    let x = cos(a.0) * sin(b.0) - sin(a.0) * cos(b.0) * cos(dLon)
    return atan2(y, x)
}

func getDistance(a : (Double, Double), b : (Double, Double)) -> Double
{
    return CLLocation(latitude: a.0, longitude: a.1).distance(from: CLLocation(latitude: b.0, longitude: b.1))
}
