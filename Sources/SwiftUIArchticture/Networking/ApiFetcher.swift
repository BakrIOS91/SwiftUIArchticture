//
//  ApiFetcher.swift
//

import Foundation

public protocol Fetcher {
    @discardableResult
    func fetch<Request> (request: Request) async -> Result<Request.Response, NetworkError> where Request : BaseRequestProtocol
}


public final class APIFetcher: Fetcher {
    static let shared = APIFetcher()

    public func fetch<Request> (request: Request) async -> Result<Request.Response, NetworkError> where Request : BaseRequestProtocol {
        if isInPreview {
            return .success(request.mockResponse)
        } else {
            let decoder = JSONDecoder()
            //SessionConfiguration
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeOut)
            //Handel URL
            guard let url =  URL(string: request.requestURL) else { return.failure(.badURL("Invalid Url")) }
            requestLogger(request: request)
            //Request
            let urlRequest = generateUrlRequest(url: url, request: request)
            // response
            guard let (data, response) = try? await URLSession.shared.data(for: urlRequest) else { return .failure(.noData)}
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.nonHTTPResponse)
            }
            
            switch HTTPStatusCode(rawValue: response.statusCode) {
            case .information, .success :
                guard let decodedResponse = try? decoder.decode(Request.Response.self, from: data) else {
                    let error = NetworkError.decodingError("Decoding Error")
                    responseLogger(request: request, error: error)
                    return .failure(error)
                }
                responseLogger(request: request, responseData: data, response: response)
                return.success(decodedResponse)
            case .clientError:
                let error = NetworkError.unauthorized(code: 401, error: "Unauthorised")
                responseLogger(request: request, error: error)
                return .failure(error)
            default:
                let error = NetworkError.serverError(code: response.statusCode, error: "Server Error")
                responseLogger(request: request, error: error)
                return .failure(error)
                
            }
        }
    }
        
    
    fileprivate func generateUrlRequest(url: URL, request: any BaseRequestProtocol) -> URLRequest {
        var urlRequest: URLRequest
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.defaultHeaders
        
        switch request.httpMethod {
        case .GET:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let params = request.parameters, !params.isEmpty {
                urlComponents?.queryItems = params.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
            }
            urlRequest.url = urlComponents?.url ?? url
            
        default:
            if let params = request.parameters?.jsonData {
                urlRequest.httpBody = params
            }
        }
        
        return urlRequest
    }
    
    
    /// Use this to check about internet connection
    static var isConnectedToInternet: Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    private func requestLogger(request: any BaseRequestProtocol) {
        print("\n📤 Will send request", request.httpMethod.rawValue, ":", request.requestURL)
        print("\n🏷 Headers:")
        for (headerKey, headerValue) in request.baseHeaders {
            print(headerKey, ":", headerValue)
        }
    }
    
    private func responseLogger(request: any BaseRequestProtocol, responseData: Data? = nil ,response: HTTPURLResponse? = nil, error: NetworkError? = nil) {
        if let error = error {
            print("\n❌ Request", request.httpMethod.rawValue, ":", request.requestURL, error)
        }
        
        if let response = response {
            let status = (200..<300) ~= response.statusCode ? "✅" : "⚠️"
            print("\n",status, "Did receive response", response.statusCode, ":", "for request", request.requestURL)
            if let responseDataString = responseData?.prettyPrintedJSONString {
                print("\nBody:\n",responseDataString)
            } else{
               print("\nBody: Empty...")
            }
        }
    }
}

public protocol InternetConnectionChecker {
    func isConnectedToInternet() -> Bool
}

public extension InternetConnectionChecker {
    func isConnectedToInternet() -> Bool {
        return APIFetcher.isConnectedToInternet
    }
}
