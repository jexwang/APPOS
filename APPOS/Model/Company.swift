//
//  Company.swift
//  APPOS
//
//  Created by Jay on 2020/11/14.
//

import Foundation

// MARK: - Company
struct Company: Decodable, Identifiable {
    let id: Int
    let uid: String
    let name: String
    let address: String
    let phone: String
    let isEnabled: Bool
    let createdAt: Int
    let updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uid = "uid"
        case name = "name"
        case address = "address"
        case phone = "phone"
        case isEnabled = "is_enabled"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CreateCompany
struct CreateCompany: Encodable {
    let companyUID: String
    let companyName: String
    let companyAddress: String
    let companyOwner: String
    let companyMail: String
    let companyPhone: String
    let adminName: String
    let adminMail: String
    let adminPassword: String
    let adminPhone: String
    
    enum CodingKeys: String, CodingKey {
        case companyUID = "company_uid"
        case companyName = "company_name"
        case companyAddress = "company_address"
        case companyOwner = "company_owner"
        case companyMail = "company_mail"
        case companyPhone = "company_phone"
        case adminName = "admin_name"
        case adminMail = "admin_mail"
        case adminPassword = "admin_password"
        case adminPhone = "admin_phone"
    }
}

// MARK: - UpdateCompany
struct UpdateCompany: Encodable {
    let name: String?
    let address: String?
    let owner: String?
    let mail: String?
    let phone: String?
    
    init(name: String, address: String, owner: String, mail: String, phone: String) {
        self.name = name == "" ? nil : name
        self.address = address == "" ? nil : address
        self.owner = owner == "" ? nil : owner
        self.mail = mail == "" ? nil : mail
        self.phone = phone == "" ? nil : phone
    }
}
