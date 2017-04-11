//
//  ViewController.swift
//  VideoCapture
//
//  Created by hongjian lin on 4/11/17.
//  Copyright © 2017 com.DoberMan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var imagePicker: UIImagePickerController?
    var videoCaptureOverlay: CustomOverLay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func showCameraView(_ sender: Any) {
    
        let storyboard = UIStoryboard(name: "VideoCaptureStoryBoard", bundle: nil)
        videoCaptureOverlay = storyboard.instantiateViewController(withIdentifier: "CustomOverLay") as? CustomOverLay
        videoCaptureOverlay?.view.frame = self.view.bounds;
        imagePicker = UIImagePickerController.init()
        imagePicker?.allowsEditing = false
        imagePicker?.sourceType = .camera
        imagePicker?.showsCameraControls = false
        imagePicker?.isNavigationBarHidden = true
        imagePicker?.isToolbarHidden = true
     
        let cameraTransform = CGAffineTransform(translationX: 0.0, y: 81.0)
        imagePicker?.cameraViewTransform = cameraTransform;
        
        let cameraTransformscale = CGAffineTransform(scaleX:1.7, y:1.7)
        imagePicker?.cameraViewTransform = cameraTransformscale;
        
        videoCaptureOverlay?.imagePicker = imagePicker
        videoCaptureOverlay?.imagePicker?.view.addSubview((videoCaptureOverlay?.view)!)
        
        imagePicker?.delegate = videoCaptureOverlay as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePicker!, animated: false) {}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

