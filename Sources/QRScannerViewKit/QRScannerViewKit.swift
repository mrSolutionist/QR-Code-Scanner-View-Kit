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

@available (iOS 16.0, *)
public struct QRScannerViewBorderDisplay: View {
    public init() {}
    
    public var body: some View {
        Group {
            HStack {
                VStack {
                    Color.white
                }
                .frame(width: 10, height: 100)
                Spacer()
                VStack {
                    Color.white
                }
                .frame(width: 10, height: 100)
            }
            .frame(width: 250, height: 100)
            
            VStack {
                HStack {
                    Color.white
                }
                .frame(width: 100, height: 10)
                Spacer()
                HStack {
                    Color.white
                }
                .frame(width: 100, height: 10)
            }
            .frame(width: 250, height: 250)
        }
    }
}

@available (iOS 16.0, *)
public struct QRScannerView: View {
    // Opacity of the overlay
    public var opacity: Double
    // Height of the frame
    public var frameHeight: CGFloat
    public var frameWidth: CGFloat
    
    public init(opacity: Double = 0.5, frameHeight: CGFloat = 250, frameWidth: CGFloat = 250) {
        self.opacity = opacity
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
    }
    
    public var body: some View {
        ZStack {
            // Full-screen camera view
            ScannerView(){ url in
                print("url found ", url)

            }
                .edgesIgnoringSafeArea(.all)

            // Transparent black overlay
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            // Square portion to act as camera
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 250, height: 250)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 250, height: 250)
                )
                .blendMode(.destinationOut)
                .border(.white,width: 10)
                .cornerRadius(12)

            QRScannerViewBorderDisplay()
                .blendMode(.destinationOut)

            Capsule()

                .background(.white)
                .frame(width: 200,height: 10)
                .blendMode(.lighten)
                .cornerRadius(20)

        }
    }
}
