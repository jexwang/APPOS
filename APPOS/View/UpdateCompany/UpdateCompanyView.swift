//
//  UpdateCompanyView.swift
//  APPOS
//
//  Created by Jay on 2020/12/23.
//

import SwiftUI

struct UpdateCompanyView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var viewModel: UpdateCompanyViewModel = UpdateCompanyViewModel()
    
    let company: Company
    
    var body: some View {
        NavigationView {
            Form {
                CreateCompanyCell(title: .companyName, text: $viewModel.companyName)
                
                CreateCompanyCell(title: .companyAddress, text: $viewModel.companyAddress)
                
                CreateCompanyCell(title: .companyOwner, text: $viewModel.companyOwner)
                
                CreateCompanyCell(title: .companyMail, text: $viewModel.companyMail)
                
                CreateCompanyCell(title: .companyPhone, text: $viewModel.companyPhone)
            }
            .navigationTitle(.updateCompanyInformation)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.updateCompany(id: company.id)
                    }, label: {
                        Text(.done)
                    })
                }
            }
            .onAppear(perform: {
                viewModel.companyName = company.name
                viewModel.companyAddress = company.address
                viewModel.companyPhone = company.phone
            })
            .onReceive(viewModel.$updateSucceeded) {
                if $0 { presentationMode.wrappedValue.dismiss() }
            }
            .statusHUD(item: $viewModel.statusHUDItem)
            .alert(item: $viewModel.alertItem, content: Alert.init)
        }
    }
}

struct UpdateCompanyView_Previews: PreviewProvider {
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
        UpdateCompanyView(company: company)
    }
}
