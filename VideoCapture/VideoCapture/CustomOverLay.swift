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
            self.CombineVideo(VideoArray: self.MoviePathArray!);
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
    
    
    func videoCompositionInstructionForTrack(_ track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform)
        
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
                                     at: kCMTimeZero)
        } else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: kCMTimeZero)
        }
        
        return instruction
    }

    func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImageOrientation, isPortrait: Bool) {
        var assetOrientation = UIImageOrientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
    
    func CombineVideo(VideoArray : Array<Any>)  {
        
        let mixComposition = AVMutableComposition()
        
        var totalTime: CMTime? = CMTimeMake(0, 60)
  
        let mainInstruction = AVMutableVideoCompositionInstruction()
        
     
        
        for case let urlString as URL in VideoArray {
           
            let avAsset = AVAsset(url: urlString)
            
            let firstTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do {
                try firstTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, avAsset.duration), of: avAsset.tracks(withMediaType: AVMediaTypeVideo)[0], at: totalTime!)
            } catch _ {
                print("Failed to load first track")
            }
            
            let firstInstruction = videoCompositionInstructionForTrack(firstTrack , asset: avAsset)
            firstInstruction.setOpacity(0.0, at: CMTimeAdd(totalTime!, avAsset.duration))
            
            mainInstruction.layerInstructions.append(firstInstruction)
            totalTime = CMTimeAdd(totalTime!, avAsset.duration)
            
            
            
        }
        
        
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, totalTime!)
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(1, 30)
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        // 4 - Get path
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let savePath = (documentDirectory as NSString).appendingPathComponent("mergeVideo-\(date).mov")
        let url = URL(fileURLWithPath: savePath)
        
        // 5 - Create Exporter
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exporter.outputURL = url
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition

        // 6 - Perform the Export
        exporter.exportAsynchronously() {
            DispatchQueue.main.async { _ in
                self.exportDidFinish(exporter)
            }
        }
        
    }
    
    func exportDidFinish(_ session: AVAssetExportSession) {
        if session.status == AVAssetExportSessionStatus.completed {
            let outputURL = session.outputURL
            
            PHPhotoLibrary.shared().performChanges({ () -> Void in
                let createAssetRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL!)!
                createAssetRequest.placeholderForCreatedAsset
            }) { (success, error) -> Void in
                if success {
                    print("success")
                }
                else {
                    print("unsuccess")
                }
            }
        }
        
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
