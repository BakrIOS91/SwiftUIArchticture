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

open class BaseViewModel<State, Action>: BaseViewModelProtocol {
    @Published public var state: State

    public init(state: State) {
        self.state = state
    }
    
    open func trigger(_ action: Action) {
        // Should be override by child class
    }
}
