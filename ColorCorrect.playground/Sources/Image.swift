import Cocoa

public struct Image {
    
    private let backingImage: CGImage

    public init?(named: String) {
        guard let
            url = NSBundle.mainBundle().URLForImageResource(named),
            source = CGImageSourceCreateWithURL(url, nil),
            image = CGImageSourceCreateImageAtIndex(source, 0, nil)
            
        else {
            return nil
        }
        
        backingImage = image
    }
    
}

extension Image: Quartzable {
    
    public func backingCGImage() -> CGImage {
        return backingImage
    }
    
}

extension Image: Correctable {
    
    public func uncorrectedImage() -> CIImage {
        return CIImage(CGImage: backingImage)
    }
    
    public func correctedImage() -> CIImage? {
        return uncorrectedImage().removeOrangeMask()?.invert()?.adjustGamma()
    }
    
}