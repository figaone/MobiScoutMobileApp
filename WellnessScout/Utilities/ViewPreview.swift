//
//  ViewPreview.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/17/22.
//

import UIKit
import AVFoundation

class ViewPreview: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        
        layer.videoGravity = .resizeAspectFill
        
        return layer
    }
    override func layoutSubviews() {
            self.videoPreviewLayer.frame = self.bounds;
        }
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
