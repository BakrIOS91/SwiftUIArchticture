//
//  LocalizedContentView.swift
//  

import SwiftUI
public struct LocalizedContentView<Content: View>: View {
    
    @Preference(\.locale) var locale
    var content: () -> Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .if(let: locale) { $0.locale($1) }
    }
}
