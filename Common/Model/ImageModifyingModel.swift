//
//  ImageModifyingModel.swift
//  hometoke
//
//  Created by 寺田優 on 2019/12/28.
//  Copyright © 2019 toke. All rights reserved.
//

// UIImage の画像編集クラス

import Foundation
import UIKit

protocol ImageModifyingModelInput {
    
    // 画像のサイズを変更する（縮小率を指定）
    func imageResized(image: UIImage?,
                 withPercentage percentage: CGFloat,
                 completion: @escaping (Result<UIImage, ImageModifyingModelError>)-> ())
    
    // 画像のサイズを変更する（画像幅を指定）
    func imageResized(image: UIImage?,
                 toWidth width: CGFloat,
                 completion: @escaping (Result<UIImage, ImageModifyingModelError>)-> ())
}

// UIImageのextension
extension UIImage {
    
    // 画像のサイズを変更する（縮小率を指定）
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    // 画像のサイズを変更する（画像幅を指定）
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

enum ImageModifyingModelError : Error {
    case uiImageParseError(message: String)
}

final class ImageModifyingModel: ImageModifyingModelInput {
    
    func imageResized(image: UIImage?,
                      withPercentage percentage: CGFloat,
                      completion: @escaping (Result<UIImage, ImageModifyingModelError>) -> ()) {
        // 画像の縮小を実施
        guard let resizedImage: UIImage = image?.resized(withPercentage: percentage) else {
            return completion(.failure(.uiImageParseError(message: "画像の縮小に失敗しました")))
        }
        
        completion(.success(resizedImage))
    }
    
    func imageResized(image: UIImage?,
                      toWidth width: CGFloat,
                      completion: @escaping (Result<UIImage, ImageModifyingModelError>) -> ()) {
        // 画像の縮小を実施
        guard let resizedImage: UIImage = image?.resized(toWidth: width) else {
            return completion(.failure(.uiImageParseError(message: "画像の縮小に失敗しました")))
        }
        
        completion(.success(resizedImage))
    }
    
}
