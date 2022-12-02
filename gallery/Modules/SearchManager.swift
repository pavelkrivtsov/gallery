//
//  SearchManager.swift
//  gallery
//
//  Created by Павел Кривцов on 01.12.2022.
//

import UIKit

class SearchManager: NSObject {
    
    weak var presenter: SearchManagerInput?
    private let searchController: UISearchController
    
    init(searchController: UISearchController) {
        self.searchController = searchController
        super.init()
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search photos"
    }
}

extension SearchManager: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return print("text.isEmpty") }
        let newText = text.trimmingCharacters(in: .whitespaces)
        if newText == "" {
            return
        }
        presenter?.clearList()
        presenter?.loadPhotos(from: newText)
    }
    
    private func removeWhiteSpace(aString:String) -> String {
        let replaced = aString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return replaced
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.clearList()
        presenter?.loadPhotos()
    }
}
