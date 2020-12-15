//
//  StatusHUD.swift
//  APPOS
//
//  Created by Jay on 2020/12/14.
//

import SwiftUI

struct StatusHUD: View {
    let item: StatusHUDItem
    
    var body: some View {
        Group {
            switch item.type {
            case .loading:
                if let message = item.message {
                    ProgressView(message)
                } else {
                    ProgressView()
                }
            case .success:
                getStatusView(imageName: "checkmark", message: item.message)
            case .failure:
                getStatusView(imageName: "xmark", message: item.message)
            }
        }
        .padding()
        .background(Color.secondary.colorInvert())
        .foregroundColor(.primary)
        .cornerRadius(16)
    }
}

// MARK: - Private functions
private extension StatusHUD {
    
    func getStatusView(imageName: String, message: String?) -> some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .font(.largeTitle)
            
            if let message = message {
                Text(message)
            }
        }
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static let item: StatusHUDItem = StatusHUDItem(type: .loading, message: "Loading")
    
    static var previews: some View {
        StatusHUD(item: item)
    }
}
