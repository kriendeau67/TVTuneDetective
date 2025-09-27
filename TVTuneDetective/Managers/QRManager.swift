//
//  QRManager.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//

/*protocol QRGenerating {
  func image(for url: URL) -> CGImage?
} */

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import CoreGraphics

/// Generates QR codes for join links shown on the TV.
final class QRManager {
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    /// Create a QR code image from a plain string.
    /// - Parameters:
    ///   - string: The content to encode (e.g., "http://192.168.1.10:8080/?room=ABCD").
    ///   - size: Target pixel size of the QR image (square).
    /// - Returns: A crisp CGImage suitable for SwiftUI `Image(decorative:cgImage, scale:1, orientation:.up)`.
    func makeCGImage(from string: String, size: CGFloat = 512) -> CGImage? {
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M" // good balance of density & error correction

        guard let output = filter.outputImage else { return nil }

        // Scale the CIImage up to the requested size to avoid blur.
        let scaleX = size / output.extent.size.width
        let scaleY = size / output.extent.size.height
        let scaled = output.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        return context.createCGImage(scaled, from: scaled.extent)
    }

    /// Convenience: Create a QR from a URL.
    func makeCGImage(from url: URL, size: CGFloat = 512) -> CGImage? {
        makeCGImage(from: url.absoluteString, size: size)
    }
}
