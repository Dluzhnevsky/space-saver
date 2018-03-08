import Cocoa

class NormalGenerator {
   
    static func getNormalMap(map: NSImage) -> NSImage {
        let width = Int(map.size.width)
        let height = Int(map.size.height)
        
        let size = NSSize(width: width,
                          height: height)
        
        let image = NSImage(size: size)
        
        guard let tiffRepresentation = map.tiffRepresentation,
            let birmapRep = NSBitmapImageRep.init(data: tiffRepresentation) else {
                return image
        }
        
        image.lockFocusFlipped(true)
        
        for x in 0..<width {
            for y in 0..<height {
                let tl = NormalGenerator.getMapHeight(for: birmapRep, x: x - 1, y: y - 1)
                let tc = NormalGenerator.getMapHeight(for: birmapRep, x: x - 1, y: y)
                let tr = NormalGenerator.getMapHeight(for: birmapRep, x: x - 1, y: y + 1)
                let cr = NormalGenerator.getMapHeight(for: birmapRep, x: x, y: y + 1)
                let br = NormalGenerator.getMapHeight(for: birmapRep, x: x + 1, y: y + 1)
                let bc = NormalGenerator.getMapHeight(for: birmapRep, x: x + 1, y: y)
                let bl = NormalGenerator.getMapHeight(for: birmapRep, x: x + 1, y: y - 1)
                let cl = NormalGenerator.getMapHeight(for: birmapRep, x: x, y: y - 1)
    
                let dx: CGFloat = (tr + 2 * cr + br) - (tl + 2 * cl + bl)
                let dy: CGFloat = (bl + 2 * bc + br) - (tl + 2 * tc + tr)
                let dz: CGFloat = 0.5
                
                let factor = sqrt(dx * dx + dy * dy + dz * dz)
                let scale = 1.0 / factor
                
                let nx = dx * scale
                let ny = dy * scale
                let nz = dz * scale

                let color = NSColor(red: (ny + 1.0) / 2,
                                    green: (nx + 1.0) / 2,
                                    blue: (nz + 1.0) / 2,
                                    alpha: 1.0)
                
                color.setFill()
                
                NSBezierPath.fill(NSRect(x: x, y: y, width: 1, height: 1))
            }
        }
        
        image.unlockFocus()
        
        return image
    }
    
    static func getMapHeight(for bitmapRep: NSBitmapImageRep, x: Int, y: Int) -> CGFloat {
        let width = Int(bitmapRep.size.width)
        let height = Int(bitmapRep.size.height)
        var nx = x
        var ny = y
        
        if nx == -1 {
            nx = width - 1
        }
        
        if ny == -1 {
            ny = height - 1
        }
        
        if nx == width {
            nx = 0
        }
        
        if ny == height {
            ny = 0
        }
        
        guard let color = bitmapRep.colorAt(x: nx, y: ny) else {
            return 0
        }
        
        return color.greenComponent
    }
}
