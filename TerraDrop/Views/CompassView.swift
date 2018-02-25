import UIKit

class CompassView : UIView
{
    var headingAngle = 0.0

    override func draw(_ rect: CGRect)
    {
        let length = Double(max(rect.width, rect.height))
        let radius = length * 0.90 / 2

        let center = length / 2

        let northRadius = radius * 0.5

        let directionPath = UIBezierPath()
        directionPath.lineWidth = 5
        directionPath.move(to: CGPoint(x: center + radius * cos(headingAngle), y: center + radius * sin(headingAngle)))
        directionPath.addLine(to: CGPoint(x: center + northRadius * cos(headingAngle), y: center + northRadius * sin(headingAngle)))
        #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).setStroke()
        directionPath.stroke()

        let offDirectionRadius = radius * 0.75

        for i in 1 ... 3
        {
            let curAngle = headingAngle + Double.pi * Double(i) / 2.0

            let directionPath = UIBezierPath()
            directionPath.lineWidth = 5
            directionPath.move(to: CGPoint(x: center + radius * cos(curAngle), y: center + radius * sin(curAngle)))
            directionPath.addLine(to: CGPoint(x: center + offDirectionRadius * cos(curAngle), y: center + offDirectionRadius * sin(curAngle)))
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
            directionPath.stroke()
        }

        let baseDropRadius = radius * 0.65

        if let curLocation = LocationController.instance.currentLocation?.coordinate
        {
            for drop in ConnectionController.instance.minimalDrops
            {
                let dropPath = UIBezierPath()
                let angle = getAngle(start: (curLocation.latitude, curLocation.longitude), end: (drop.latitude, drop.longitude)) + headingAngle

                let distance = getDistance(a: (curLocation.latitude, curLocation.longitude), b: (drop.latitude, drop.longitude))
                let dropRadius = baseDropRadius * (distance / 100)

                if dropRadius > radius
                {
                    continue
                }

                dropPath.lineWidth = 3
                dropPath.move(to: CGPoint(x: center + radius * cos(angle), y: center + radius * sin(angle)))
                dropPath.addLine(to: CGPoint(x: center + dropRadius * cos(angle), y: center + dropRadius * sin(angle)))

                #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).setStroke()
                dropPath.stroke()
            }
        }

        let safeRect = CGRect(x: length / 2 - radius, y: length / 2 - radius, width: radius * 2, height: radius * 2)
        let path = UIBezierPath(ovalIn: safeRect)
        path.lineWidth = 8
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
        path.stroke()
    }
}
