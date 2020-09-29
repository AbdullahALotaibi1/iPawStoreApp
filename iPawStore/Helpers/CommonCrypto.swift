//
//  CommonCrypto.swift
//  iPawStore
//
//  Created by Abdullah on 04/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit
import CommonCrypto


class Cypto {
    static func getHash(_ phrase:String) -> String{
        let data = phrase.data(using: String.Encoding.utf8)!
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined(separator: "")
    }
}
