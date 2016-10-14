//
//  ScanQRViewController.swift
//  DNQrCodeScanning
//
//  Created by mainone on 16/10/13.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit
import AVFoundation


class ScanQRViewController: UIViewController {
    
    var session: AVCaptureSession!
    var layer: AVCaptureVideoPreviewLayer!
    
    deinit {
        print("销毁了")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.setupScanSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScan()
    }
    
    // 设置摄像头
    func setupScanSession() {
        // 获取摄像设备
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // 初始化链接对象
        session = AVCaptureSession()
        let input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput.init(device: device)
        } catch {
            print("输入流出问题了:\(error)")
            return
        }
        // 设置会话的输入设备
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // 创建输出流
        let output = AVCaptureMetadataOutput()
        
        
        // 设置代理, 在主线程里刷新
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 设置高质量采集率
        session.canSetSessionPreset(AVCaptureSessionPresetHigh)
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        // 设置扫码支持的编码格式 (条形码和二维码)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // 设置相机扫描框大小
        layer.frame = CGRect(x: 10, y: 100, width: 300, height: 300)
        self.view.layer.insertSublayer(layer, at: 0)
        
        // 开始扫描
        startScan()
    }
    

    // 开始扫描
    fileprivate func startScan() {
        guard let session = session else { return }
        if !session.isRunning {
            session.startRunning()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


//扫描捕捉完成
extension ScanQRViewController : AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 停止扫码
        session.stopRunning()
        // 开始对信息解读
        var QRCodeMessage = ""
        for metaData in metadataObjects {
            if (metaData as? AVMetadataObject)?.type == AVMetadataObjectTypeQRCode {
                QRCodeMessage = ((metaData as? AVMetadataMachineReadableCodeObject)?.stringValue)!
            }
        }
        print("扫码结果\(QRCodeMessage)")
        
    }
}
