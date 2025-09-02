import UIKit
import CoreGraphics
import GameplayKit

class CosmicWallpaperGenerator {
    
    private var randomSource: GKMersenneTwisterRandomSource!
    
    func generateWallpaper(settings: WallpaperSettings, size: CGSize) -> UIImage {
        randomSource = GKMersenneTwisterRandomSource(seed: settings.seed)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        drawBackground(context: context, size: size, colorScheme: settings.colorScheme)
        drawNebulae(context: context, size: size, intensity: settings.nebulaIntensity, colorScheme: settings.colorScheme, seed: settings.seed)
        drawStars(context: context, size: size, density: settings.starDensity, seed: settings.seed)
        drawPlanets(context: context, size: size, count: settings.planetCount, colorScheme: settings.colorScheme, seed: settings.seed)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    private func nextRandom() -> Float {
        return Float(randomSource.nextUniform())
    }
    
    private func nextRandom(in range: ClosedRange<CGFloat>) -> CGFloat {
        let random = CGFloat(nextRandom())
        return range.lowerBound + random * (range.upperBound - range.lowerBound)
    }
    
    private func drawBackground(context: CGContext, size: CGSize, colorScheme: ColorScheme) {
        let colors = getColorScheme(colorScheme)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: [
            colors.background1.cgColor,
            colors.background2.cgColor,
            colors.background3.cgColor
        ] as CFArray, locations: [0.0, 0.5, 1.0])!
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: size.height),
            options: []
        )
    }
    
    private func drawNebulae(context: CGContext, size: CGSize, intensity: Float, colorScheme: ColorScheme, seed: UInt64) {
        guard intensity > 0 else { return }
        
        let colors = getColorScheme(colorScheme)
        let nebulaCount = Int(intensity * 5) + 1
        
        for _ in 0..<nebulaCount {
            let centerX = nextRandom(in: 0...size.width)
            let centerY = nextRandom(in: 0...size.height)
            let radius = nextRandom(in: 100...300) * CGFloat(intensity)
            
            let colorIndex = Int(nextRandom() * 3)
            let nebulaColor = [colors.nebula1, colors.nebula2, colors.accent][colorIndex]
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: [
                nebulaColor.withAlphaComponent(0.6).cgColor,
                nebulaColor.withAlphaComponent(0.2).cgColor,
                UIColor.clear.cgColor
            ] as CFArray, locations: [0.0, 0.5, 1.0])!
            
            context.drawRadialGradient(
                gradient,
                startCenter: CGPoint(x: centerX, y: centerY),
                startRadius: 0,
                endCenter: CGPoint(x: centerX, y: centerY),
                endRadius: radius,
                options: []
            )
        }
    }
    
    private func drawStars(context: CGContext, size: CGSize, density: Float, seed: UInt64) {
        let starCount = Int(density * 500) + 50
        
        for _ in 0..<starCount {
            let x = nextRandom(in: 0...size.width)
            let y = nextRandom(in: 0...size.height)
            let starSize = nextRandom(in: 1...4)
            let brightness = nextRandom(in: 0.3...1.0)
            
            context.setFillColor(UIColor.white.withAlphaComponent(brightness).cgColor)
            
            if starSize > 2.5 {
                drawStar(context: context, center: CGPoint(x: x, y: y), size: starSize)
            } else {
                context.fillEllipse(in: CGRect(x: x - starSize/2, y: y - starSize/2, width: starSize, height: starSize))
            }
        }
    }
    
    private func drawStar(context: CGContext, center: CGPoint, size: CGFloat) {
        let points = 4
        let outerRadius = size
        let innerRadius = size * 0.4
        
        context.beginPath()
        
        for i in 0..<points * 2 {
            let angle = CGFloat(i) * .pi / CGFloat(points)
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            
            if i == 0 {
                context.move(to: CGPoint(x: x, y: y))
            } else {
                context.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        context.closePath()
        context.fillPath()
    }
    
    private func drawPlanets(context: CGContext, size: CGSize, count: Int, colorScheme: ColorScheme, seed: UInt64) {
        let colors = getColorScheme(colorScheme)
        
        for _ in 0..<count {
            let x = nextRandom(in: 0...size.width)
            let y = nextRandom(in: 0...size.height)
            let planetSize = nextRandom(in: 30...120)
            
            let colorIndex = Int(nextRandom() * 3)
            let planetColor = [colors.accent, colors.nebula1, colors.nebula2][colorIndex]
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: [
                planetColor.cgColor,
                planetColor.withAlphaComponent(0.6).cgColor,
                planetColor.withAlphaComponent(0.2).cgColor
            ] as CFArray, locations: [0.0, 0.7, 1.0])!
            
            context.drawRadialGradient(
                gradient,
                startCenter: CGPoint(x: x - planetSize * 0.2, y: y - planetSize * 0.2),
                startRadius: 0,
                endCenter: CGPoint(x: x, y: y),
                endRadius: planetSize / 2,
                options: []
            )
            
            if nextRandom() > 0.5 {
                context.setStrokeColor(planetColor.withAlphaComponent(0.3).cgColor)
                context.setLineWidth(2)
                let ringRadius = planetSize * 0.7
                context.strokeEllipse(in: CGRect(
                    x: x - ringRadius,
                    y: y - ringRadius * 0.2,
                    width: ringRadius * 2,
                    height: ringRadius * 0.4
                ))
            }
        }
    }
    
    private func getColorScheme(_ scheme: ColorScheme) -> CosmicColorScheme {
        switch scheme {
        case .purple:
            return CosmicColorScheme(
                background1: UIColor(red: 0.1, green: 0.05, blue: 0.3, alpha: 1.0),
                background2: UIColor(red: 0.05, green: 0.02, blue: 0.15, alpha: 1.0),
                background3: UIColor(red: 0.02, green: 0.01, blue: 0.08, alpha: 1.0),
                nebula1: UIColor(red: 0.8, green: 0.3, blue: 0.9, alpha: 1.0),
                nebula2: UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0),
                accent: UIColor(red: 0.9, green: 0.6, blue: 1.0, alpha: 1.0)
            )
        case .blue:
            return CosmicColorScheme(
                background1: UIColor(red: 0.05, green: 0.1, blue: 0.3, alpha: 1.0),
                background2: UIColor(red: 0.02, green: 0.05, blue: 0.15, alpha: 1.0),
                background3: UIColor(red: 0.01, green: 0.02, blue: 0.08, alpha: 1.0),
                nebula1: UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0),
                nebula2: UIColor(red: 0.2, green: 0.8, blue: 1.0, alpha: 1.0),
                accent: UIColor(red: 0.4, green: 0.9, blue: 1.0, alpha: 1.0)
            )
        case .green:
            return CosmicColorScheme(
                background1: UIColor(red: 0.05, green: 0.2, blue: 0.15, alpha: 1.0),
                background2: UIColor(red: 0.02, green: 0.1, blue: 0.08, alpha: 1.0),
                background3: UIColor(red: 0.01, green: 0.05, blue: 0.04, alpha: 1.0),
                nebula1: UIColor(red: 0.3, green: 0.9, blue: 0.6, alpha: 1.0),
                nebula2: UIColor(red: 0.2, green: 0.8, blue: 0.9, alpha: 1.0),
                accent: UIColor(red: 0.4, green: 1.0, blue: 0.7, alpha: 1.0)
            )
        case .orange:
            return CosmicColorScheme(
                background1: UIColor(red: 0.2, green: 0.1, blue: 0.05, alpha: 1.0),
                background2: UIColor(red: 0.15, green: 0.05, blue: 0.02, alpha: 1.0),
                background3: UIColor(red: 0.08, green: 0.02, blue: 0.01, alpha: 1.0),
                nebula1: UIColor(red: 1.0, green: 0.6, blue: 0.3, alpha: 1.0),
                nebula2: UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0),
                accent: UIColor(red: 1.0, green: 0.8, blue: 0.4, alpha: 1.0)
            )
        case .custom(let color):
            return createCustomColorScheme(from: color)
        }
    }
    
    private func createCustomColorScheme(from color: UIColor) -> CosmicColorScheme {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return CosmicColorScheme(
            background1: UIColor(hue: hue, saturation: saturation * 0.8, brightness: brightness * 0.3, alpha: 1.0),
            background2: UIColor(hue: hue, saturation: saturation * 0.6, brightness: brightness * 0.15, alpha: 1.0),
            background3: UIColor(hue: hue, saturation: saturation * 0.4, brightness: brightness * 0.08, alpha: 1.0),
            nebula1: UIColor(hue: hue, saturation: saturation * 0.9, brightness: brightness * 0.9, alpha: 1.0),
            nebula2: UIColor(hue: fmod(hue + 0.1, 1.0), saturation: saturation * 0.8, brightness: brightness * 0.8, alpha: 1.0),
            accent: UIColor(hue: fmod(hue + 0.05, 1.0), saturation: saturation * 0.7, brightness: brightness, alpha: 1.0)
        )
    }
}

struct WallpaperSettings {
    let starDensity: Float
    let nebulaIntensity: Float
    let planetCount: Int
    let colorScheme: ColorScheme
    let seed: UInt64
}

enum ColorScheme {
    case purple, blue, green, orange, custom(UIColor)
}

struct CosmicColorScheme {
    let background1: UIColor
    let background2: UIColor
    let background3: UIColor
    let nebula1: UIColor
    let nebula2: UIColor
    let accent: UIColor
}