//: Playground - noun: a place where people can play

import Cocoa
import Accelerate

let image = Image(named: "test")

// get the image details
let width = CGImageGetWidth(image?.backingCGImage())
let height = CGImageGetHeight(image?.backingCGImage())
let bitsPerComponent = CGImageGetBitsPerComponent(image?.backingCGImage())
let bitsPerPixel = CGImageGetBitsPerPixel(image?.backingCGImage())
let colorSpace = CGImageGetColorSpace(image?.backingCGImage())!
let bitmapInfo = CGImageGetBitmapInfo(image?.backingCGImage())

// create a format for input
var inFormat = vImage_CGImageFormat(
    bitsPerComponent: UInt32(bitsPerComponent),
    bitsPerPixel: UInt32(bitsPerPixel),
    colorSpace: Unmanaged.passUnretained(colorSpace),
    bitmapInfo: [CGBitmapInfo.FloatComponents, CGBitmapInfo.ByteOrder16Little],
    version: 0,
    decode: nil,
    renderingIntent: CGColorRenderingIntent.RenderingIntentDefault
)

// create vimage input buffer
var inBuffer = vImage_Buffer()
vImageBuffer_InitWithCGImage(&inBuffer, &inFormat, nil, image!.backingCGImage(), vImage_Flags(kvImageNoFlags))

// create output image (verifying it comes in and out properly)
var outCGImage = vImageCreateCGImageFromBuffer(&inBuffer, &inFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outImage = CIImage(CGImage: outCGImage)

// create planar buffers
let rowBytes = width * sizeof(Pixel_F)

var rData = [Pixel_F](count: width * height, repeatedValue: 0)
var r = vImage_Buffer(data: &rData, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)

var gData = [Pixel_F](count: width * height, repeatedValue: 0)
var g = vImage_Buffer(data: &gData, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)

var bData = [Pixel_F](count: width * height, repeatedValue: 0)
var b = vImage_Buffer(data: &bData, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)

vImageConvert_RGBFFFtoPlanarF(&inBuffer, &r, &g, &b, vImage_Flags(kvImageNoFlags))

var outFormat = inFormat
outFormat.bitsPerComponent = 16
outFormat.bitsPerPixel = 16
outFormat.colorSpace = Unmanaged.passRetained(CGColorSpaceCreateDeviceGray()!)

var outRCGImage = vImageCreateCGImageFromBuffer(&r, &outFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outRImage = CIImage(CGImage: outRCGImage)

var outGCGImage = vImageCreateCGImageFromBuffer(&g, &outFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outGImage = CIImage(CGImage: outGCGImage)

var outBCGImage = vImageCreateCGImageFromBuffer(&b, &outFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outBImage = CIImage(CGImage: outBCGImage)

// merge the three planes back together
