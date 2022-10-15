//
//  DetailInfoViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 05.10.2022.
//

import UIKit


class DetailInfoViewController: UIViewController {
    
    private var photo: Photo
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.frame = view.bounds
        scrollView.contentSize = contentCize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame.size = contentCize
        return contentView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private var contentCize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 400)
    }
    
    private var detailInfoStack = UIStackView()
        
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupColors()
        setupConstraints()
    }
}

extension DetailInfoViewController {
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        for view in stackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 300),
                view.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    private func setupColors() {
        let colors = [UIColor.red, .green, .cyan]
        for index in 0..<10 {
            let view = UIView()
            view.backgroundColor = colors[index % colors.count]
            stackView.addArrangedSubview(view)
        }
    }
}
