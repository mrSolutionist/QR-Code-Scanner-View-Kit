//
//  File.swift
//  
//
//  Created by HD-045 on 02/05/23.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit



@available (iOS 16.0, *)
public struct  ScannerView: UIViewControllerRepresentable {
    // The handler that will be called with the scanned code
    public var codeHandler: (String) -> Void
    
    public init(codeHandler: @escaping (String) -> Void) {
        self.codeHandler = codeHandler
    }
    
    public func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.codeHandler = codeHandler
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
    }
}

@available (iOS 16.0, *)
public class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ObservableObject {
    public var codeHandler: (String) -> Void = { _ in }
    public var captureSession: AVCaptureSession!
    public var previewLayer: AVCaptureVideoPreviewLayer!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
       
        DispatchQueue.global(qos: .background).async {
 
            // start running captureSession
            self.captureSession.startRunning()
        }
    }
    
    public func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    public func found(code: String) {
        codeHandler(code)
    }
}

