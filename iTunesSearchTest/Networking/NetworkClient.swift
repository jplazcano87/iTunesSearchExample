//
//  NetworkClient.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation
import UIKit

public final class NetworkClient {
    // MARK: - Instance Properties
    internal let baseURL: URL
    internal let session = URLSession.shared
    
    // MARK: - typealias
    public typealias SuccessHandler = ([Track]) -> Void
    public typealias FailureHandler = (NetworkError) -> Void
    
    // MARK: - Class Constructors
    public static let shared: NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        guard let urlString = dictionary["base_url"] as? String else {
            fatalError()
        }
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()
    
    // MARK: - Object Lifecycle
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Request
    public func getTrackOrArtist(forTerm searchTerm: String, _ success: @escaping SuccessHandler, _ failure: @escaping FailureHandler) {
        let success: ([Track]) -> Void = { tracks in
            DispatchQueue.main.async { success(tracks) }
        }
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async { failure(error) }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let expectedCharSet = NSCharacterSet.urlQueryAllowed
        let searchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm)")!
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            let decoder = JSONDecoder()
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data,
                let trackList = try? decoder.decode(TrackList.self, from: data)  else {
                    if let error = error {
                        failure(NetworkError(error: error))
                    } else {
                        failure(NetworkError(response: response))
                    }
                    return
            }
            success(trackList.results)
        })
        task.resume()
    }
}
