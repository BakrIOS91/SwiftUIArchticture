//
//  BaseViewModel.swift
//  SwiftUIStructure
//
//  Created by Bakr mohamed on 20/03/2023.
//

import SwiftUI

public protocol BaseViewModelProtocol: ObservableObject {
    
    associatedtype State
    associatedtype Action
    
    func trigger(_ action: Action)
}

public class BaseViewModel<State, Action>: BaseViewModelProtocol {
    @Published var state: State

    init(state: State) {
        self.state = state
    }
    
    public func trigger(_ action: Action) {
        // Should be override by child class
    }
}
