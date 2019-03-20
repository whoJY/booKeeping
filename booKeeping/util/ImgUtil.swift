//
//  ImgUtil.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/20.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import Foundation
import UIKit
class ImgUtil {
    
    //Convert a UIImage representation to a base64
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        print(imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))
        return imageData.base64EncodedString(options: .init(rawValue: 0))
    }
    
    //
    // Convert a base64 representation to a UIImage
    //
    class func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: .init(rawValue: 0))!
        return UIImage(data: imageData)!
    }
    
    
    
}
