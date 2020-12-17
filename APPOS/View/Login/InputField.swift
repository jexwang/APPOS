//
//  InputField.swift
//  APPOS
//
//  Created by Jay on 2020/12/10.
//

import SwiftUI

struct InputField: View {
    let imageSystemName: String?
    let title: LocalizedStringKey
    @Binding var text: String
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
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            Divider()
        }
    }
}

// MARK: - Internal functions
extension InputField {
    
    static func mail(text: Binding<String>) -> InputField {
        InputField(imageSystemName: "envelope", title: .mail, text: text, isSecureTextEntry: false)
    }
    
    static func password(text: Binding<String>) -> InputField {
        InputField(imageSystemName: "lock", title: .password, text: text, isSecureTextEntry: true)
    }
    
}

struct InputField_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        InputField(imageSystemName: "lock", title: "Password", text: $text, isSecureTextEntry: false)
    }
}
