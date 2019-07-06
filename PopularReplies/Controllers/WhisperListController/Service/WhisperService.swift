//
//  WhisperService.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import Foundation

class WhisperService: WhisperServiceProtocol {

    enum API: String {
        case replies = "replies"
        case popular = "popular"
    }

    enum Error: Swift.Error, LocalizedError {
        case invalidURL
        case invalidJSON
        case objectNoLongerInMemory

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "URL Is invalid"
            case .invalidJSON: return "Failed to parse Object from Data"
            case .objectNoLongerInMemory: return "WhisperService instance is nil"
            }
        }
    }

    enum QueryItemKeys {
        static var limit = "limit"
        static var wid = "wid"
    }

    private let baseURL: String = "http://prod.whisper.sh/whispers"

    var limit: Int = 200

    required init(limit: Int = 200) {
        self.limit = limit
    }

    func fetchWhisperList(for whisper: Whisper? = nil, completion: @escaping Callback) {
        guard var baseURL: URL = URL(string: self.baseURL) else {
            completion(.failure(Error.invalidURL))
            return
        }

        if whisper != nil {
            baseURL.appendPathComponent(API.replies.rawValue)
        } else {
            baseURL.appendPathComponent(API.popular.rawValue)
        }

        guard var urlComponents = URLComponents(string: baseURL.absoluteString) else {
            completion(.failure(Error.invalidURL))
            return
        }

        urlComponents.queryItems = [URLQueryItem]()

        let queryItemLimit: URLQueryItem = URLQueryItem(name: QueryItemKeys.limit, value: String(self.limit))

        urlComponents.queryItems?.append(queryItemLimit)

        if let wid = whisper?.wid {
            urlComponents.queryItems?.append(URLQueryItem(name: QueryItemKeys.wid, value: wid))
        }

        guard let url: URL = urlComponents.url else {
            completion(.failure(Error.invalidURL))
            return
        }

        if whisper != nil {
            self.decodeObject(ReplyList.self, from: url) { (result) in
                switch result {
                case .success(let list):
                    completion(.success(list.replies))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            self.decodeObject(PopularList.self, from: url) { (result) in
                switch result {
                case .success(let list):
                    completion(.success(list.popular))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func decodeObject<T: Codable>(_ object: T.Type, from url: URL, completion: @escaping (Result<T, Swift.Error>) -> Void) {
        URLSession.shared.invalidateAndCancel()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    do {
                        if let data = data {
                            do {
                                let decodedObject = try JSONDecoder().decode(object, from: data)
                                completion(.success(decodedObject))
                            } catch {
                                completion(.failure(error))
                            }
                        } else {
                            completion(.failure(Error.invalidJSON))
                        }
                    }
                }
            }
            }.resume()
    }
}
