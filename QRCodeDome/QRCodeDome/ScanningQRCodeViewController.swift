//
//  ScanningQRCodeViewController.swift
//  QRCodeDome
//
//  Created by mac on 2017/11/29.
//  Copyright © 2017年 LQ. All rights reserved.
//

import UIKit
import AVFoundation


class ScanningQRCodeViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            if UIScreen.main.bounds.size.height < 500{
                session.sessionPreset = .vga640x480
            }else{
                session.sessionPreset = .high
            }
            let input: AVCaptureDeviceInput = try AVCaptureDeviceInput.init(device:device!)
            session.addInput(input)
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)

            let windowSize = self.view.bounds.size
            let scanSize = CGSize(width:windowSize.width/2.0,height:windowSize.width/2.0)

            let scanRect = CGRect(x:(windowSize.width - scanSize.width)/2.0,y:(windowSize.height - scanSize.height)/2.0,width:scanSize.width,height:scanSize.height)

            output.rectOfInterest = CGRect(x:scanRect.minY/windowSize.height, y:scanRect.minX/windowSize.width , width:scanRect.height/windowSize.height, height: scanRect.width/windowSize.width )

            output.setMetadataObjectsDelegate(self, queue:DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            let previewLayer = AVCaptureVideoPreviewLayer(session:session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = self.view.bounds
//            self.view.layer.addSublayer(previewLayer)

            let view = UIView(frame: self.view.bounds)
            view.layer.addSublayer(previewLayer)
            self.view.addSubview(view)

            let scranView = UIView(frame: scanRect)
            self.view.addSubview(scranView)
            scranView.layer.borderColor = UIColor.red.cgColor
            scranView.layer.borderWidth = 1.0

            session.startRunning()

        } catch{
            print(error)
        }
    }
    deinit {
        session.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return;
        }
        if metadataObjects.count > 0 {
            self.session.stopRunning()
            let obj :AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            let alertview:UIAlertController = UIAlertController.init(title:"title", message: obj.stringValue, preferredStyle: UIAlertControllerStyle.alert)
            print("输出" + obj.stringValue!)

            let sureAction = UIAlertAction.init(title: "sure", style: .default, handler: { show in
                self.session.startRunning()
                print("输出" + obj.stringValue!)
            })
            alertview.addAction(sureAction)
            self.navigationController?.present(alertview, animated: true, completion: nil)
        }

    }

    override var shouldAutorotate: Bool{
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return UIInterfaceOrientation.portrait
    }

}
