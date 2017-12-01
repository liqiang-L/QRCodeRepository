//
//  ReadPhotoViewController.swift
//  QRCodeDome
//
//  Created by mac on 2017/11/30.
//  Copyright © 2017年 LQ. All rights reserved.
//

import UIKit


class ReadPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    let cicontext = CIContext(options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(longPressAction))
        self.photoImageView.addGestureRecognizer(longPress)
        self.photoImageView.isUserInteractionEnabled = true
    }

    @objc func longPressAction(){

        let qrCodeImage = photoImageView.image
        if qrCodeImage != nil{

            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: cicontext, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            let image = CIImage(cgImage:(qrCodeImage?.cgImage)!)
            let features = detector!.features(in: image)
            let feautre:CIQRCodeFeature = (features.first)! as! CIQRCodeFeature
            let message = feautre.messageString

            let alert = UIAlertController(title: nil, message:message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    @IBAction func chosePhoto(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        alertController.addAction(UIAlertAction(title:"相机" , style: .default, handler: { (alertCamera) in
            picker.sourceType = .camera
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.present(picker, animated:true, completion: nil)
            }
        }))

        alertController.addAction(UIAlertAction(title: "相册", style: .default, handler: { (photo) in
            picker.sourceType = .photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.present(picker, animated: true, completion: nil)
            }
        }))

        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        if  chosenImage is UIImage {
            picker.dismiss(animated: true, completion: {
                self.photoImageView.image = chosenImage as? UIImage
            })

        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
