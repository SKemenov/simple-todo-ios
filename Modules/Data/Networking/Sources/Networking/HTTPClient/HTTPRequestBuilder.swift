//
//  HTTPRequestBuilder.swift
//  Networking
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

final class HTTPRequestBuilder {
    private var apiURL: String
    private var path: String
    private var method: HTTPMethod
    private var headers: Headers?
    private var query: [String: String]?
    private var rawBody: Data?

    init(endpoint: HTTPEndpoint) {
        apiURL = endpoint.apiURL
        path = endpoint.path
        method = endpoint.method
        headers = endpoint.headers
        query = endpoint.query
    }

    func build() throws -> URLRequest {
        guard
            let url = URL(string: apiURL),
            let baseURL = URL(string: path, relativeTo: url)
        else { throw RequestBuilderError.badURL }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        if let query, !query.isEmpty {
            components?.queryItems = query.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }

        guard let finalURL = components?.url else {
            throw RequestBuilderError.badURL
        }

        var request = URLRequest(url: finalURL)

        request.httpMethod = method.rawValue

        if let headers, !headers.isEmpty {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let rawBody {
            request.httpBody = rawBody
        }

        return request
    }

    func with(body: Data) -> Self {
        self.rawBody = body
        return self
    }
}

enum RequestBuilderError: LocalizedError {
    case badURL

    var errorDescription: String? {
        switch self {
        case .badURL: "invalid URL"
        }
    }
}
