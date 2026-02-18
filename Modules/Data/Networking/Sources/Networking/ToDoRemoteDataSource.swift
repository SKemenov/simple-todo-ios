//
//  ToDoRemoteDataSource.swift
//  Networking
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation
import DataInterface
import Utilities
import Logging

public final class ToDoRemoteDataSource: ToDoRemoteDataSourceProtocol {
    private let responseValidator = HTTPResponseValidator()

    public init() {
        Logger.network.info("\(Current.logHeader()) Started")
    }
    
    public func fetchAllToDos() async throws -> DTOModel.ToDos {
        let request = try buildRequest(for: .fetchAllToDos)
        let responseData = try await sendRequest(request)
        let model = try Current.decoder.decode(DTOModel.ToDos.self, from: responseData)
        Logger.network.info(
            "\(Current.logHeader()) Get \(model.todos.count) records, last model id \(model.todos.last?.id ?? -1)"
        )
        return model
    }

    public func fetchToDos(page: Int) async throws -> DTOModel.ToDos {
        let skip = page * 30
        let request = try buildRequest(for: .fetchToDos(skip: skip))
        let responseData = try await sendRequest(request)
        let model = try Current.decoder.decode(DTOModel.ToDos.self, from: responseData)
        Logger.network.info(
            "\(Current.logHeader()) Get \(model.todos.count) records, last model id \(model.todos.last?.id ?? -1)"
        )
        return model
    }

    public func fetchToDo(id: Int) async throws -> DTOModel.ToDo {
        let request = try buildRequest(for: .fetchToDo(id: id))
        let responseData = try await sendRequest(request)
        let model = try Current.decoder.decode(DTOModel.ToDo.self, from: responseData)
        Logger.network.info("\(Current.logHeader()) Get todo with id \(id): [\(model)]")
        return model
    }

    public func createToDo(_ dto: DTOModel.ToDo) async throws -> DTOModel.ToDo {
        let rawBody = try Current.encoder.encode(dto)
        let request = try buildRequest(with: rawBody, for: .createToDo)
        let responseData = try await sendRequest(request)
        let model = try Current.decoder.decode(DTOModel.ToDo.self, from: responseData)
        Logger.network.info("\(Current.logHeader()) Created: [\(model)]")
        return model
    }

    public func updateToDo(_ dto: DTOModel.ToDo) async throws -> DTOModel.ToDo {
        let dtoForUpdate = DTOModel.UpdateToDo(todo: dto.todo, completed: dto.completed)
        let rawBody = try Current.encoder.encode(dtoForUpdate)
        let request = try buildRequest(with: rawBody, for: .updateToDo(id: dto.id))
        let responseData = try await sendRequest(request)
        let model = try Current.decoder.decode(DTOModel.ToDo.self, from: responseData)
        Logger.network.info("\(Current.logHeader()) Updated: [\(model)]")
        return model
    }

    public func deleteToDo(id: Int) async throws {
        let request = try buildRequest(for: .deleteToDo(id: id))
        let _ = try await sendRequest(request)
        Logger.network.info("\(Current.logHeader()) Deleted toDo with id: [\(id)]")
    }

    func buildRequest(with body: Data? = nil, for endpoint: HTTPEndpoint) throws -> URLRequest {
        return if let body {
            try HTTPRequestBuilder(endpoint: endpoint)
                .with(body: body)
                .build()
        } else {
            try HTTPRequestBuilder(endpoint: endpoint)
                .build()
        }
    }

    @discardableResult
    func sendRequest(_ request: URLRequest) async throws -> Data {
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            return try responseValidator.validate(data: responseData, response: response)
        } catch let error as URLError {
            try responseValidator.validateURLError(error: error)
        } catch {
            throw HTTPClientError.unsupportedResponse
        }
    }
}
