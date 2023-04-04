//
//  File.swift
//  
//
//  Created by Bakr mohamed on 04/04/2023.
//

import SwiftUI

public enum ViewState: Equatable {
    case loaded
    case loading
    case noData(description: LocalizedStringKey)
    case offline(description: LocalizedStringKey)
    case serverError(description: LocalizedStringKey)
    case unexpected(description: LocalizedStringKey)
    case custom(icon: Image, title: LocalizedStringKey, description: LocalizedStringKey, retryable: Bool)
}
