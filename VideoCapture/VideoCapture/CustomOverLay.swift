//
//  CustomOverLay.swift
//  VideoCapture
//
//  Created by hongjian lin on 4/11/17.
//  Copyright © 2017 com.DoberMan. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import CoreMedia
import Photos


struct Questions {
    var time : Int
    var questionString : String
}

class CustomOverLay: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var progressView: customProgressView!
    
    var imagePicker: UIImagePickerController?
    var isRecording: Bool?
    var MoviePathArray: Array<Any>? = []
    var VideoAssetArray: Array<AVAsset>? = []
    var QuestionArray: Array<Questions>?
    var timer: Timer?
    var questionIndex = 0
    let questionPopup: QuestionPopupView? = QuestionPopupView.init()
    @IBOutlet var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpQuestionArray() -> Array<Questions> {
        var temArray: Array<Questions>? = []
        
        let question0 = Questions(time: 15, questionString: "question0")
        temArray?.append(question0)
        
        let question1 = Questions(time: 10, questionString: "question1")
        temArray?.append(question1)
        
        //    let question2 = Questions(time: 15, questionString: "question2")
        //    temArray?.append(question2)
        
        return temArray!
    }
    
    
    func setUpPicker(picker: UIImagePickerController) {
        
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.showsCameraControls = false
        picker.isNavigationBarHidden = true
        picker.isToolbarHidden = true
        picker.mediaTypes = NSArray(object: kUTTypeMovie)  as! [String]
        picker.videoQuality = .typeHigh
        
        
        picker.delegate = self
        self.imagePicker = picker;
        
        self.QuestionArray = self.setUpQuestionArray()
        
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
        
        UIView.transition(with: (self.imagePicker?.view)!, duration: 1.0, options:[.allowAnimatedContent, .transitionFlipFromLeft], animations: {
            if self.imagePicker?.cameraDevice == .front
            {
                self.imagePicker?.cameraDevice = .rear
            }else
            {
                self.imagePicker?.cameraDevice = .front
            }
            
        }, completion: { (Bool) in})
    
    }
    
    
    @IBAction func recordButtonClick(_ sender: Any) {
        
        if isRecording == true
        {
            self.imagePicker?.stopVideoCapture()
            self.recordButton.isSelected = false
            isRecording = false
        }else
        {
            self.imagePicker?.startVideoCapture()
            self.recordButton.isSelected = true
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
        
        if questionIndex == (self.QuestionArray?.count)!-1
        {
            
            VideoFileManager.sharedInstance.CombineVideo(VideoArray: self.MoviePathArray!)
            
            // self.CombineVideo(VideoArray: self.MoviePathArray!);
        }else
        {
            questionIndex += 1
            //self.showQuestionPopup(index: questionIndex)
        }
    }
    
    func showQuestionPopup(index : Int) {
        
        self.questionPopup?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        self.questionPopup?.setupQuestionOverlay(inputQuestion: (self.QuestionArray?[index])!, parentView: self.view)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            let  infoUrl = info[UIImagePickerControllerMediaURL] as! URL
            let path = infoUrl.path
            self.MoviePathArray?.append(infoUrl)
            
            let avAsset = AVAsset(url:info[UIImagePickerControllerMediaURL] as! URL)
            self.VideoAssetArray?.append(avAsset)
            
            
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
