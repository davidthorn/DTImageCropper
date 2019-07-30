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
    
    internal var overlayView: DTOverlayView!
    
    internal var imagePicker: UIImagePickerController?
    
    lazy var scrollView: DTImageCropperScrollView = {
        let scroll = DTImageCropperScrollView.init(frame: self.view.bounds)
       
        return scroll
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        handleConstraints()
        self.view.backgroundColor = UIColor.darkGray
        self.overlayView = DTOverlayView.init()
        self.overlayView.frame = view.bounds
        view.addSubview(overlayView)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard self.startImage == nil  else {
            scrollView.startImage = self.startImage
            return
        }
        
        guard self.imagePicker == nil else {
            self.imagePicker = nil
            switch self.navigationController {
            case nil:
                switch self.presentingViewController {
                case nil:
                   fatalError("I honestly do not know how this was shown now")
                default:
                    self.dismiss(animated: true)
                }
            default:
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        self.imagePicker = UIImagePickerController.init()
        self.imagePicker?.sourceType = .photoLibrary
        self.imagePicker?.delegate = self
        self.present(self.imagePicker!, animated: true)
    }
   
}

extension DTImageCropperViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            picker.delegate = self
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { self.navigationController?.popViewController(animated: true); return }
        self.startImage = image
        picker.dismiss(animated: true) { [weak self] in
            picker.delegate = self
            self?.imagePicker = nil
        }
    }
    
}
