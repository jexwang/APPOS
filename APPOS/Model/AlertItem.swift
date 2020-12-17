//
//  AlertItem.swift
//  APPOS
//
//  Created by Jay on 2020/12/6.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id: UUID = UUID()
    var title: Text
    var message: Text?
}
