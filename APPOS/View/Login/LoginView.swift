//
//  LoginView.swift
//  APPOS
//
//  Created by Jay on 2020/12/6.
//

import SwiftUI
import JWStatusHUD

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            InputField.mail(text: $viewModel.mail)
            InputField.password(text: $viewModel.password)
            
            Button(LocalizedString.login) {
                viewModel.login()
            }
            .disabled(!viewModel.loginButtonEnabled)
        }
        .padding()
        .statusHUD(item: $viewModel.statusHUDItem)
        .alert(item: $viewModel.alertItem, content: Alert.init)
        .fullScreenCover(isPresented: $viewModel.loginSucceeded, content: CompanyListView.init)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
