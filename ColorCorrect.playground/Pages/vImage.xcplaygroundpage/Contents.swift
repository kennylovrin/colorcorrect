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

print(bitmapInfo.contains(CGBitmapInfo.ByteOrderDefault))

// create a format for input
var inFormat = vImage_CGImageFormat(
    bitsPerComponent: 32,
    bitsPerPixel: 96,
    colorSpace: Unmanaged.passUnretained(colorSpace),
    bitmapInfo: [CGBitmapInfo.FloatComponents, CGBitmapInfo.ByteOrder32Little, CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)],
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

vImageContrastStretch_PlanarF(&r, &r, nil, 255, 0.2, 0.8, vImage_Flags(kvImageNoFlags))
vImageContrastStretch_PlanarF(&g, &g, nil, 255, 0.2, 0.8, vImage_Flags(kvImageNoFlags))
vImageContrastStretch_PlanarF(&b, &b, nil, 255, 0.2, 0.8, vImage_Flags(kvImageNoFlags))

/*var buffers = [UnsafePointer<vImage_Buffer>]()
buffers.append(&r)
buffers.append(&g)
buffers.append(&b)

var matrix: [Float] = [
    1, 0, 0,
    0.4, 1, 0,
    0.4, 0.8, 1
]

var bias: [Float] = [0, 0, 0]

vImageMatrixMultiply_PlanarF(&buffers, &buffers, 3, 3, &matrix, &bias, &bias, vImage_Flags(kvImageNoFlags))*/

var outFormat = inFormat
outFormat.bitsPerComponent = 32
outFormat.bitsPerPixel = 32
outFormat.colorSpace = Unmanaged.passRetained(CGColorSpaceCreateDeviceGray()!)

var outRCGImage = vImageCreateCGImageFromBuffer(&r, &outFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outRImage = CIImage(CGImage: outRCGImage)

var outGCGImage = vImageCreateCGImageFromBuffer(&g, &outFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outGImage = CIImage(CGImage: outGCGImage)

var outBCGImage = vImageCreateCGImageFromBuffer(&b, &outFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
var outBImage = CIImage(CGImage: outBCGImage)

// merge the three planes back together
vImageConvert_PlanarFtoRGBFFF(&r, &g, &b, &inBuffer, vImage_Flags(kvImageNoFlags))

// create output image (verifying it comes in and out properly)
outCGImage = vImageCreateCGImageFromBuffer(&inBuffer, &inFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil).takeRetainedValue()
outImage = CIImage(CGImage: outCGImage)
