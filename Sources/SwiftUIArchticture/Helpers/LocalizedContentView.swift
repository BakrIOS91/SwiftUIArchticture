//
//  LocalizedContentView.swift
//  

import SwiftUI
public struct LocalizedContentView<Content: View>: View {
    
    @State var locale: Locale? = .bestMatching
    
    var content: () -> Content
    
    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .if(let: locale) { $0.locale($1) }
    }
}
