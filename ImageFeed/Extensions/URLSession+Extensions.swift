//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 04.07.2025.
//

import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
    -> URLSessionTask {
        return data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder(strategy: .convertFromSnakeCase).decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    if let decodingError = error as? DecodingError {
                        print("decoding error: \(decodingError), data: \(String(data: data, encoding: .utf8) ?? "")")
                    } else {
                        print("decoding error: \(error.localizedDescription), data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                print("request error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func data(for request: URLRequest,
              completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print(NetworkError.httpStatusCode(statusCode))
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error))
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print(NetworkError.urlSessionError)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
