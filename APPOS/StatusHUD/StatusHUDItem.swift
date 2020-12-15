//
//  StatusHUDItem.swift
//  APPOS
//
//  Created by Jay on 2020/12/14.
//

import Foundation

struct StatusHUDItem {
    
    var type: StatusHUDType
    var message: String? = nil
    var dismissAfter: TimeInterval? = nil
    var completion: (() -> Void)? = nil
    
}
