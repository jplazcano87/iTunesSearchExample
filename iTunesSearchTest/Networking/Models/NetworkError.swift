//
//  NetworkError.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    
    case notAuthenticated
    case forbidden
    case notFound
    
    case networkProblem(Error)
    case unknown(HTTPURLResponse?)
    case userCancelled
    case invalidURL
    case invalidQuery
    
    public init(error: Error) {
        self = .networkProblem(error)
    }
    
    public init(response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
        case NetworkError.notAuthenticated.statusCode: self = .notAuthenticated
        case NetworkError.forbidden.statusCode: self = .forbidden
        case NetworkError.notFound.statusCode: self = .notFound
        default: self = .unknown(response)
        }
    }
    
    public var isAuthError: Bool {
        switch self {
        case .notAuthenticated: return true
        default: return false
        }
    }
    
    public var statusCode: Int {
        switch self {
        case .notAuthenticated: return 401
        case .forbidden:        return 403
        case .notFound:         return 404
            
        case .networkProblem: return 10001
        case .unknown:        return 10002
        case .userCancelled: return 9999
        case .invalidURL: return 9998
        case .invalidQuery: return 9997
        }
    }
}

// MARK: - Equatable
extension NetworkError: Equatable {
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.statusCode == rhs.statusCode
    }
}
