import UIKit

/// https://www.kodeco.com/25658084-core-image-tutorial-for-ios-custom-filters/page/2?page=1#toc-anchor-002
class ImageProcessor {
    func applyGrayscale(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        guard let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        grayscaleFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputImage = grayscaleFilter.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    func applyBlur(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(10.0, forKey: kCIInputRadiusKey)
        
        if let outputImage = blurFilter.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    func applyContrast(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        guard let contrastFilter = CIFilter(name: "CIColorControls") else { return nil }
        contrastFilter.setValue(ciImage, forKey: kCIInputImageKey)
        contrastFilter.setValue(2.0, forKey: kCIInputContrastKey)
        
        if let outputImage = contrastFilter.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    func processImage(image: UIImage) -> UIImage? {
        var processedImage = image
        
        if let grayscaleImage = self.applyGrayscale(to: processedImage) {
            processedImage = grayscaleImage
        }
        
        if let blurredImage = self.applyBlur(to: processedImage) {
            processedImage = blurredImage
        }
        
        if let contrastedImage = self.applyContrast(to: processedImage) {
            processedImage = contrastedImage
        }
        
        return processedImage
    }
}
