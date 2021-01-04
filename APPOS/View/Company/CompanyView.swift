//
//  CompanyView.swift
//  APPOS
//
//  Created by Jay on 2020/12/22.
//

import SwiftUI

struct CompanyView: View {
    let company: Company
    
    @StateObject private var viewModel: CompanyViewModel = CompanyViewModel()
    
    @State private var showUpdateCompanyView: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                CompanyItem(title: .companyUID, value: viewModel.company?.uid ?? company.uid)
                CompanyItem(title: .companyAddress, value: viewModel.company?.address ?? company.address)
                CompanyItem(title: .companyPhone, value: viewModel.company?.phone ?? company.phone)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(viewModel.company?.name ?? company.name, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showUpdateCompanyView = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
            }
        }
        .onAppear(perform: { viewModel.getCompany(by: company.id) })
        .statusHUD(item: $viewModel.statusHUDItem)
        .alert(item: $viewModel.alertItem, content: Alert.init)
        .sheet(isPresented: $showUpdateCompanyView,
               onDismiss: { viewModel.getCompany(by: company.id) },
               content: { UpdateCompanyView(company: viewModel.company ?? company) })
    }
}

struct CompanyView_Previews: PreviewProvider {
    static let company: Company = Company(
        id: 3,
        uid: "jayisa",
        name: "iOS Creator",
        address: "台中市太平區立功路130號",
        phone: "0926623688",
        isEnabled: true,
        createdAt: 1606361524,
        updatedAt: 1606819486
    )
    
    static var previews: some View {
        NavigationView {
            CompanyView(company: company)
        }
    }
}

struct CompanyItem: View {
    let title: LocalizedStringKey
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(value)
        }
    }
}
