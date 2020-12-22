//
//  CompanyListView.swift
//  APPOS
//
//  Created by Jay on 2020/12/10.
//

import SwiftUI
import JWStatusHUD

struct CompanyListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CompanyListViewModel = CompanyListViewModel()
    
    @State var showCreateCompanyView: Bool = false
    
    var body: some View {
        NavigationView {
            List(viewModel.companyList) { (company) in
                NavigationLink(destination: Text(company.name)) {
                    CompanyCell(company: company)
                }
            }
            .navigationBarTitle(.companyList, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.logout()
                    }, label: {
                        Text(.logout)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateCompanyView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .onAppear(perform: viewModel.loadData)
        }
        .onReceive(viewModel.$logoutSucceeded, perform: {
            if $0 { presentationMode.wrappedValue.dismiss() }
        })
        .statusHUD(item: $viewModel.statusHUDItem)
        .alert(item: $viewModel.alertItem, content: Alert.init)
        .sheet(isPresented: $showCreateCompanyView, onDismiss: viewModel.loadData, content: CreateCompanyView.init)
    }
}

struct CompanyListView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyListView()
    }
}
