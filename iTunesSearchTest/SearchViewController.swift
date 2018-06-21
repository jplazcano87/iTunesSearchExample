//
//  ViewController.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/20/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Stored Properties
    private var searchResults = [Track]()
    private var defaultSession: DHURLSession = URLSession(configuration: URLSessionConfiguration.default)
    private var dataTask: URLSessionDataTask?
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
    }()
    
    // MARK: LifeCycle Methos
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.tableFooterView = UIView()
    }
    
    // MARK: Keyboard dismissal
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    // MARK: Handling Search Results
    //FIXME: needs refactor, move the parse out of the ViewController,
    //implementation incomplete, only printing the response, not showing in the tableview
    func updateSearchResults(_ data: Data?) {
        searchResults.removeAll()
        do {
            if let data = data {
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(TrackList.self, from: data)
                print(searchResults)
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
            self.resultsTableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
}
// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
   //FIXME: needs refactor, move the request logic out of the ViewController
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let expectedCharSet = NSCharacterSet.urlQueryAllowed
        let searchTerm = text.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm)")
        dataTask = defaultSession.dataTask(with: url!) { data, response, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateSearchResults(data)
                }
            }
        }
        dataTask?.resume()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}
// MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    //FIXME: placeholder cell, missing correct implementation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
