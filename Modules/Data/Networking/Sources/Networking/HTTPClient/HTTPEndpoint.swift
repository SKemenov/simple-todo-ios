//
//  HTTPEndpoint.swift
//  Networking
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

typealias Headers = [String: String]

enum HTTPEndpoint {
    case fetchAllToDos
    case fetchToDos(skip: Int)
    case fetchToDo(id: Int)
    case createToDo
    case updateToDo(id: Int)
    case deleteToDo(id: Int)

}

extension HTTPEndpoint {
    var apiURL: String { "https://dummyjson.com/" }

    var path: String {
        switch self {
        case .fetchToDos, .fetchAllToDos: "todos"
        case .createToDo: "todos/add"
        case let .fetchToDo(id): "todos/\(id)"
        case let .deleteToDo(id): "todos/\(id)"
        case let .updateToDo(id): "todos/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchToDos, .fetchAllToDos, .fetchToDo: .get
        case .createToDo: .post
        case .updateToDo: .patch
        case .deleteToDo: .delete
        }
    }

    var headers: Headers? {
        let jsonHeader: Headers = ["Content-Type": "application/json"]
        return jsonHeader
    }

    var query: [String: String]? {
        switch self {
        case .fetchToDos(let skip):
            ["skip": String(skip)]
        case .fetchAllToDos:
            ["limit": String(0)]
        default: nil
        }
    }
}

enum HTTPMethod: String {
    case post = "POST"
    case patch = "PUT"
    case delete = "DELETE"
    case get = "GET"
}
