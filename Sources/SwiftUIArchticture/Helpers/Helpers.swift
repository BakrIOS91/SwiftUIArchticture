//
//  Helpers.swift


import SwiftUI

public struct Helpers {
    static let shared = Helpers()
    
    func wait(_ duration: Double = 2, _ action: @escaping(() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: action)
    }
    
}
