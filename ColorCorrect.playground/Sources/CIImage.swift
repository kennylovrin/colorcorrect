import QuartzCore

extension CIImage {
    
    func removeOrangeMask() -> CIImage? {
        let filter = CIFilter(name: "CIColorMatrix")
        filter?.setDefaults()
        
        // r
        filter?.setValue(CIVector(x: 1, y: -1, z: -1, w: 0), forKey: "inputRVector")
        
        // g
        filter?.setValue(CIVector(x: 0, y: 1, z: 0.4, w: 0), forKey: "inputGVector")
        
        // b
        filter?.setValue(CIVector(x: 0, y: 0, z: 1, w: 0), forKey: "inputBVector")
        
        // a
        filter?.setValue(CIVector(x: 0, y: 0, z: 0, w: 1), forKey: "inputAVector")
        
        // bias
        filter?.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")
        
        filter?.setValue(self, forKey: kCIInputImageKey)
        return filter?.valueForKey(kCIOutputImageKey) as? CIImage
    }
    
    func invert() -> CIImage? {
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setDefaults()
        
        filter?.setValue(self, forKey: kCIInputImageKey)
        return filter?.valueForKey(kCIOutputImageKey) as? CIImage
    }
    
    func adjustGamma() -> CIImage? {
        let filter = CIFilter(name: "CIGammaAdjust")
        filter?.setDefaults()
        
        filter?.setValue(1 / 2.2, forKey: "inputPower")
        
        filter?.setValue(self, forKey: kCIInputImageKey)
        return filter?.valueForKey(kCIOutputImageKey) as? CIImage
    }
    
}