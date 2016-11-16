//
//  ReadQRViewController.swift
//  DNQrCodeScanning
//
//  Created by mainone on 16/10/14.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit

class ReadQRViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let image = UIImage(named: "qrimage")
        DispatchQueue.global().async {
            let recognizeResult = image?.recognizeQRCode()
            let result = (recognizeResult?.characters.count)! > 0 ? recognizeResult : "无法识别"
            print(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
