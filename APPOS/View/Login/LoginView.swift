//
//  LoginView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/6.
//

import SwiftUI
import JWStatusHUD

struct LoginView: View {
    @State var mail: String = ""
    @State var password: String = ""
    
    @State var statusHUDItem: JWStatusHUDItem?
    @State var alertItem: AlertItem? {
        didSet {
            statusHUDItem = nil
        }
    }
    @State var isLoginSuccess: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            InputField.mail(inputText: $mail)
            InputField.password(inputText: $password)
            
            Button(LocalizedString.login) {
                login()
            }
        }
        .padding()
        .onAppear(perform: {
            #if DEBUG
            mail = "admin@mail.com"
            password = "Passw0rd"
            #endif
        })
        .statusHUD(item: $statusHUDItem)
        .alert(item: $alertItem, content: Alert.init)
        .fullScreenCover(isPresented: $isLoginSuccess, content: CompanyListView.init)
    }
}

// MARK: - Private functions
private extension LoginView {
    
    func login() {
        statusHUDItem = JWStatusHUDItem(type: .loading, message: LocalizedString.loading)
        
        APIManager.login(mail: mail, password: password) { (result) in
            switch result {
            case .success(let loginResult):
                log(loginResult)
                APIManager.setToken(loginResult.appToken)
                
                statusHUDItem = JWStatusHUDItem(type: .success, message: LocalizedString.loginSucceed, dismissAfter: 1) {
                    isLoginSuccess = true
                }
            case .failure(let error):
                log(error.localizedDescription)
                APIManager.clearToken()
                
                alertItem = AlertItem(title: Text(LocalizedString.error), message: Text(error.localizedDescription))
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
