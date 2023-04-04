//
//  Dependency.swift
//  
//
//  Created by Bakr mohamed on 04/04/2023.
//

/*
 This file defines a Dependency property wrapper and a DependencyValues class that stores values for all dependencies.

 The Dependency property wrapper allows you to declare properties that depend on other values. It has a generic parameter Value that specifies the type of the dependency value, and a key path keyPath that specifies where to find the dependency value in the DependencyValues object.

 The Dependency property wrapper also has optional parameters file, fileID, and line that specify the location where the property wrapper was declared. These parameters are used for debugging purposes.

 The wrappedValue property of the Dependency property wrapper returns the current value of the dependency. If the app is running in DEBUG mode, it sets the current dependency to the current DependencyValues object and returns the value of the dependency from that object. If the app is not running in DEBUG mode, it returns the value of the dependency directly from the DependencyValues._current dictionary.

 The DependencyValues class stores values for all dependencies. It has a static variable _current that is a dictionary of all dependency values for the current context. It also has a static computed property currentDependency that returns the current DependencyValues object for the current context. If the DependencyValues object for the current context doesn't exist, it creates a new one and adds it to the _current dictionary.

 The DependencyValues class also has a values dictionary that stores values for all dependencies. It has a subscript that takes a KeyPath and returns the value for that key path. It also has a value(forKey:) method that takes a KeyPath and returns the value for that key path. If the value doesn't exist for the key path, it throws a fatal error.

 The DependencyValues class also has three instance variables file, fileID, and line that are used for debugging purposes.
 */

import SwiftUI

@propertyWrapper
public struct Dependency<Value>: @unchecked Sendable {
    private let keyPath: KeyPath<DependencyValues, Value>
    private let file: StaticString
    private let fileID: StaticString
    private let line: UInt

    /// Creates a dependency property to read the specified key path.
    ///
    /// Don't call this initializer directly. Instead, declare a property with the `Dependency`
    /// property wrapper, and provide the key path of the dependency value that the property should
    /// reflect:
    ///
    /// ```swift
    /// final class FeatureModel: ObservableObject {
    ///   @Dependency(\.date) var date
    ///
    ///   // ...
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path to a specific resulting value.
    ///   - file: The file name where the property wrapper is declared. Default is the file that
    ///           contains the call site of the property wrapper.
    ///   - fileID: The identifier of the file where the property wrapper is declared. Default is
    ///             the identifier of the file that contains the call site of the property wrapper.
    ///   - line: The line number where the property wrapper is declared. Default is the line
    ///           number of the call site of the property wrapper.
    public init(
        _ keyPath: KeyPath<DependencyValues, Value>,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        self.keyPath = keyPath
        self.file = file
        self.fileID = fileID
        self.line = line
    }

    /// The current value of the dependency property.
    public var wrappedValue: Value {
        #if DEBUG
        let currentDependency = DependencyValues.currentDependency
        currentDependency.file = self.file
        currentDependency.fileID = self.fileID
        currentDependency.line = self.line
        return withUnsafeMutablePointer(to: &DependencyValues.currentDependency) { currentDependencyPtr in
            currentDependencyPtr.withMemoryRebound(to: DependencyValues?.self, capacity: 1) { currentDependencyOptionalPtr in
                currentDependencyOptionalPtr.pointee = currentDependency
                defer { currentDependencyOptionalPtr.pointee = nil }
                guard let value = DependencyValues._current[ObjectIdentifier(DependencyValues.self)] as? DependencyValues else {
                    fatalError("Current dependency values not found")
                }
                return value[keyPath: self.keyPath]
            }
        }
        #else
        return DependencyValues._current[keyPath: self.keyPath]
        #endif
    }

}



public final class DependencyValues {
    static var _current: [ObjectIdentifier: Any] = [:]

    static var currentDependency: DependencyValues {
        get {
            guard let dependency = _current[ObjectIdentifier(self)] as? DependencyValues else {
                let newDependency = DependencyValues()
                _current[ObjectIdentifier(self)] = newDependency
                return newDependency
            }
            return dependency
        }
        set {
            _current[ObjectIdentifier(self)] = newValue
        }
    }

    var file: StaticString = ""
    var fileID: StaticString = ""
    var line: UInt = 0

    public var values: [ObjectIdentifier: Any] = [:]

    fileprivate func value<T>(forKey key: KeyPath<DependencyValues, T>) -> T {
        guard let value = values[ObjectIdentifier(key)] as? T else {
            fatalError("Dependency value not set for key path \(key)")
        }
        return value
    }

    subscript<T>(key: KeyPath<DependencyValues, T>) -> T {
        get {
            return value(forKey: key)
        }
        set {
            values[ObjectIdentifier(key)] = newValue
        }
    }
}

