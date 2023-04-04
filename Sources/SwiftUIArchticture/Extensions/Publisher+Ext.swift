//
//  File.swift
//  
//
//  Created by Bakr mohamed on 04/04/2023.
//

import Combine

public extension Publisher {
    func mapToVoid() -> Publishers.Map<Self, Void> {
        map { _ in }
    }
}
