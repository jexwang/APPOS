//
//  CompanyListView.swift
//  APPOS
//
//  Created by Jay on 2020/12/10.
//

import SwiftUI
import JWStatusHUD

struct CompanyListView: View {
    @ObservedObject var viewModel: CompanyListViewModel = CompanyListViewModel()
    
    @State var showCreateCompanyView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.companyList) { (company) in
                    NavigationLink(destination: Text(company.name)) {
                        CompanyCell(company: company)
                    }
                }
            }
            .navigationBarTitle(.companyList, displayMode: .inline)
            .toolbar {
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
        .statusHUD(item: $viewModel.statusHUDItem)
        .alert(item: $viewModel.alertItem, content: Alert.init)
        .sheet(isPresented: $showCreateCompanyView, content: CreateCompanyView.init)
    }
}

struct CompanyListView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyListView()
    }
}
