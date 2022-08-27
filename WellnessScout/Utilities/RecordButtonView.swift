//
//  RecordButtonView.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/17/22.
//

import UIKit


class RecordButtonView: UIView {

   //properties of the view
    var isEnabled : Bool = true
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        StyleKit.drawRecordButton(frame: self.bounds, resizing: StyleKit.ResizingBehavior.aspectFit, isRecording: isEnabled)
    }
    
    //function that can be called to reload the view when needed
    func reloadView(isRecording : Bool){
        //sets the visibility
        self.isEnabled = isRecording
        //reloads the view
        self.setNeedsDisplay()
    }
    
}
