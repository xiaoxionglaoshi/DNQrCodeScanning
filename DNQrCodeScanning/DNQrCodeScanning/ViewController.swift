//
//  ViewController.swift
//  DNQrCodeScanning
//
//  Created by mainone on 16/10/12.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var session: AVCaptureSession!
    var layer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// 获取摄像设备
let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
// 初始化链接对象
session = AVCaptureSession()
// 创建输入流
do {
    let input = try AVCaptureDeviceInput.init(device: device)
    // 设置会话的输入设备
    session?.addInput(input)
} catch {
    print("创建输入流发生错误:\(error)")
}
// 创建输出流
let output = AVCaptureMetadataOutput()
// 设置代理, 在主线程里刷新
output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
// 设置高质量采集率
session.canSetSessionPreset(AVCaptureSessionPresetHigh)
session.addOutput(output)
// 设置扫码支持的编码格式 (条形码和二维码)
output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
layer = AVCaptureVideoPreviewLayer(session: session)
layer.videoGravity = AVLayerVideoGravityResizeAspectFill
// 设置相机扫描框大小
layer.frame = CGRect(x: 10, y: 100, width: 300, height: 300)
self.view.layer.insertSublayer(layer, at: 0)
// 开始捕获
session.startRunning()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var QRCodeMessage = ""
        for metaData in metadataObjects {
            if (metaData as? AVMetadataObject)?.type == AVMetadataObjectTypeQRCode {
                QRCodeMessage = ((metaData as? AVMetadataMachineReadableCodeObject)?.stringValue)!
            }
        }
        print("扫码结果\(QRCodeMessage)")
        //停止扫码
        session.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

