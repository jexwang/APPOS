//
//  LoginResult.swift
//  APPOS
//
//  Created by Jay on 2020/11/25.
//

import Foundation

struct UserLoginResult: Decodable {
    let appToken: String
    
    enum CodingKeys: String, CodingKey {
        case appToken = "app_token"
    }
}

struct CompanyLoginResult: Decodable {
    let appToken: String
    let emploeeyID: Int
    let companyID: Int
    
    enum CodingKeys: String, CodingKey {
        case appToken = "app_token"
        case emploeeyID = "employee_id"
        case companyID = "company_id"
    }
}
