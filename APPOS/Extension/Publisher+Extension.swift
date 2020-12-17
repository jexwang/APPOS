//
//  Publisher+Extension.swift
//  APPOS
//
//  Created by Jay on 2020/12/17.
//

import Foundation
import Combine

extension Publisher {
    
    func receiveOnMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        Publishers.ReceiveOn(upstream: self, scheduler: DispatchQueue.main, options: nil)
    }
    
}
