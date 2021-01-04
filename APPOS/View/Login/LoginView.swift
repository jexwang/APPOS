//
//  LoginView.swift
//  APPOS
//
//  Created by Jay on 2020/12/6.
//

import SwiftUI
import JWStatusHUD

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
                .frame(maxHeight: 120)
            
            Picker("Roles", selection: $viewModel.roles) {
                ForEach(LoginRoles.allCases, id: \.self) {
                    Text($0.localizedString)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            VStack(spacing: 16) {
                InputField.mail(text: $viewModel.mail)
                
                InputField.password(text: $viewModel.password)
                
                InputField.uid(text: $viewModel.uid)
                    .visible(viewModel.uidInputFieldVisible)
            }
            
            Button(.login, action: viewModel.login)
                .disabled(!viewModel.loginButtonEnabled)
            
            Spacer()
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
