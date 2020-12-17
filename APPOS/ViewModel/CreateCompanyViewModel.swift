//
//  CreateCompanyViewModel.swift
//  APPOS
//
//  Created by Jay on 2020/12/17.
//

import SwiftUI
import Combine
import JWStatusHUD

class CreateCompanyViewModel: ObservableObject {
    
    // Output
    @Published var companyUID: String = ""
    @Published var companyName: String = ""
    @Published var companyAddress: String = ""
    @Published var companyOwner: String = ""
    @Published var companyMail: String = ""
    @Published var companyPhone: String = ""
    @Published var adminName: String = ""
    @Published var adminMail: String = ""
    @Published var adminPassword: String = ""
    @Published var adminPhone: String = ""
    
    @Published var createSucceeded: Bool = false
    
    @Published var statusHUDItem: JWStatusHUDItem?
    @Published var alertItem: AlertItem? {
        didSet {
            if alertItem != nil {
                statusHUDItem = nil
            }
        }
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func createCompany() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: LocalizedString.loading)
        
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
        
        let shareResult = APIManager.shared.createCompany(companyData: company).share()
        
        shareResult
            .map { (_) in
                log(company)
                return true
            }
            .replaceError(with: false)
            .receiveOnMain()
            .assign(to: \.createSucceeded, on: self)
            .store(in: &cancellableSet)
        
        shareResult
            .map { (_) -> JWStatusHUDItem? in
                JWStatusHUDItem(type: .success, message: LocalizedString.createSucceed, dismissAfter: 1)
            }
            .replaceError(with: nil)
            .receiveOnMain()
            .assign(to: \.statusHUDItem, on: self)
            .store(in: &cancellableSet)
        
        shareResult
            .map { (_) -> AlertItem? in nil }
            .catch { (error) -> Just<AlertItem?> in
                log(error)
                return Just(AlertItem(title: Text(.error), message: Text(error.localizedStringKey)))
            }
            .receiveOnMain()
            .assign(to: \.alertItem, on: self)
            .store(in: &cancellableSet)
    }
    
}
