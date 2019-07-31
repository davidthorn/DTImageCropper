//
//  ViewController.swift
//  DTImageCropperExample
//
//  Created by David Thorn on 28.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import DTImageCropper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = DTImageCropperViewController.init()
        self.present(vc, animated: true)
    }


}

