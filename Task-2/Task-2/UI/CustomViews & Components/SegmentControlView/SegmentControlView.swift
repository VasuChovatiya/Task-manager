//
//  SegmentControlView.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 03/12/23.
//

import Foundation
import SwiftUI

struct SegmentControlView<ID: Identifiable, Content: View, Background: Shape>: View {
    let segments: [ID]
    @Binding var selected: ID
    var titleNormalColor: Color
    var titleSelectedColor: Color
    var selectedBgColor: Color
    var bgColor: Color
    let animation: Animation
    @ViewBuilder var content: (ID) -> Content
    @ViewBuilder var background: () -> Background
    
    @Namespace private var namespace
    
    var body: some View {
        GeometryReader { bounds in
            HStack(spacing: 0) {
                ForEach(segments ,id: \.id) { segment in
                    NewSegmentButtonView(id: segment,
                                         selectedId: $selected,
                                         titleNormalColor: titleNormalColor,
                                         titleSelectedColor: titleSelectedColor,
                                         selctedBgColor: selectedBgColor,
                                         animation: animation,
                                         namespace: namespace) {
                        content(segment)
                    } background: {
                        background()
                           
                    }
                    .frame(width: bounds.size.width / CGFloat(segments.count))
                }
            }
            .background {
                background()
                    .fill(bgColor)
//                    .overlay(
//                        background()
//                            .stroke(style: StrokeStyle(lineWidth: 1.5))
//                            .foregroundColor(bgColor.opacity(0.2))
//                    )
            }
        }
    }
}

fileprivate struct NewSegmentButtonView<ID: Identifiable, Content: View, Background: Shape> : View {
    let id: ID
    @Binding var selectedId: ID
    var titleNormalColor: Color
    var titleSelectedColor: Color
    var selctedBgColor: Color
    var animation: Animation
    var namespace: Namespace.ID
    @ViewBuilder var content: () -> Content
    @ViewBuilder var background: () -> Background
    
    
    var body: some View {
        GeometryReader { bounds in
            Button {
                withAnimation(animation) {
                    selectedId = id
                }
            } label: {
                content()
            }
            .frame(width: bounds.size.width, height: bounds.size.height)
//            .scaleEffect(selectedId.id == id.id ? 1 : 0.8)
            .clipShape(background())
            .foregroundColor(selectedId.id == id.id ? titleSelectedColor : titleNormalColor)
            .background(buttonBackground)
        }
    }
    
    @ViewBuilder private var buttonBackground: some View {
        if selectedId.id == id.id {
            background()
                .fill(selctedBgColor)
                .padding(4)
                .matchedGeometryEffect(id: "SelectedTab", in: namespace)
        }
    }
}

