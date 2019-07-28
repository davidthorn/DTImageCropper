//
//  DTImageCropperScrollView.swift
//  DTImageCropper
//
//  Created by David Thorn on 28.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

public class DTImageCropperScrollView: UIScrollView, UIScrollViewDelegate {

    public var imageView: UIImageView!
    
    public var startImage: UIImage? {
        didSet {
            
            imageView.image = self.startImage
            contentSize = self.startImage == nil ? CGSize.init(width: 0, height: 0) : self.startImage!.size
            viewForZooming = self.imageView
        }
    }
    
    public var viewForZooming: UIView? {
        didSet {
            minimumZoomScale = 0.1
            zoomScale = (bounds.width / contentSize.width) * 0.9
            layoutIfNeeded()
            prepareInsets()
        }
    }
    
    public func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        minimumZoomScale = 1
        maximumZoomScale = 20
        
        imageView = UIImageView.init(frame: bounds)
        addSubview(imageView)
        imageView.center = center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZooming
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        prepareInsets()
    }
    
    internal func prepareInsets() {
        guard contentSize.width > 0 , contentSize.height > 0 else { return }
        let insertY = contentSize.height < bounds.height ? (bounds.height - contentSize.height) / 2 : 0
        let insertX = contentSize.width < bounds.width ? (bounds.width - contentSize.width) / 2 : 0
        contentInset = UIEdgeInsets.init(top: insertY, left: insertX, bottom: insertY, right: insertX)
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        guard let iv = self.imageView else { fatalError("Setup has not been called") }
        NSLayoutConstraint.activate([
            iv.leftAnchor.constraint(equalTo: leftAnchor),
            iv.rightAnchor.constraint(equalTo: rightAnchor),
            iv.topAnchor.constraint(equalTo: topAnchor),
            iv.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
    
}
