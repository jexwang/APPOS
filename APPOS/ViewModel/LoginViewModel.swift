//
//  LoginViewModel.swift
//  APPOS
//
//  Created by Jay on 2020/12/16.
//

import SwiftUI
import Combine
import JWStatusHUD

class LoginViewModel: ObservableObject {
    
    // Input
    @Published var mail: String = ""
    @Published var password: String = ""
    
    // Output
    @Published var loginButtonEnabled: Bool = false
    @Published var loginSucceeded: Bool = false
    
    @Published var statusHUDItem: JWStatusHUDItem?
    @Published var alertItem: AlertItem? {
        didSet {
            if alertItem != nil {
                statusHUDItem = nil
            }
        }
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest($mail, $password)
            .map { $0.0.count > 0 && $0.1.count > 0 }
            .assign(to: \.loginButtonEnabled, on: self)
            .store(in: &cancellableSet)
        
        #if DEBUG
        mail = "admin@mail.com"
        password = "Passw0rd"
        #endif
    }
    
    func login() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let shareResult = APIManager.shared.login(mail: mail, password: password).share()
        
        shareResult
            .map { (result) -> String? in
                log(result)
                return result.appToken
            }
            .replaceError(with: nil)
            .receiveOnMain()
            .assign(to: \.token, on: APIManager.shared)
            .store(in: &cancellableSet)
        
        shareResult
            .map { _ in true }
            .replaceError(with: false)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .assign(to: \.loginSucceeded, on: self)
            .store(in: &cancellableSet)
        
        shareResult
            .map { (_) -> JWStatusHUDItem? in
                JWStatusHUDItem(type: .success, message: .loginSucceeded, dismissAfter: 1)
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
