import Foundation
import AVFoundation
import SwiftUI
import UIKit



@available (iOS 16.0, *)
public struct QRScannerView: View {
    // Opacity of the overlay
    public var opacity: Double
    // Height of the frame
    public var frameHeight: CGFloat
    public var frameWidth: CGFloat
    
    public init(opacity: Double = 0.5, frameHeight: CGFloat = 250, frameWidth: CGFloat = 250,codeHandler: @escaping (String) -> Void) {
        self.opacity = opacity
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
        self.codeHandler = codeHandler
    }
    // The handler that will be called with the scanned code
    public var codeHandler: (String) -> Void
    @Environment(\.dismiss) var dismiss
    public var body: some View {
        ZStack {
            // Full-screen camera view
            VStack {
               
                HStack{
                    Spacer()
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark.square.fill")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
                    
                }
                .padding()
                ScannerView(){ url in
                    
                   codeHandler(url)

                }
                .edgesIgnoringSafeArea(.all)
            }

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
struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            QRScannerView(codeHandler: { (code: String) -> Void in
                print("Scanned code: \(code)")
            })
        }
    }
}

