//
//  LoginResult.swift
//  APPOS
//
//  Created by Jay on 2020/11/25.
//

import Foundation

struct LoginResult: Decodable {
    let appToken: String
    
    enum CodingKeys: String, CodingKey {
        case appToken = "app_token"
    }
}
