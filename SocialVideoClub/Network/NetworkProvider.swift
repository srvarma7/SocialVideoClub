//
//  NetworkProvider.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation


// MARK: - ServiceMethod


enum ServiceMethod {
    case delete
    case get
    case patch
    case post
    case put
    
    var httpMethod: String {
        switch self {
            case .delete:
                return "DELETE"
            case .get:
                return "GET"
            case .patch:
                return "PATCH"
            case .post:
                return "POST"
            case .put:
                return "PUT"
        }
    }
}


// MARK: - ServiceError


enum ServiceError: Error {
    case invalidURL
}


// MARK: - ProviderServiceType


protocol ProviderServiceType {
    var baseURL: String { get }
    var path: String? { get }
    var method: ServiceMethod { get }
    var sampleData: Data { get }
    var headers: [String: String]? { get }
}

extension ProviderServiceType {
    /// Optionals
    var sampleData: Data { Data() }
    var headers: [String: String]? { nil }
}

extension ProviderServiceType {
    func fullURL() throws -> URL {
        if let url = URL(string: baseURL + "/" + (path ?? "")) {
            return url
        } else {
            throw NSError(domain: "Invalid URL", code: 0)
        }
    }
}


// MARK: - NetworkProvider


protocol ProviderType: AnyObject {
    associatedtype Provider: ProviderServiceType
    func request(_ service: Provider, callbackQueue: DispatchQueue?) async -> Result<(Data, URLResponse), Error>
}

class NetworkProvider<Target: ProviderServiceType>: ProviderType {
    
    private let urlSession: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.urlSession = session
    }
    
    func request(_ service: Target, callbackQueue: DispatchQueue?) async -> Result<(Data, URLResponse), Error> {
        var request: URLRequest!
        
        do {
            let url = try service.fullURL()
            request = URLRequest(url: url)
            request.httpMethod = service.method.httpMethod
            request.allHTTPHeaderFields = service.headers
        } catch (let error) {
            return .failure(error)
        }
        
        do {
            let result = try await urlSession.data(for: request)
            return .success(result)
        } catch (let error) {
            return .failure(error)
        }
    }
}