import Cocoa

class SkyView {
    
    static let starSize: CGFloat = 4
    
    let concentration: Int
    let image: NSImage
    
    init(for frame: NSRect, concentration: Int) {
        self.concentration = concentration

        self.image = NSImage(size: frame.size)
        
        self.image.lockFocus()
        NSColor.black.setFill()
        NSBezierPath.fill(frame)
        
        NSColor.white.set()
        
        for _ in 0..<self.concentration {
            let point = randomPoint
            let size = randomSize
            NSBezierPath.init(ovalIn: NSRect(x: point.x, y: point.y, width: size, height: size)).fill()
        }
        
        self.image.unlockFocus()
    }
    
    var randomCGFloat: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
    
    var randomPoint: NSPoint {
        let x = self.image.size.width * randomCGFloat
        let y = self.image.size.height * randomCGFloat
        return NSPoint(x: x, y: y)
    }
    
    var randomSize: CGFloat {
        return randomCGFloat * SkyView.starSize
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
