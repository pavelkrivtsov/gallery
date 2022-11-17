//
//  DetailTableManager.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

protocol DetailTableManagerProtocol {
    func fillViewModels(viewModels: [CellType])
    func showScreen(tableView: UITableView,
                    cellForRowAt indexPath: IndexPath,
                    viewModels: [CellType]) -> UITableViewCell
}

class DetailTableManager: NSObject {
    private var tableView: UITableView
    private var viewModels = [CellType]()
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension DetailTableManager: DetailTableManagerProtocol {
    
    func fillViewModels(viewModels: [CellType]) {
        self.viewModels = viewModels
        self.registerForCells(viewModels: viewModels)
        self.tableView.reloadData()
    }
    
    func registerForCells(viewModels: [CellType]) {
        let keys: Set<String> = Set(viewModels.map({ $0.cellsId }))
        keys.forEach { key in
            let objectClass: AnyClass?  = NSClassFromString( "gallery." + key)
            guard let classType = objectClass as? UITableViewCell.Type else {
                return
            }
            self.tableView.register(classType, forCellReuseIdentifier: key)
        }
    }
    
    func showScreen(tableView: UITableView,
                    cellForRowAt indexPath: IndexPath,
                    viewModels: [CellType]) -> UITableViewCell {
        
        let model = viewModels[indexPath.row]
        
        switch model {
        case .labelCell(label: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: model.cellsId,
                                                           for: indexPath)
                    as? LabelCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellConfiguration(model: model)
            return cell
            
        case .mapViewCell(label: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: model.cellsId,
                                                           for: indexPath)
                    as? MapViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellConfiguration(model: model)
            return cell
            
        case .stackLabelCell(label: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: model.cellsId,
                                                           for: indexPath)
                    as? StackLabelCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellConfiguration(model: model)
            return cell
        }
    }
}

// MARK: - Table view data source implementation
extension DetailTableManager: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        showScreen(tableView: tableView, cellForRowAt: indexPath, viewModels: viewModels)
    }
}
