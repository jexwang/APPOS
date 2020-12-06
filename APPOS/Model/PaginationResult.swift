//
//  PaginationResult.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/11/26.
//

import Foundation

struct PaginationResult<T: Decodable>: Decodable {
    
    struct Page: Decodable {
        let page: Int
        let perPage: Int
        let total: Int
        let lastPage: Int
        
        enum CodingKeys: String, CodingKey {
            case page = "page"
            case perPage = "per_page"
            case total = "total"
            case lastPage = "last_page"
        }
    }
    
    let page: Page
    let result: [T]
}
