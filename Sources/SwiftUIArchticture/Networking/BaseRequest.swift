//
//  BaseRequest.swift
//  

import Foundation

public typealias Parameters = [String:Any]
public typealias MultipartAttachment = (fileName: String, url: URL?, data: Data?)

public protocol BaseRequestProtocol {
    //Request
    var host: String { get }
    var apiPath: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var baseHeaders : [String: String] { get }
    var requestTimeOut: Float { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    //Request Response
    associatedtype Response: Codable
    var mockResponse: Response { get set }
    
}

public extension BaseRequestProtocol {
    var host: String {return kBaseURL}
    var apiPath: String { return ""}
    var headers: [String: String] { return [:] }
    var baseHeaders : [String:String] { return defaultHeaders }
    var requestTimeOut: Float { return 30 }
    var httpMethod: HTTPMethod { return .GET }
    var parameters: Parameters? { return [:] }
}

public extension BaseRequestProtocol {
    var requestURL : String {
        return kBaseURL + apiPath + path
    }
    
    var defaultHeaders: [String: String] {
        var baseHeaders = [
            KeyParameters.contentTypeKey: KeyParameters.applicationJson,
            KeyParameters.accept: KeyParameters.applicationJson,
        ].compactMapValues{$0}
        baseHeaders += headers
        return baseHeaders
    }
}




public protocol MultipartRequestProtocol: BaseRequestProtocol {
    var attachments: [MultipartAttachment] { get }
}
