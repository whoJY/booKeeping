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
//        print(imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))
        return imageData.base64EncodedString(options: .init(rawValue: 0))
    }
    
    //
    // Convert a base64 representation to a UIImage
    //
    class func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
    //获取存储的照片
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    
    
    //存储照片
    func saveImage(image: UIImage,name:String) -> Bool {
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/"+name
        let imageData = image.jpegData(compressionQuality: 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        return true
    }
    
    
}
