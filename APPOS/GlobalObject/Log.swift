//
//  Log.swift
//  TrueYOGA
//
//  Created by Jay on 2020/10/27.
//

import Foundation

func log(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName) | \(function) | line \(line)] \(message)")
}
