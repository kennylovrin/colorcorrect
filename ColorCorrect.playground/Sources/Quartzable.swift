import Foundation

public protocol Quartzable {
    
    var isColor: Bool { get }
    
    func backingCGImage() -> CGImage
    
}