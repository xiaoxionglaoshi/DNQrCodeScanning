# DNQrCodeScanning
系统API实现二维码扫描功能
### 1.添加头文件
```
import AVFoundation
```
### 2.遵守协议
```
AVCaptureMetadataOutputObjectsDelegate
```
### 3创建扫码视图
```
var session: AVCaptureSession!
var layer: AVCaptureVideoPreviewLayer!

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
session.startRunnin
```
### 4.实现代理获取扫码结果,并停止扫码
```
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
```
