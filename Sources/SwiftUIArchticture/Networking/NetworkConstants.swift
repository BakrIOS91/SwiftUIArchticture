//
//  NetworkConstants.swift
//  

import Foundation

public var kAppEnvironment: AppEnvironment = .staging

// MARK: - kBaseURLComponents
public var kBaseURLComponents: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = kScheme
    urlComponents.host = kHost
    if kPort != nil {
        urlComponents.port = kPort
    }
    return urlComponents
}

// MARK: - kBaseURL
public var kBaseURL: String = ""

// MARK: - kScheme
public var kScheme: String = ""

// MARK: - kHost
public var kHost: String = ""

// MARK: - kPort
public var kPort: Int? = nil

public var isInPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

// MARK: - all requests key parameters
public struct KeyParameters {
    static let contentTypeKey = "Content-Type"
    static let accept = "Accept"
    static let applicationJson = "application/json"
}


