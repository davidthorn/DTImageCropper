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
        //vc.startImage = UIImage.init(named: "car")
       // self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
        // Do any additional setup after loading the view.
    }


}

