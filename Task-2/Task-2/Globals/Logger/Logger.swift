//
//  Logger.swift
//  Task-1
//
//  Created by Vasu Chovatiya on 30/11/23.
//

import Foundation




func DLog(_ items: Any?..., function: String = #function, file: String = #file, line: Int = #line) {
    if Application.debug {
        print("-----------START-------------")
        let url = NSURL(fileURLWithPath: file)
        print("Message = ", items, "\n\n(File: ", url.lastPathComponent ?? "nil", ", Function: ", function, ", Line: ", line, ")")
        print("-----------END-------------\n")
    }
}

