import Cocoa

public protocol Correctable {
    
    func uncorrectedImage() -> CIImage
    
    func correctedImage() -> CIImage?
    
}