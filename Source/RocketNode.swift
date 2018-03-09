import Cocoa
import SceneKit

class RocketNode: SCNNode {
    
    let firstColor: NSColor
    let secondColor: NSColor
    
    override init() {
        firstColor = RocketNode.randomColor
        secondColor = RocketNode.randomColor
        
        super.init()
        
        let top = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        top.firstMaterial?.diffuse.contents = self.secondColor
        let topNode = SCNNode(geometry: top)
        topNode.position.y += 1.5
        self.addChildNode(topNode)
        
        let body = SCNBox(width: 1.0, height: 3.0, length: 1.0, chamferRadius: 0.0)
        body.firstMaterial?.diffuse.contents = self.firstColor
        let bodyNode = SCNNode(geometry: body)
        self.addChildNode(bodyNode)
        
        let bottom = SCNPyramid(width: 2.0, height: 2.0, length: 2.0)
        bottom.firstMaterial?.diffuse.contents = self.secondColor
        let bottomNode = SCNNode(geometry: bottom)
        bottomNode.position.y -= 2.0
        self.addChildNode(bottomNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var randomColor: NSColor {
        let hue = CGFloat(arc4random())/CGFloat(UINT32_MAX)
        let saturation = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let brightness = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
