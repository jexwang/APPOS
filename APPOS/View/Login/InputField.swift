//
//  InputField.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/10.
//

import SwiftUI

struct InputField: View {
    let imageSystemName: String?
    let title: String
    @Binding var inputText: String
    let isSecureTextEntry: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                if let imageSystemName = imageSystemName {
                    Image(systemName: imageSystemName)
                        .foregroundColor(.gray)
                        .frame(width: 24)
                }
                
                if isSecureTextEntry {
                    SecureField(title, text: $inputText)
                } else {
                    TextField(title, text: $inputText)
                }
            }
            Divider()
        }
    }
}

// MARK: - Internal functions
extension InputField {
    
    static func mail(inputText: Binding<String>) -> InputField {
        InputField(imageSystemName: "envelope", title: LocalizedString.mail, inputText: inputText, isSecureTextEntry: false)
    }
    
    static func password(inputText: Binding<String>) -> InputField {
        InputField(imageSystemName: "lock", title: LocalizedString.password, inputText: inputText, isSecureTextEntry: true)
    }
    
}

struct InputField_Previews: PreviewProvider {
    @State static var inputText: String = ""
    
    static var previews: some View {
        InputField(imageSystemName: "lock", title: "Password", inputText: $inputText, isSecureTextEntry: false)
    }
}
