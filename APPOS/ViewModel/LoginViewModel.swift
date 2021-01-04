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
    @Published var roles: LoginRoles = .user
    @Published var mail: String = ""
    @Published var password: String = ""
    @Published var uid: String = ""
    
    // Output
    @Published var uidInputFieldVisible: Bool = false
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
        Publishers.CombineLatest3($mail, $password, $uid)
            .map {
                switch self.roles {
                case .user:
                    return $0.0.count > 0 && $0.1.count > 0
                case .company:
                    return $0.0.count > 0 && $0.1.count > 0 && $0.2.count > 0
                }
            }
            .assign(to: \.loginButtonEnabled, on: self)
            .store(in: &cancellableSet)
        
        $roles
            .map { $0 == .company }
            .assign(to: \.uidInputFieldVisible, on: self)
            .store(in: &cancellableSet)
    }
    
}

// MARK: - Private functions
private extension LoginViewModel {
    
    func userLogin() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let sharedRequest = APIManager.shared.userLogin(mail: mail, password: password).share()
        
        sharedRequest
            .map { (result) -> String? in
                log(result)
                return result.appToken
            }
            .replaceError(with: nil)
            .receiveOnMain()
            .assign(to: \.token, on: APIManager.shared)
            .store(in: &cancellableSet)
        
        sharedRequest
            .map { _ in true }
            .replaceError(with: false)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .assign(to: \.loginSucceeded, on: self)
            .store(in: &cancellableSet)
        
        sharedRequest
            .map { (_) -> JWStatusHUDItem? in
                JWStatusHUDItem(type: .success, message: .loginSucceeded, dismissAfter: 1)
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
    
    func companyLogin() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: .loading)
        
        let sharedRequest = APIManager.shared.companyLogin(mail: mail, password: password, uid: uid).share()
        
        sharedRequest
            .map { (result) -> String? in
                log(result)
                return result.appToken
            }
            .replaceError(with: nil)
            .receiveOnMain()
            .assign(to: \.token, on: APIManager.shared)
            .store(in: &cancellableSet)
        
        sharedRequest
            .map { _ in true }
            .replaceError(with: false)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .assign(to: \.loginSucceeded, on: self)
            .store(in: &cancellableSet)
        
        sharedRequest
            .map { (_) -> JWStatusHUDItem? in
                JWStatusHUDItem(type: .success, message: .loginSucceeded, dismissAfter: 1)
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

// MARK: - Internal functions
extension LoginViewModel {
    
    func login() {
        switch roles {
        case .user:
            userLogin()
        case .company:
            companyLogin()
        }
    }
    
}
