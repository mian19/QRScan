//
//  ViewController.swift
//  QRScan
//
//  Created by Kyzu on 13.03.22.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var camera = AVCaptureVideoPreviewLayer()
    private var qrCodeFrame: UIView!
    // 1 setup session
    private let session = AVCaptureSession()
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        view = customView
        qrCodeFrame = UIView()

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        view.layer.addSublayer(camera)
        
        session.startRunning()
    }
    
    private func setupCamera() {

        //2 setup device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        // 3  setup input parameter
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        //4 output parameter
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        //5
        camera = AVCaptureVideoPreviewLayer(session: session)
        camera.frame = view.layer.bounds
    }
    
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {
           // qrCodeFrame.frame = .zero
            return
        }
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                
                let qrObjectWithFrame = camera.transformedMetadataObject(for: object)
                
            //  qrObjectWithFrame!.bounds
                addQrFrame(frame: qrObjectWithFrame!.bounds)
                view.bringSubviewToFront(qrCodeFrame)
                print(qrCodeFrame.frame)
               
            }
        }
    }
    
    private func addQrFrame(frame: CGRect) {
        
        qrCodeFrame.frame = frame
        qrCodeFrame.layer.borderColor = UIColor.yellow.cgColor
        qrCodeFrame.layer.borderWidth = 2
        view.addSubview(qrCodeFrame)
        
    }
    

}

