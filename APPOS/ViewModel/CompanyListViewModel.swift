//
//  CompanyListViewModel.swift
//  APPOS
//
//  Created by Jay on 2020/12/17.
//

import SwiftUI
import Combine
import JWStatusHUD

class CompanyListViewModel: ObservableObject {
    
    // Output
    @Published var companyList: [Company] = []
    @Published var logoutSucceeded: Bool = false
    
    @Published var statusHUDItem: JWStatusHUDItem?
    @Published var alertItem: AlertItem? {
        didSet {
            if alertItem != nil {
                statusHUDItem = nil
            }
        }
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func loadData() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let sharedRequest = APIManager.shared.getCompanies().share()
        
        sharedRequest
            .map {
                log($0)
                return $0.result
            }
            .replaceError(with: [])
            .receiveOnMain()
            .assign(to: \.companyList, on: self)
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
    
    func logout() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let sharedRequest = APIManager.shared.logout().share()
        
        sharedRequest
            .map { _ in true }
            .replaceError(with: false)
            .receiveOnMain()
            .assign(to: \.logoutSucceeded, on: self)
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
