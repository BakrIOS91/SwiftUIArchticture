//
//  Helpers.swift


import SwiftUI

public struct Helpers {
    public static let shared = Helpers()
    
    public func wait(_ duration: Double = 2, _ action: @escaping(() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: action)
    }
    
}
