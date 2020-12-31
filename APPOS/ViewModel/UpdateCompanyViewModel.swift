//
//  UpdateCompanyViewModel.swift
//  APPOS
//
//  Created by Jay on 2020/12/23.
//

import SwiftUI
import Combine
import JWStatusHUD

class UpdateCompanyViewModel: ObservableObject {
    
    // input
    @Published var companyName: String = ""
    @Published var companyAddress: String = ""
    @Published var companyOwner: String = ""
    @Published var companyMail: String = ""
    @Published var companyPhone: String = ""
    
    // Output
    @Published var updateSucceeded: Bool = false
    
    @Published var statusHUDItem: JWStatusHUDItem?
    @Published var alertItem: AlertItem? {
        didSet {
            if alertItem != nil {
                statusHUDItem = nil
            }
        }
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func updateCompany(id companyID: Int) {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let company = UpdateCompany(
            name: companyName,
            address: companyAddress,
            owner: companyOwner,
            mail: companyMail,
            phone: companyPhone
        )

        let sharedRequest = APIManager.shared.updateCompany(id: companyID, companyData: company).share()

        sharedRequest
            .map { (_) in
                log(company)
                return true
            }
            .replaceError(with: false)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .assign(to: \.updateSucceeded, on: self)
            .store(in: &cancellableSet)

        sharedRequest
            .map { (_) -> JWStatusHUDItem? in
                JWStatusHUDItem(type: .success, message: .updateSucceeded, dismissAfter: 1)
            }
            .replaceError(with: nil)
            .receiveOnMain()
            .assign(to: \.statusHUDItem, on: self)
            .store(in: &cancellableSet)

        sharedRequest
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

