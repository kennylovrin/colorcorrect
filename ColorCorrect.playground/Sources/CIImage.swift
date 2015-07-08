import QuartzCore

extension CIImage {
    
    func removeOrangeMask() -> CIImage? {
        /*
        remove 80% magenta from yellow -> add 80% green to blue
        remove 40% cyan from magenta -> add 40% red to green
        remove 40% cyan from yellow -> add 40% red to blue
        */
        let filter = CIFilter(name: "CIColorMatrix")
        filter?.setDefaults()
        
        // r (c)
        filter?.setValue(CIVector(x: 1, y: 0, z: 0, w: 0), forKey: "inputRVector")
        
        // g (m)
        filter?.setValue(CIVector(x: 0.4, y: 1, z: 0, w: 0), forKey: "inputGVector")
        
        // b (y)
        filter?.setValue(CIVector(x: 0.4, y: 0.8, z: 1, w: 0), forKey: "inputBVector")
        
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
        
        filter?.setValue(2.2, forKey: "inputPower")
        
        filter?.setValue(self, forKey: kCIInputImageKey)
        return filter?.valueForKey(kCIOutputImageKey) as? CIImage
    }
    
    func applyToneTurve() -> CIImage? {
        let filter = CIFilter(name: "CIToneCurve")
        filter?.setDefaults()
        
        filter?.setValue(CIVector(x: 0, y: 0), forKey: "inputPoint0")
        filter?.setValue(CIVector(x: 0.6, y: 0), forKey: "inputPoint1")
        filter?.setValue(CIVector(x: 0.7, y: 0.5), forKey: "inputPoint2")
        filter?.setValue(CIVector(x: 0.8, y: 0.75), forKey: "inputPoint3")
        filter?.setValue(CIVector(x: 1, y: 1), forKey: "inputPoint4")
        
        filter?.setValue(self, forKey: kCIInputImageKey)
        return filter?.valueForKey(kCIOutputImageKey) as? CIImage
    }
    
}