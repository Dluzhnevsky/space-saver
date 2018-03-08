import Cocoa
import SceneKit

class PlanetNode: SCNNode {
    
    static let mapWidth = 512
    static let mapHeight = 256
    
    override init() {
        super.init()
        self.geometry = planetGeometry
        startRotation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRotation() {
        let rotationAngle = 2 * CGFloat.pi
        let aroundVector = SCNVector3(x: 0, y: 1, z: 0)
        let rotationTime = TimeInterval(randomCGFloat * 40 + 10)
        
        let rotationAction = SCNAction.rotate(by: rotationAngle,
                                      around: aroundVector,
                                      duration: rotationTime)
        
        let foreverRotationAction = SCNAction.repeatForever(rotationAction)
        self.runAction(foreverRotationAction)
    }
    
    var earthMaterial: SCNMaterial {
        let map = MapGenerator(width: PlanetNode.mapWidth, height: PlanetNode.mapHeight)
        let mapImage = map.image
        let earthBump = NormalGenerator.getNormalMap(map: map.image)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = mapImage
        
        sphereMaterial.normal.contents = earthBump
        
        return sphereMaterial
    }
    
    var planetGeometry: SCNGeometry {
        let planetRadius = randomCGFloat + 0.75
        let planetGeometry = SCNSphere(radius: planetRadius)
        planetGeometry.materials = [earthMaterial]
        return planetGeometry
    }
    
    var randomCGFloat: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
}
