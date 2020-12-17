//
//  CreateCompanyView.swift
//  APPOS
//
//  Created by Jay on 2020/12/12.
//

import SwiftUI
import JWStatusHUD

struct CreateCompanyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: CreateCompanyViewModel = CreateCompanyViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                CreateCompanyCell(title: .companyUID, text: $viewModel.companyUID)
                
                CreateCompanyCell(title: .companyName, text: $viewModel.companyName)
                
                CreateCompanyCell(title: .companyAddress, text: $viewModel.companyAddress)
                
                CreateCompanyCell(title: .companyOwner, text: $viewModel.companyOwner)
                
                CreateCompanyCell(title: .companyMail, text: $viewModel.companyMail)
                
                CreateCompanyCell(title: .companyPhone, text: $viewModel.companyPhone)
                
                CreateCompanyCell(title: .adminName, text: $viewModel.adminName)
                
                CreateCompanyCell(title: .adminMail, text: $viewModel.adminMail)
                
                CreateCompanyCell(title: .adminPassword, text: $viewModel.adminPassword)
                
                CreateCompanyCell(title: .adminPhone, text: $viewModel.adminPhone)
            }
            .navigationTitle(.createCompany)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.createCompany()
                    }, label: {
                        Text(LocalizedString.done)
                    })
                }
            }
        }
        .statusHUD(item: $viewModel.statusHUDItem)
        .alert(item: $viewModel.alertItem, content: Alert.init)
    }
}

struct CreateCompanyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCompanyView()
    }
}
