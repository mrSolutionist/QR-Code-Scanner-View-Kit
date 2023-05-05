# QRScannerViewKit for SwiftUI 

QRScannerViewKit is a Swift package that provides a customisable QR code scanner view for iOS apps. 
It supports all type of QRScanner and Barcode scans.
It includes a full-screen camera view with a transparent black overlay and a square portion that acts as the camera. 
The scanner view also features a border display mark and a capsule-shaped highlight to enhance the user experience. 
The package is built using the AVFoundation framework and is fully customisable to fit your app's design. 
The QR code scanner view can be easily integrated into your iOS app using the provided SwiftUI view.

Created for SwiftUI, 
by Robin Geroge
iOS Developer 


# Package Documentation
The QRScannerViewKit package provides a SwiftUI view that can be used to scan QR codes using the device's camera. It creates a full-screen camera view with a square portion that acts as the camera, and scans for QR codes within that square. When a code is detected, a handler function that you provide is called with the scanned code as a parameter.

# Installation
The QRScannerViewKit package can be installed using Swift Package Manager. To install it in your Xcode project, follow these steps:

In Xcode, open your project.
Click on File > Swift Packages > Add Package Dependency.
In the "Choose Package Repository" dialog, enter the URL of the QRScannerView package: https://github.com/mrSolutionist/QRScannerViewKit 
Click on Next, and select the version of the package that you want to use.
Click on Next again, and select the target where you want to add the package.
Click on Finish.


# Usage
To use the QRScannerView in your SwiftUI view, follow these steps:

Import the QRScannerViewKit package at the top of your file:

```
import QRScannerViewKit
```

or 

```
import QRScannerView
```
To use the QRScannerView, it is recommended to present it as a full-screen modal sheet or cover. This is because the view is designed to automatically dismiss itself once it successfully captures a QR code.

```
QRScannerView(codeHandler: { code in
    // Handle the scanned code here
})
```
The scannerType, mainBorderColor, opacity, frameHeight, frameWidth, borderColor, borderWidth, borderHeight  parameters are optional, and control the opacity of the overlay, and the height and width of the camera frame. The codeHandler parameter is required, and should be a closure that takes a String parameter, which will contain the scanned QR code.

The default values are scannerType: qr , mainBorderColor : .white ,opacity: 0.5, frameHeight: 250, frameWidth: 250, borderColor: .black, borderWidth: 5,borderHeight: 100.

# Example

Here's an example of how you can use the QRScannerView in your SwiftUI view:

```
struct ContentView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode = ""

    var body: some View {
        VStack {
            Text("Scanned code: \(scannedCode)")
            Button("Scan QR code") {
                isPresentingScanner = true
            }
        }
        .fullScreenCover(isPresented: $isPresentingScanner) {
            QRScannerView { code in
                scannedCode = code
                isPresentingScanner = false
            }
        }
    }
}

```

# Support

If you have any questions or issues with the QRScannerView package, you can contact me by opening an issue on the package repository: https://github.com/mrSolutionist/QRScannerViewKit .


![alt text](https://github.com/mrSolutionist/QRScannerViewKit/blob/main/IMG_6013.jpg)

