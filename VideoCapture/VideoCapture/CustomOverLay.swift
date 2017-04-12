//
//  CustomOverLay.swift
//  VideoCapture
//
//  Created by hongjian lin on 4/11/17.
//  Copyright © 2017 com.DoberMan. All rights reserved.
//

import UIKit
import MobileCoreServices

class CustomOverLay: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var imagePicker: UIImagePickerController?
    var isRecording: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func setUpPicker(picker: UIImagePickerController) {
        
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.showsCameraControls = false
        picker.isNavigationBarHidden = true
        picker.isToolbarHidden = true
        picker.mediaTypes = NSArray(object: kUTTypeMovie)  as! [String]
        
        let cameraTransform = CGAffineTransform(translationX: 0.0, y: 81.0)
        picker.cameraViewTransform = cameraTransform;
        
        let cameraTransformscale = CGAffineTransform(scaleX:1.7, y:1.7)
        picker.cameraViewTransform = cameraTransformscale;
        
        picker.delegate = self
        self.imagePicker = picker;
        
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
        
        if self.imagePicker?.cameraDevice == .front
        {
            
            UIView.transition(with: (self.imagePicker?.view)!, duration: 1.0, options:[.allowAnimatedContent, .transitionFlipFromLeft], animations: {
                
                self.imagePicker?.cameraDevice = .rear
            
            }, completion: { (Bool) in})
            
        }else
        {
            UIView.transition(with: (self.imagePicker?.view)!, duration: 1.0, options:[.allowAnimatedContent, .transitionFlipFromLeft], animations: {
                
                self.imagePicker?.cameraDevice = .front
                
            }, completion: { (Bool) in})
        }
        
    }
  
    
    @IBAction func recordButtonClick(_ sender: Any) {

        if isRecording == true
        {
            self.imagePicker?.stopVideoCapture()
            isRecording = false
        }else
        {
            self.imagePicker?.startVideoCapture()
            isRecording = true
        }
    }
    
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            let  infoUrl = info[UIImagePickerControllerMediaURL] as! URL
            let path = infoUrl.path
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
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
