//
//  UIImage+Umbrella.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/21/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Transforms orginal image into specific color
    ///
    /// - Parameter UIColor.
    /// - Returns: Returns colored image.
    func withColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
        color.setFill()
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height), mask: cgImage)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return colored
    }
}
