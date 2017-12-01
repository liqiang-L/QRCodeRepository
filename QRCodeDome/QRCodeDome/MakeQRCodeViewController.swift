//
//  MakeQRCodeViewController.swift
//  QRCodeDome
//
//  Created by mac on 2017/11/30.
//  Copyright © 2017年 LQ. All rights reserved.
//

import UIKit

class MakeQRCodeViewController: UIViewController {

    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var contextImageView: UIImageView!
    let context = CIContext(options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
//        let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
//        for name in properties{
//            let filter = CIFilter(name: name)
//            print("**********************",name + "\n",filter!.attributes)
//        }
    }

    @IBAction func makeQRCode(_ sender: Any) {
        let text = self.contentTextField.text
        if text?.characters.count == 0 {

            return
        }
        let strData = text!.data(using: String.Encoding.utf8)!
        // 根据 strData 生成二维码滤镜
        let qrFilter = CIFilter(name:"CIQRCodeGenerator")
        qrFilter!.setValue(strData, forKey:"inputMessage")
        qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
        // 上色
        let onColor = UIColor.brown
        let offColor = UIColor.lightGray
        let colorFilter = CIFilter.init(name:"CIFalseColor", withInputParameters: ["inputImage":qrFilter!.outputImage!,"inputColor0":CIColor(cgColor:onColor.cgColor),"inputColor1":CIColor(cgColor:offColor.cgColor)])
        let qrImage = colorFilter!.outputImage

        // 重新绘制二维码图片处理大小
        let cgimge = context.createCGImage(qrImage!, from: qrImage!.extent)
        let size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext!.interpolationQuality = CGInterpolationQuality.none
        cgContext!.scaleBy(x: 1.0, y: -1.0)
        cgContext!.draw(cgimge!, in: cgContext!.boundingBoxOfClipPath)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.contextImageView.image = newImage!
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextField.resignFirstResponder()
    }
    @IBAction func readImageFromPhoto(_ sender: Any) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
