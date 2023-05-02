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
    
    
    public var borderWidth: CGFloat
    public var borderColor : Color
    
    public var borderHeight: CGFloat
    public var mainBorderColor: Color
    
    public init(mainBorderColor: Color = .white ,borderHeight:CGFloat = 100, borderColor: Color = .black,borderWidth:CGFloat = 10, opacity: Double = 0.5, frameHeight: CGFloat = 250, frameWidth: CGFloat = 250,codeHandler: @escaping (String) -> Void) {
        self.opacity = opacity
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
        self.codeHandler = codeHandler
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderHeight = borderHeight
        self.mainBorderColor = mainBorderColor
    }
    // The handler that will be called with the scanned code
    public var codeHandler: (String) -> Void
    @Environment(\.dismiss) var dismiss
    public var body: some View {
        ZStack(alignment:.top) {
            ZStack {
                // Full-screen camera view
                ScannerView(){ url in
                    
                    codeHandler(url)
                    
                }
                .edgesIgnoringSafeArea(.all)
                
                // Transparent black overlay
                Color.black.opacity(opacity)
                    .edgesIgnoringSafeArea(.all)
                
                // Square portion to act as camera
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: frameWidth, height: frameHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
//                            .fill(Color.black.opacity(0.8))
                            .fill(.clear)
                            .frame(width: frameWidth, height: frameHeight)
                    )
                    .blendMode(.destinationOut)
                    .border(mainBorderColor,width: borderWidth)
                    .cornerRadius(12)
                
                QRScannerViewBorderDisplay(borderColor: borderColor, borderWidth: borderWidth, frameHeight: frameHeight, frameWidth: frameWidth, borderHeight: borderHeight)
//                .frame(width: 200, height: 100)
                    
                
                Capsule()
                
                    .background(mainBorderColor)
                    .frame(width: 200,height: 10)
                    .blendMode(.lighten)
                    .cornerRadius(20)
                
                
             
            }
            
            HStack{
                Spacer()
                Button{
                    print("pressed")
                    dismiss()
                }label: {
                    Image(systemName: "xmark.square.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .blendMode(.lighten)
                }
                
            }
            .padding()
        }
    }
}


@available (iOS 16.0, *)
public struct QRScannerViewBorderDisplay: View {
    public var borderWidth: CGFloat
    public var borderHeight: CGFloat
    public var borderColor : Color
    public var frameHeight: CGFloat
    public var frameWidth: CGFloat
    
    public init(borderColor: Color,borderWidth: CGFloat ,frameHeight: CGFloat, frameWidth: CGFloat , borderHeight: CGFloat) {
        self.borderWidth = borderWidth
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
        self.borderColor = borderColor
        self.borderHeight = borderHeight
    }
    
    public var body: some View {
        Group {
            HStack {
                VStack {
                    borderColor
                }
                .frame(width: borderWidth, height: borderHeight)
                Spacer()
                VStack {
                    borderColor
                }
                .frame(width: borderWidth, height: borderHeight)
            }
            .frame(width: frameWidth, height: frameHeight)
            
            VStack {
                HStack {
                    borderColor
                }
                .frame(width: borderHeight, height: borderWidth)
                Spacer()
                HStack {
                    borderColor
                }
                .frame(width: borderHeight, height: borderWidth)
            }
            .frame(width: frameWidth, height: frameHeight)
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

