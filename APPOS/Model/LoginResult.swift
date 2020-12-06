//
//  LoginResult.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/11/25.
//

import Foundation

struct LoginResult: Decodable {
    let appToken: String
    
    enum CodingKeys: String, CodingKey {
        case appToken = "app_token"
    }
}
