//
//  Prefrances.swift
//  PhotoApp
//
//  Created by Bakr mohamed on 05/04/2023.
//

import SwiftUI
import Combine

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences = .shared
    
    public init(
        _ keyPath: ReferenceWritableKeyPath<Preferences, Value>
    ) {
        self.keyPath = keyPath
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }
            .mapToVoid()
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }
    
    public var wrappedValue: Value {
        get {
            preferences[keyPath: keyPath]
        }
        nonmutating set {
            preferences[keyPath: keyPath] = newValue
            preferences.preferencesChangedSubject.send(keyPath)
        }
    }
    
    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

final class Preferences {
    
    static let shared = Preferences()
    private init() {}
    
    /// Sends through the changed key path whenever a change occurs.
    fileprivate var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    @UserDefault("Language")
    var locale: Locale? = .bestMatching
}

