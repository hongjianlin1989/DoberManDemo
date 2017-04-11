//
//  CustomOverLay.swift
//  VideoCapture
//
//  Created by hongjian lin on 4/11/17.
//  Copyright © 2017 com.DoberMan. All rights reserved.
//

import UIKit

class CustomOverLay: UIViewController,UIImagePickerControllerDelegate {

    
    var imagePicker: UIImagePickerController?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func setUpPicker(picker: UIImagePickerController) {
        
//        picker.allowsEditing = false
//        picker.sourceType = .camera
//        picker.showsCameraControls = false
//        picker.isNavigationBarHidden = true
//        picker.isToolbarHidden = true
//        
//        let cameraTransform = CGAffineTransform(translationX: 0.0, y: 81.0)
//        picker.cameraViewTransform = cameraTransform;
//        
//        let cameraTransformscale = CGAffineTransform(scaleX:1.7, y:1.7)
//        picker.cameraViewTransform = cameraTransformscale;
//        
//        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        self.imagePicker = picker;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeButtonClick(_ sender: Any) {
        self.imagePicker?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func CameraDirectionClick(_ sender: Any) {
        
        print("here")
    }
  
    
    @IBAction func recordButtonClick(_ sender: Any) {
        
        print("here1")
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
