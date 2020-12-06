//
//  AlertItem.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/6.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id: UUID = UUID()
    var title: Text
    var message: Text?
}
