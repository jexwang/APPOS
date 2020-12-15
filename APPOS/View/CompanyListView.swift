//
//  CompanyListView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/10.
//

import SwiftUI

struct CompanyListView: View {
    @State var companyList: [Company] = []
    
    @State var statusHUDItem: StatusHUDItem?
    @State var alertItem: AlertItem?
    @State var showCreateCompanyView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(companyList, id: \.id) { (company) in
                    Text(company.name)
                }
            }
            .navigationTitle(LocalizedString.companyList)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateCompanyView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .onAppear(perform: loadData)
        }
        .statusHUD(item: $statusHUDItem)
        .alert(item: $alertItem, content: Alert.init)
        .sheet(isPresented: $showCreateCompanyView, content: {
            CreateCompanyView()
        })
    }
}

private extension CompanyListView {
    
    func loadData() {
        statusHUDItem = StatusHUDItem(type: .loading, message: LocalizedString.loading)
        
        APIManager.getCompanies { (result) in
            statusHUDItem = nil
            
            switch result {
            case .success(let paginationResult):
                log(paginationResult)
                self.companyList = paginationResult.result
            case .failure(let error):
                log(error.localizedDescription)
                alertItem = AlertItem(title: Text(LocalizedString.error), message: Text(error.localizedDescription))
            }
        }
    }
    
}

struct CompanyListView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyListView()
    }
}
