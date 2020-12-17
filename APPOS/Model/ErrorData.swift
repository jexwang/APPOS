//
//  ErrorData.swift
//  APPOS
//
//  Created by Jay on 2020/11/14.
//

import Foundation

struct ErrorData: Decodable {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
}
