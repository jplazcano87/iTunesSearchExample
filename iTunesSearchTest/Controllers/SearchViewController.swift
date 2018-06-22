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
    
    // MARK: - Injections
    internal var networkClient = NetworkClient.shared
    
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
        prepareTableView()
    }
    
    // MARK: Keyboard dismissal
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func prepareTableView() {
        let nib = UINib(nibName: SearchResultCellTableViewCell.NibName, bundle: .main)
        resultsTableView.register(nib, forCellReuseIdentifier: SearchResultCellTableViewCell.ReuseIdentifier)
        resultsTableView.tableFooterView = UIView()
    }
    
}
// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        networkClient.getTrackOrArtist(forTerm: text, { [weak self] tracks in
            guard let strongSelf = self else { return }
            strongSelf.searchResults = tracks
            self?.resultsTableView.reloadData()
            self?.resultsTableView.setContentOffset(CGPoint.zero, animated: false)
            
            }, { [weak self] error in
                // guard let strongSelf = self else { return }
                // strongSelf.collectionView.refreshControl?.endRefreshing()
                print("Tracks download failed: \(error)")
        })
    }
    // MARK: Keyboard handler methods
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCellTableViewCell.ReuseIdentifier)
            as? SearchResultCellTableViewCell else {
                return UITableViewCell()
        }
        let track = searchResults[indexPath.row]
        cell.configureCell(withTrack: track)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
