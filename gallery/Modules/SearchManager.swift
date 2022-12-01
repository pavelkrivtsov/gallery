//
//  SearchManager.swift
//  gallery
//
//  Created by Павел Кривцов on 01.12.2022.
//

import UIKit

protocol SearchManagerOutput {

}

class SearchManager: NSObject {
    
    weak var presenter: SearchManagerInput?
    private let searchController: UISearchController
    
    init(searchController: UISearchController) {
        self.searchController = searchController
        super.init()
        self.searchController.definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search photos"
    }
}

extension SearchManager: SearchManagerOutput {
    
}

extension SearchManager: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
}
