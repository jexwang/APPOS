//
//  Alert+Extension.swift
//  APPOS
//
//  Created by Jay on 2020/12/12.
//

import SwiftUI

extension Alert {
    
    init(item: AlertItem) {
        self.init(title: item.title, message: item.message, dismissButton: nil)
    }
    
}
