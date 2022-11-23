//
//  PhotoZoomManager.swift
//  gallery
//
//  Created by Павел Кривцов on 23.11.2022.
//

import UIKit

protocol PhotoZoomManagerOutput: AnyObject {
    func setImageView(view: UIImageView)
}

class PhotoZoomManager: NSObject {
    
    weak var presenter: PhotoZoomManagerInput?
    private var scrollView: UIScrollView
    private var imageView = UIImageView()
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init()
        
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 4
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
    }
}

extension PhotoZoomManager: PhotoZoomManagerOutput {
    func setImageView(view: UIImageView) {
        self.imageView = view
    }
}

extension PhotoZoomManager: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? { self.imageView }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioWidth = imageView.frame.width / image.size.width
                let ratioHeight = imageView.frame.height / image.size.height
                
                let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width :
                                    (scrollView.frame.width - scrollView.contentSize.width))
                let conditionTop = newHeight * scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height :
                                    (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = .init(top: top, left: left ,bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
