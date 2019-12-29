//
//  CreateQrcodeModel.swift
//  hometoke
//
//  Created by 寺田優 on 2019/10/30.
//  Copyright © 2019 toke. All rights reserved.
//

/* 使い方
 ①Input -> QRコード化したいString
   (*** 要望があれば他Typeを変換できるよう改修 ***)
 ②Output -> QRコードをUIImageで返す
 ③エラー仕様
   ・contentError -> InputにQRコード化できないコンテンツが指定されたとき
*/

import Foundation
import UIKit

protocol CreateQrcodeModelInput {
    func createQrcode(
        query: String?,
        completion: @escaping (Result<UIImage, ConvertQrcodeError>) -> ())
}

enum ConvertQrcodeError : Error {
    case contentError(message: String)
}

final class CreateQrcodeModel: CreateQrcodeModelInput {
    
    // QRコードの生成処理
    func createQrcode(
        query: String?,
        completion: @escaping (Result<UIImage, ConvertQrcodeError>) -> ()) {
        
        // QRコード化できるコンテンツか判定する
        guard let content: String = query else {
            return completion(.failure(.contentError(message:"QRコードにできないコンテンツです")))
        }
        
        // NSString から NSDataへ変換
        let data = content.data(using: String.Encoding.utf8)
        
        // QRコード生成のフィルター作成
        let qr = CIFilter(name: "CIQRCodeGenerator",
                          parameters: ["inputMessage": data as Any, "inputCorrectionLevel": "M"])!
        
        // qrコードの整形
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = qr.outputImage!.transformed(by: sizeTransform)
        
        // CIImage -> CGImage -> UIImage -> Data に変換
        let context = CIContext()
        let cgImage = context.createCGImage(qrImage, from: qrImage.extent)
        let uiImage = UIImage(cgImage: cgImage!)
        
        completion(.success(uiImage))
        
    }
}
