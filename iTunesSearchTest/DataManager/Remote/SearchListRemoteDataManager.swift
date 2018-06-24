//
//  SearchListRemoteDataManager.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/23/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

class SearchListRemoteDataManager: SearchListRemoteDataManagerInputProtocol {
    
    // MARK: - Computed Properties
    private var baseURL: String {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        guard let urlString = dictionary["base_url"] as? String else {
            fatalError()
        }
        return urlString
    }
    // MARK: - Stored Properties
    var remoteRequestHandler: SearchListRemoteDataManagerOutputProtocol?
    internal let session = URLSession.shared
    
    func retrieveResultsList(withSearchTerm term: String) {
        let expectedCharSet = NSCharacterSet.urlQueryAllowed
        let searchTerm = term.addingPercentEncoding(withAllowedCharacters: expectedCharSet)
        guard let search = searchTerm else {
            remoteRequestHandler?.onError(error: .invalidQuery)
            return
        }
        var components = URLComponents(string: self.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "term", value: search)
        ]
        guard let url = components?.url else {
            remoteRequestHandler?.onError(error: .invalidURL)
            return
        }
        let task = session.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
            let decoder = JSONDecoder()
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data,
                let trackList = try? decoder.decode(TrackList.self, from: data)  else {
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async {
                        if let error = error {
                            strongSelf.remoteRequestHandler?.onError(error: NetworkError(error: error))
                        } else {
                            strongSelf.remoteRequestHandler?.onError(error: NetworkError(response: response))
                        }
                    }
                    return
            }
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.remoteRequestHandler?.onResutlsRetrieved(withTracks: trackList.results)
            }
        })
        task.resume()
    }
}
