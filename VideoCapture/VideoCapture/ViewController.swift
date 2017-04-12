//
//  ViewController.swift
//  VideoCapture
//
//  Created by hongjian lin on 4/11/17.
//  Copyright © 2017 com.DoberMan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videoCaptureOverlay: CustomOverLay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func showCameraView(_ sender: Any) {
    
        let storyboard = UIStoryboard(name: "VideoCaptureStoryBoard", bundle: nil)
        self.videoCaptureOverlay = storyboard.instantiateViewController(withIdentifier: "CustomOverLay") as? CustomOverLay
        self.videoCaptureOverlay?.view.frame = self.view.bounds;
        let imagePicker = UIImagePickerController.init()
        self.videoCaptureOverlay?.setUpPicker(picker: imagePicker)
        imagePicker.view.addSubview((videoCaptureOverlay?.view)!)
        self.present(imagePicker, animated: false) {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

