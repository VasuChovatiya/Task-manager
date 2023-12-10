//
//  View+Extension.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 03/12/23.
//

import Foundation
import Combine
import SwiftUI

extension View {
    
    //MARK: - Functions
    
    func getScreenRect() -> CGRect {
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main!.visibleFrame //* 0.70
        #endif
    }
    
    
    func hideKeyBoard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
//    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
//        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
//    }
//    
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
//    func getSafeAreaInset()() ->  UIEdgeInsets? {
//        UIApplication.shared.windows.first?.getSafeAreaInset()s
//
//    }

    
//    func customPopupView<PopupView>(isPresented: Binding<Bool>, popupView: @escaping () -> PopupView, backgroundColor: Color = .Black.opacity(0.7), animation: Animation? = .default) -> some View where PopupView: View {
//           return CustomPopupViewModifier(isPresented: isPresented, content: { self }, popupView: popupView, backgroundColor: backgroundColor, animation: animation)
//       }
    
    func showSettingAlert(isPresented: Binding<Bool>) -> some View {
        self.alert("Setting", isPresented: isPresented) {
            Button("Cancle", role: .cancel) {
                
            }
            
            
            Button("Setting", role: .none) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            
            
            
        } message: {
            Text("Please Provide to receive notifications for your tasks")
        }

    }
    
    
    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
      if #available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *) {
        self.onChange(of: value, perform: onChange)
      } else {
        self.onReceive(Just(value)) { value in
          onChange(value)
        }
      }
    }
    
}
