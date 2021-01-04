//
//  Defines.swift
//  APPOS
//
//  Created by Jay on 2021/1/4.
//

import SwiftUI

enum LoginRoles: CaseIterable {
    case user
    case company
    
    var localizedString: LocalizedStringKey {
        switch self {
        case .user:
            return .user
        case .company:
            return .company
        }
    }
}
