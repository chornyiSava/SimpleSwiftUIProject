//
//  NetworkManager.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import Foundation

enum DownloadError: Error {
    case badURL
    case badHTTPResponse
}

protocol NetworkManagerProtocol {
    func downloadImage(with stringURL: String) async throws -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Private Variables
    let urlSession: URLSession
    
    // MARK: - Init
    init() {
        urlSession = URLSession.shared
    }
    
    // MARK: - Logic
    func downloadImage(with stringURL: String) async throws -> Data {
        guard let imageURL = URL(string: stringURL) else { throw DownloadError.badURL }

        let request = URLRequest(
            url: imageURL,
            cachePolicy: .reloadIgnoringCacheData
        )
            
        let (data, response) = try await urlSession.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw DownloadError.badHTTPResponse
        }
        
        return data
    }
    
}
