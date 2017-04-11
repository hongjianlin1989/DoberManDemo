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
        self.videoCaptureOverlay = storyboard.instantiateViewController(withIdentifier: "CustomOverLay") as? CustomOverLay
        self.videoCaptureOverlay?.view.frame = self.view.bounds;
        self.imagePicker = UIImagePickerController.init()
        self.imagePicker?.allowsEditing = false
        self.imagePicker?.sourceType = .camera
        self.imagePicker?.showsCameraControls = false
        self.imagePicker?.isNavigationBarHidden = true
        self.imagePicker?.isToolbarHidden = true
     
        let cameraTransform = CGAffineTransform(translationX: 0.0, y: 81.0)
        self.imagePicker?.cameraViewTransform = cameraTransform;
        
        let cameraTransformscale = CGAffineTransform(scaleX:1.7, y:1.7)
        self.imagePicker?.cameraViewTransform = cameraTransformscale;
        
        self.videoCaptureOverlay?.imagePicker = self.imagePicker
        self.imagePicker?.view.addSubview((videoCaptureOverlay?.view)!)
        
        self.imagePicker?.delegate = videoCaptureOverlay
        self.present(self.imagePicker!, animated: false) {}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

