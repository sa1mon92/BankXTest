//
//  APIManager.swift
//  BankXTest
//
//  Created by Дмитрий Садырев on 23.11.2022.
//

import Foundation
import Combine

enum APIMethod: String {
    case getBiography = "artist.getinfo"
    case getTopTracks = "artist.gettoptracks"
}

final class APIManager {
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public func fetchBiography(for artist: String) -> AnyPublisher<BiographyModel?, Never> {
        guard let url = asoluteURL(method: .getBiography, artist: artist) else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        return fetch(from: url)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    public func fetchTopTracks(for artist: String) -> AnyPublisher<BestTracksModel?, Never> {
        guard let url = asoluteURL(method: .getTopTracks, artist: artist) else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        return fetch(from: url)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
   }

    private func asoluteURL(method: APIMethod, artist: String) -> URL? {
        guard let queryURL = URL(string: Constants.baseAPIURL),
              var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        else { return nil }
        
        urlComponents.queryItems = [URLQueryItem(name: "method", value: method.rawValue),
                                    URLQueryItem(name: "artist", value: artist),
                                    URLQueryItem(name: "api_key", value: Constants.APIKey),
                                    URLQueryItem(name: "format", value: "json"),
                                    URLQueryItem(name: "lang", value: "ru")]
        return urlComponents.url
    }
    
    
}
