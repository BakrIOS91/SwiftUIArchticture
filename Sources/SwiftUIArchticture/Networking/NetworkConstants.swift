//
//  NetworkConstants.swift
//  

import Foundation

var kAppEnvironment: AppEnvironment = .staging

// MARK: - kBaseURLComponents
var kBaseURLComponents: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = kScheme
    urlComponents.host = kHost
    if kPort != nil {
        urlComponents.port = kPort
    }
    return urlComponents
}

// MARK: - kBaseURL
var kBaseURL: String = ""

// MARK: - kScheme
var kScheme: String = ""

// MARK: - kHost
var kHost: String = ""

// MARK: - kPort
var kPort: Int? = nil


// MARK: - all requests key parameters
struct KeyParameters {
    static let contentTypeKey = "Content-Type"
    static let accept = "Accept"
    static let applicationJson = "application/json"
}

var isInPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
