import Cocoa

class ColorProvider {

    let groundHue: CGFloat
    let waterHue: CGFloat
    
    init(groundHue: CGFloat, waterHue: CGFloat) {
        self.groundHue = groundHue
        self.waterHue = waterHue
    }
    
    func planetColor(for level: CGFloat) -> NSColor {
        return level < 0.5 ?
            waterColor(for: level) :
            groundColor(for: level)
    }
    
    private func groundColor(for level: CGFloat) -> NSColor {
        
        let hue: CGFloat = self.groundHue
        let saturation: CGFloat = level
        let brightness: CGFloat = 1.5 - level
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    private func waterColor(for level: CGFloat) -> NSColor {
        let hue: CGFloat = self.waterHue
        let saturation: CGFloat = 0.75
        let brightness: CGFloat = 0.75
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
