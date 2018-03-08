import Cocoa

class MapGenerator {

    static let tileSize = 4
    
    var finalNoise = [[CGFloat]]()
    let width: Int
    let height: Int
    
    init(width: Int, height: Int) {
        let tileSize = MapGenerator.tileSize
        self.width = width / tileSize
        self.height = height / tileSize
        let whiteNoise = generateWhiteNoise()
        finalNoise = generatePerlinNoise(baseNoise: whiteNoise, octaveCount: 7)
    }
    
    func makeIsland() {
        for i in 0..<self.width {
            for j in 0..<self.height {
                if !isIsland(x: i, y: j) {
                    finalNoise[j][i] = 0.1
                }
            }
        }
    }
    
    func isIsland(x: Int, y: Int) -> Bool {
        let width = CGFloat(self.width)
        let height = CGFloat(self.height)
        let dx: CGFloat = 0.005
        let dy: CGFloat = 0.0
        let a = width / 2 - width * dx
        let b = height / 2 - height * dy
        let cx = CGFloat(x) - width / 2
        let cy = CGFloat(y) - height / 2
        let ca = (cx * cx) / (a * a)
        let cb = (cy * cy) / (b * b)
        return ca + cb <= 1
    }
    
    func interpolate(x0: CGFloat, x1: CGFloat, alpha: CGFloat) -> CGFloat {
        return x0 * (1 - alpha) + alpha * x1
    }
    
    func generateWhiteNoise() -> [[CGFloat]] {
        var noise = Array(repeating: Array(repeating: CGFloat(0.0), count: self.width), count: self.height)
        for i in 0..<self.width {
            for j in 0..<self.height {
                noise[j][i] = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
            }
        }
        return noise
    }
    
    func generateSmoothNoise(baseNoise: [[CGFloat]], octave: Int) -> [[CGFloat]] {
        let width = self.width
        let height = self.height
        
        var smoothNoise = Array(repeating: Array(repeating: CGFloat(0.0), count: width), count: height)
        
        let samplePeriod = Int(pow(CGFloat(2), CGFloat(octave)))
        let sampleFrequency = 1.0 / CGFloat(samplePeriod)
        
        for i in 0..<width {
            let i0 = (i / samplePeriod) * samplePeriod
            let i1 = (i0 + samplePeriod) % width
            let horizontalBlend = CGFloat(i - i0) * sampleFrequency
            
            for j in 0..<height {
                let j0 = (j / samplePeriod) * samplePeriod
                let j1 = (j0 + samplePeriod) % height
                let verticalBlend = CGFloat(j - j0) * sampleFrequency
                
                let top = interpolate(x0: baseNoise[j0][i0],
                                      x1: baseNoise[j0][i1], alpha: horizontalBlend)
                
                let bottom = interpolate(x0: baseNoise[j1][i0],
                                         x1: baseNoise[j1][i1], alpha: horizontalBlend)
                
                smoothNoise[j][i] = interpolate(x0: top, x1: bottom, alpha: verticalBlend)
            }
        }
        
        return smoothNoise;
    }
    
    func generatePerlinNoise(baseNoise : [[CGFloat]], octaveCount: Int) -> [[CGFloat]] {
        let width = self.width
        let height = self.height
        
        var smoothNoise = Array(repeating: [[CGFloat]](), count: octaveCount)
        
        let persistance: CGFloat = 0.5
        
        for i in 0..<octaveCount {
            smoothNoise[i] = generateSmoothNoise(baseNoise: baseNoise, octave: i)
        }
        
        var perlinNoise = Array(repeating: Array(repeating: CGFloat(0.0), count: width), count: height)
        var amplitude: CGFloat = 1.0
        var totalAmplitude: CGFloat = 0.0
        
        for octave in (0..<octaveCount - 1).reversed() {
            amplitude *= persistance
            totalAmplitude += amplitude
            
            for i in 0..<width {
                for j in 0..<height {
                    perlinNoise[j][i] += smoothNoise[octave][j][i] * amplitude
                }
            }
        }
        
        for i in 0..<width {
            for j in 0..<height {
                perlinNoise[j][i] /= totalAmplitude
            }
        }
        
        return perlinNoise
    }
    
    var image: NSImage {
        
        let groundHue = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let waterHue = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let colorProvider = ColorProvider(groundHue: groundHue, waterHue: waterHue)
        
        let tileSize = MapGenerator.tileSize
        let worldImage = NSImage(size: NSSize(width: self.width * tileSize, height: self.height * tileSize))
        
        worldImage.lockFocus()
        
        for i in 0..<self.width {
            for j in 0..<self.height {
                let level = CGFloat(finalNoise[j][i])
                
                let color = colorProvider.planetColor(for: level)
                
                color.setFill()
                
                NSBezierPath(rect: NSRect(x: CGFloat(tileSize * i),
                                          y: CGFloat(tileSize * j),
                                          width: CGFloat(tileSize),
                                          height: CGFloat(tileSize))).fill()
            }
        }
        
        worldImage.unlockFocus()
        
        return worldImage
    }
    
    var printFinalNoise: String {
        var str = ""
        
        for i in 0..<self.width {
            for j in 0..<self.height {
                str += String(format: "%.2f ", self.finalNoise[j][i])
            }
            str += "\n"
        }
        
        return str
    }
}
