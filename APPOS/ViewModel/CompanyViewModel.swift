//
//  CompanyViewModel.swift
//  APPOS
//
//  Created by Jay on 2020/12/23.
//

import SwiftUI
import Combine
import JWStatusHUD

class CompanyViewModel: ObservableObject {
    
    // Output
    @Published var company: Company?
    
    @Published var statusHUDItem: JWStatusHUDItem?
    @Published var alertItem: AlertItem? {
        didSet {
            if alertItem != nil {
                statusHUDItem = nil
            }
        }
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func getCompany(by companyID: Int) {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let sharedRequest = APIManager.shared.getCompany(by: companyID).share()
        
        sharedRequest
            .map { (company) -> Company? in
                log(company)
                return company
            }
            .replaceError(with: nil)
            .receiveOnMain()
            .assign(to: \.company, on: self)
            .store(in: &cancellableSet)
        
        sharedRequest
            .map { (_) -> JWStatusHUDItem? in nil }
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
