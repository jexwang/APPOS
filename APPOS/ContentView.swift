//
//  ContentView.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/12/6.
//

import SwiftUI

struct ContentView: View {
    @State var data: [Int] = []
    
    var body: some View {
        List(data, id: \.self) {
            Cell(data: "\($0)")
        }
        .onAppear(perform: {
            for i in 1...100 {
                data.append(i)
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
                    data[4] = Int.random(in: 1..<100)
                }
            }
        })
    }
}

struct Cell: View {
    let data: String
    
    var body: some View {
        Text(data)
    }
    
    init(data: String) {
        self.data = data
        log("init \(data)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
