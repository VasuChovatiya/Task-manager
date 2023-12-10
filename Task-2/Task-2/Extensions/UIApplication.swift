//
//  UIApplication.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 03/12/23.
//

import UIKit

extension UIApplication {

    var keyWindow: UIWindow? {
        connectedScenes
//            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .filter { $0.isKeyWindow }
            .first
    }
}
