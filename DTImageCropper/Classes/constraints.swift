//
//  constraints.swift
//  DTImageCropper
//
//  Created by David Thorn on 28.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import Foundation

extension DTImageCropperViewController {
    
    internal func handleConstraints() {
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            scrollView.centerYAnchor.constraint(equalTo: view!.centerYAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view!.centerXAnchor),
            ])
    }
    
}
