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
            remoteRequestHandler?.onError()
            // failure(NetworkError.invalidQuery)
            return
        }
        var components = URLComponents(string: self.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "term", value: search)
        ]
        guard let url = components?.url else {
            remoteRequestHandler?.onError()
            // failure(NetworkError.invalidURL)
            return
        }
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            let decoder = JSONDecoder()
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data,
                let trackList = try? decoder.decode(TrackList.self, from: data)  else {
                    DispatchQueue.main.async {
                        if let _ = error {
                            self.remoteRequestHandler?.onError()
                            // failure(NetworkError(error: error))
                        } else {
                            self.remoteRequestHandler?.onError()
                            // failure(NetworkError(response: response))
                        }
                    }
                    return
            }
            DispatchQueue.main.async {
                self.remoteRequestHandler?.onResutlsRetrieved(withTracks: trackList.results)
                //success(trackList.results)
            }
        })
        task.resume()
    }
}
