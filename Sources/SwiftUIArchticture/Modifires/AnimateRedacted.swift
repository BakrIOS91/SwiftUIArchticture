//
//  AnimateRedacted.swift
//  
//
//  Created by Bakr mohamed on 05/04/2023.
//

import SwiftUI

public struct AnimateRedacted: AnimatableModifier {
    @State private var isAnim: Bool = false
    private var center = (UIScreen.main.bounds.width / 2) + 110
    private let animation: Animation = .linear(duration: 1)

    public func body(content: Content) -> some View {
        content.overlay(animView.mask(content))
    }

    var animView: some View {
        ZStack {
            Color.black.opacity(0.09)
            Color.white.mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [.clear, .white, .clear]), startPoint: .top , endPoint: .bottom)
                    )
                    .scaleEffect(1.5)
                    .rotationEffect(.init(degrees: 70.0))
                    .offset(x: isAnim ? center : -center)
            )
        }
        .animation(animation.repeatForever(autoreverses: false), value: isAnim)
        .onAppear {
            isAnim.toggle()
        }
    }
}

