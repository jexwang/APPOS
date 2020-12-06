//
//  LoginView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/6.
//

import SwiftUI

struct LoginView: View {
    @State var mail: String = ""
    @State var password: String = ""
    
    @State var alertItem: AlertItem?
    
    var body: some View {
        VStack {
            TextField(String.mail, text: $mail)
            Divider()
            
            SecureField(String.password, text: $password)
            Divider()
            
            Button(String.login) {
                login()
            }
            .padding(.top)
        }
        .padding()
        .alert(item: $alertItem) { (item) -> Alert in
            Alert(title: item.title, message: item.message, dismissButton: nil)
        }
    }
}

private extension LoginView {
    
    func login() {
        APIManager.login(mail: mail, password: password) { (result) in
            switch result {
            case .success(let loginResult):
                APIManager.setToken(loginResult.appToken)
//                self?.performSegue(withIdentifier: "ToCompanies", sender: nil)
            case .failure(let error):
                alertItem = AlertItem(title: Text(String.error), message: Text(error.localizedDescription))
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
