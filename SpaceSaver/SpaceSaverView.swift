import SceneKit
import ScreenSaver

class SpaceSaverView: ScreenSaverView {
    
    var planetNode: SCNNode
    
    override init?(frame: NSRect, isPreview: Bool) {
        self.planetNode = PlanetNode()
        super.init(frame: frame, isPreview: isPreview)
        makeScene()
    }
    
    func makeScene() {
        let sceneView = SCNView(frame: self.frame)
        self.addSubview(sceneView)

        let scene = SCNScene()
        sceneView.scene = scene
        
        let skyView = SkyView(for: sceneView.frame, concentration: 500)
        scene.background.contents = skyView.image
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 5.0)
        
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0.0, y: 0.0, z: 10.5)
        
        let constraint = SCNLookAtConstraint(target: self.planetNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(self.planetNode)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
