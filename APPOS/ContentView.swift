//
//  ContentView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/6.
//

import SwiftUI

struct ContentView: View {
    @State var item: StatusHUDItem?
    
    var body: some View {
        Button(action: {
            item = StatusHUDItem(type: .loading, message: "Loading")
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                item = StatusHUDItem(type: .success, message: "Success", dismissAfter: 3)
            }
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        .background(Color.green)
        .statusHUD(item: $item)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
