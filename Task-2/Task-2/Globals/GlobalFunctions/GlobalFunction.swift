//
//  GlobalFunction.swift
//  Task-1
//
//  Created by Vasu Chovatiya on 30/11/23.
//

import Foundation
import UIKit
import SwiftUI

func delay(time: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
}

func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        print("Font Names = [\(names)]")
    }
}


func getSafeAreaInset() -> EdgeInsets {
    let keyWindow = UIApplication.shared.keyWindow
    return keyWindow?.safeAreaInsets.edgeInsets ?? EdgeInsets()
}



func currentTimeZoneString() -> String {
    TimeZone.current.abbreviation() ?? "GMT"
}

func printDocDirectory() {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    DLog(documentsPath)
}
