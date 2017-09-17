//
//  ImageViewController.swift
//  Cassini
//
//  Created by Li Yang on 7/7/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{        
    fileprivate var userZoomed = false
    
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self // methods in delegate are optional
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 2.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        if !userZoomed {
            let scalefactor = self.scrollView.frame.size.width / imageView.frame.size.width
            imageView.frame.size.width *= scalefactor
            imageView.frame.size.height *= scalefactor
            scrollView?.contentSize = imageView.frame.size
        }
    }

}

extension ImageViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        userZoomed = true
    }

}
