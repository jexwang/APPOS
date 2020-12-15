//
//  View+Extension.swift
//  APPOS
//
//  Created by Jay on 2020/12/14.
//

import SwiftUI

extension View {
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func statusHUD(item: Binding<StatusHUDItem?>) -> some View {
        if let dismissTimeInterval = item.wrappedValue?.dismissAfter {
            Timer.scheduledTimer(withTimeInterval: dismissTimeInterval, repeats: false) { (_) in
                item.wrappedValue?.completion?()
                item.wrappedValue = nil
            }
        }
        
        return ZStack {
            self
                .disabled(item.wrappedValue != nil)
                .blur(radius: item.wrappedValue != nil ? 3 : 0)
            
            if let item = item.wrappedValue {
                StatusHUD(item: item)
            }
        }
    }
    
}
