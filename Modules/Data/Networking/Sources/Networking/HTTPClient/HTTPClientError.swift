//
//  HTTPClientError.swift
//  Networking
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation


public enum HTTPClientError: LocalizedError {
    case invalidServerResponse
    case internalError
    case unsupportedResponse
    case timeout
    case internetConnectivity
    case unknown
    case notFound

    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse: "invalid server response"
        case .internalError: "API server internal error"
        case .unsupportedResponse: "unsupported response"
        case .timeout: "timeout"
        case .internetConnectivity: "internet connectivity error"
        case .unknown: "unknown error"
        case .notFound: "ToDo not found"
        }
    }
}
