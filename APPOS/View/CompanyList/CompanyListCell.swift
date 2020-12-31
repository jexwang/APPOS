//
//  CompanyListCell.swift
//  APPOS
//
//  Created by Jay on 2020/12/13.
//

import SwiftUI

struct CompanyListCell: View {
    let company: Company
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(company.name)
                .font(.title3)
            
            Text(company.address)
                .font(.body)
            
            Text(company.phone)
                .font(.body)
        }
    }
}

struct CompanyCell_Previews: PreviewProvider {
    static let company: Company = Company(
        id: 1,
        uid: "jayisa",
        name: "iOS Creator",
        address: "台中市太平區立功路130號",
        phone: "0926623688",
        isEnabled: true,
        createdAt: 123456,
        updatedAt: 234567
    )
    
    static var previews: some View {
        CompanyListCell(company: company)
    }
}
