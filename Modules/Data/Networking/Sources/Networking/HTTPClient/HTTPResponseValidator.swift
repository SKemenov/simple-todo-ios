//
//  HTTPResponseValidator.swift
//  Networking
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

struct HTTPResponseValidator {
    func validate(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.unsupportedResponse
        }
        let error: HTTPClientError?
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 404:
            error = .notFound
        case 400...499:
            error = .invalidServerResponse
        case 500...511:
            error = .internalError
        default:
            error = .unknown
        }

        if let error {
            throw error
        } else {
            return data
        }
    }

    func validateURLError(error: URLError) throws -> Never {
        switch error.code {
        case .notConnectedToInternet, .cannotConnectToHost, .networkConnectionLost:
            throw HTTPClientError.internetConnectivity
        case .timedOut, .cannotFindHost:
            throw HTTPClientError.timeout
        default:
            throw HTTPClientError.unknown
        }
    }
}
