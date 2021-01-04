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
    
    func visible(_ visible: Bool) -> some View {
        if visible {
            return self
                .eraseToAnyView()
        } else {
            return EmptyView()
                .eraseToAnyView()
        }
    }
    
}
