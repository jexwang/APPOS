//
//  CompanyView.swift
//  APPOS
//
//  Created by Jay on 2020/12/22.
//

import SwiftUI

struct CompanyView: View {
    let company: Company
    
    @State var showEditCompanyView: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                CompanyItemView(title: .companyUID, value: company.uid)
                CompanyItemView(title: .companyAddress, value: company.address)
                CompanyItemView(title: .companyPhone, value: company.phone)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(company.name, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showEditCompanyView = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
            }
        }
        .sheet(isPresented: $showEditCompanyView, content: {
            Text("Test")
        })
    }
}

struct CompanyView_Previews: PreviewProvider {
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
        NavigationView {
            CompanyView(company: company)
        }
    }
}

struct CompanyItemView: View {
    let title: LocalizedStringKey
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(value)
        }
    }
}
