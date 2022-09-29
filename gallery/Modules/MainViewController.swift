//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

class MainViewController: UITableViewController {
    
    var presenter: MainPresenterIn
    var images = [UnsplashImage]()
    
    init(presenter: MainPresenterIn) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.cellIdentifier)
        presenter.setupImageList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.cellIdentifier, for: indexPath) as! ImageCell
        let unsplashPhoto = images[indexPath.item]
        cell.configure(image: unsplashPhoto)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      let currentImage = images[indexPath.item]
      let heightPerItem = CGFloat(currentImage.width) / CGFloat(currentImage.height)
      return tableView.frame.width / heightPerItem
    }
}

extension MainViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.tabBarItem.image = UIImage(systemName: "photo")
        return navigationController
    }
}

extension MainViewController: MainPresenterOut {
    func setImageList(imageList: [UnsplashImage]) {
        self.images = imageList
        tableView.reloadData()
    }
}
