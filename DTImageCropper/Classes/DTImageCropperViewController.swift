//
//  DTImageCropperViewController.swift
//  DTImageCropper
//
//  Created by David Thorn on 28.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

open class DTImageCropperViewController: UIViewController {

    public var startImage: UIImage?
    
    internal var imagePicker: UIImagePickerController?
    
    lazy var scrollView: DTImageCropperScrollView = {
        let scroll = DTImageCropperScrollView.init(frame: self.view.bounds)
       
        return scroll
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        handleConstraints()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard self.startImage == nil  else {
            scrollView.startImage = self.startImage
            return
        }
        
    }
   
    

}

extension DTImageCropperViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { self.navigationController?.popViewController(animated: true); return }
        
    }
    
}
