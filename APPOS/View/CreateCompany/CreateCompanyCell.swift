//
//  CreateCompanyCell.swift
//  APPOS
//
//  Created by Jay on 2020/12/17.
//

import SwiftUI

struct CreateCompanyCell: View {
    let title: LocalizedStringKey
    @Binding var text: String
    
    var body: some View {
        Section(header: Text(title)) {
            TextField(title, text: $text)
        }
    }
}

struct CreateCompanyCell_Previews: PreviewProvider {
    static let title: LocalizedStringKey = .companyName
    @State static var text: String = ""
    
    static var previews: some View {
        CreateCompanyCell(title: title, text: $text)
    }
}
