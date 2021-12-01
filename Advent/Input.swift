//
//  Input.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2021.
//

import Foundation
import Combine

fileprivate let session: URLSession  = {
    let config = URLSessionConfiguration.default
    config.httpCookieAcceptPolicy = .always
    return URLSession(configuration: config)
}()

extension Puzzle {
    
    public func getInput() -> AnyPublisher<String, Error> {
        return getPuzzleInput()
            .catch(login)
            .receive(on: DispatchQueue.main, options: nil)
            .eraseToAnyPublisher()
    }
    
    private func getPuzzleInput() -> AnyPublisher<String, Error> {
        let dayNr = Int(rawValue.replacingOccurrences(of: ["day", "a", "b"], with: "")) ?? 0
        let urlString = "https://adventofcode.com/2021/day/\(dayNr)/input"
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.invalidUrl).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .tryMap(validateResponse)
            .eraseToAnyPublisher()
    }
    
    private func validateResponse(_ data: Data, response: URLResponse) throws -> String {
        guard let httpResponse = response as? HTTPURLResponse else { throw ApiError.emptyResponse }
        guard (200..<300).contains(httpResponse.statusCode) else { throw ApiError.httpError(httpResponse.statusCode) }
        guard let plain = String(data: data, encoding: .utf8) else { throw ApiError.malformedResponse }
        return plain
    }
    
    private func login(_ error: Error) -> AnyPublisher<String, Error> {
        guard case let ApiError.httpError(code) = error, code == 400 else {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return AuthController.show()
            .flatMap(getSessionCookie)
            .flatMap(getPuzzleInput)
            .eraseToAnyPublisher()
    }
    
    private func getSessionCookie(_ code: String) -> AnyPublisher<Void, Error> {
        let urlString = "https://adventofcode.com/auth/github/callback?code=\(code)"
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.invalidUrl).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .tryMap(validateResponse)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension String {
    func replacingOccurrences(of arr: [String], with string: String) -> String {
        var output = self
        arr.forEach { output = output.replacingOccurrences(of: $0, with: string) }
        return output
    }
}

enum ApiError: LocalizedError {
    case invalidUrl
    case emptyResponse
    case httpError(_ statusCode: Int)
    case malformedResponse
}


