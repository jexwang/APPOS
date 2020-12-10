//
//  CompanyListView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/10.
//

import SwiftUI

struct CompanyListView: View {
    @State var companyList: [Company] = []
    
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
            .alert(item: $alertItem) { (item) -> Alert in
                Alert(title: item.title, message: item.message, dismissButton: nil)
            }
        }
        .sheet(isPresented: $showCreateCompanyView, content: {
            Text("Create")
        })
    }
}

private extension CompanyListView {
    
    func loadData() {
        APIManager.getCompanies { (result) in
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
