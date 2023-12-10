//
//  FilledButtonStyle.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 03/12/23.
//

import Foundation


import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    
    var font: Font = .Roboto_Bold(of: 16)
    var fillColor: Color = Color.Black
    var textColor: Color = Color.Black
    var cornerRadius: CGFloat = 12
    var height: CGFloat = 56
    
    
    
    var isDisabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(isDisabled ? Color.gray : textColor.opacity(configuration.isPressed ? 0.35 : 1))
            .font(font)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                /// To chnage Color when Botton is being pressed
                    .foregroundColor(isDisabled ? fillColor.opacity(0.5) : fillColor.opacity(configuration.isPressed ? 0.35 : 1))
                    .frame(height: height)
            )
            .frame(height: height)

        }
}
