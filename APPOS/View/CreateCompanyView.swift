//
//  CreateCompanyView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/12.
//

import SwiftUI

struct CreateCompanyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var companyUID: String = ""
    @State var companyName: String = ""
    @State var companyAddress: String = ""
    @State var companyOwner: String = ""
    @State var companyMail: String = ""
    @State var companyPhone: String = ""
    @State var adminName: String = ""
    @State var adminMail: String = ""
    @State var adminPassword: String = ""
    @State var adminPhone: String = ""
    
    @State var statusHUDItem: StatusHUDItem?
    @State var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedString.companyUID)) {
                    TextField(LocalizedString.companyUID, text: $companyUID)
                }
                
                Section(header: Text(LocalizedString.companyName)) {
                    TextField(LocalizedString.companyName, text: $companyName)
                }
                
                Section(header: Text(LocalizedString.companyAddress)) {
                    TextField(LocalizedString.companyAddress, text: $companyAddress)
                }
                
                Section(header: Text(LocalizedString.companyOwner)) {
                    TextField(LocalizedString.companyOwner, text: $companyOwner)
                }
                
                Section(header: Text(LocalizedString.companyMail)) {
                    TextField(LocalizedString.companyMail, text: $companyMail)
                }
                
                Section(header: Text(LocalizedString.companyPhone)) {
                    TextField(LocalizedString.companyPhone, text: $companyPhone)
                }
                
                Section(header: Text(LocalizedString.adminName)) {
                    TextField(LocalizedString.adminName, text: $adminName)
                }
                
                Section(header: Text(LocalizedString.adminMail)) {
                    TextField(LocalizedString.adminMail, text: $adminMail)
                }
                
                Section(header: Text(LocalizedString.adminPassword)) {
                    TextField(LocalizedString.adminPassword, text: $adminPassword)
                }
                
                Section(header: Text(LocalizedString.adminPhone)) {
                    TextField(LocalizedString.adminPhone, text: $adminPhone)
                }
            }
            .navigationTitle(LocalizedString.createCompany)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        createCompany()
                    }, label: {
                        Text(LocalizedString.done)
                    })
                }
            }
            .statusHUD(item: $statusHUDItem)
            .alert(item: $alertItem, content: Alert.init)
        }
    }
}

// MARK: - Private functions
private extension CreateCompanyView {
    
    func createCompany() {
        statusHUDItem = StatusHUDItem(type: .loading, message: LocalizedString.loading)
        
        let company = CreateCompany(
            companyUID: companyUID,
            companyName: companyName,
            companyAddress: companyAddress,
            companyOwner: companyOwner,
            companyMail: companyMail,
            companyPhone: companyPhone,
            adminName: adminName,
            adminMail: adminMail,
            adminPassword: adminPassword,
            adminPhone: adminPhone
        )
        
        APIManager.createCompany(company: company) { (result) in
            switch result {
            case .success:
                log(company)
                
                statusHUDItem = StatusHUDItem(type: .success, message: LocalizedString.loginSucceed, dismissAfter: 1) {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                log(error.localizedDescription)
                
                statusHUDItem = nil
                alertItem = AlertItem(title: Text(LocalizedString.error), message: Text(error.localizedDescription))
            }
        }
    }
    
}

struct CreateCompanyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCompanyView()
    }
}
