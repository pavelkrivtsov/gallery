//
//  TableManager.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

protocol TableManagerProtocol {
    func setupTableView(tableView: UITableView)
    func fillViewModels(viewModels: [CellType])
    func showScreen(tableView: UITableView,
                    cellForRowAt indexPath: IndexPath,
                    viewModels: [CellType]) -> UITableViewCell
}

class TableManager: NSObject {
    private weak var tableView: UITableView?
    private var viewModels = [CellType]()
}

extension TableManager: TableManagerProtocol {
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.separatorStyle = .none
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
//        self.tableView?.backgroundColor = .systemBackground
        self.tableView?.estimatedRowHeight = 300
        self.tableView?.rowHeight = UITableView.automaticDimension
    }
    
    public func fillViewModels(viewModels: [CellType]) {
        self.viewModels = viewModels
        self.registerForCells(viewModels: viewModels)
        self.tableView?.reloadData()
    }
    
    public func registerForCells(viewModels: [CellType]) {
        let keys: Set<String> = Set(viewModels.map({ $0.cellsId }))
        keys.forEach { key in
            let objectClass: AnyClass?  = NSClassFromString( "gallery." + key)
            guard let classType = objectClass as? UITableViewCell.Type else {
                return
            }
            self.tableView?.register(classType, forCellReuseIdentifier: key)
        }
    }
    
    public func showScreen(tableView: UITableView, cellForRowAt indexPath: IndexPath, viewModels: [CellType]) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        
        switch model {
        case .labelCell(label: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: model.cellsId,
                                                           for: indexPath) as? LabelCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellConfiguration(model: model)
            return cell
            
        case .mapViewCell(label: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: model.cellsId,
                                                           for: indexPath) as? MapViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellConfiguration(model: model)
            return cell
            
        case .stackLabelCell(label: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: model.cellsId,
                                                           for: indexPath) as? StackLabelCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellConfiguration(model: model)
            return cell
        }
    }
}

// MARK: - Table view data source implementation
extension TableManager: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        showScreen(tableView: tableView, cellForRowAt: indexPath, viewModels: viewModels)
    }
}
