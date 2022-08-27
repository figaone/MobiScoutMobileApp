//
//  CardView.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/14/22.
//

import Foundation
import UIKit

@IBDesignable class CardView : UIView {
    var cornerRadius : CGFloat = 5
    var offsetWidth : CGFloat = 5
    var offsetHeight : CGFloat = 5
    
    var offsetShadowOpacity : CGFloat = 5
    var colour = UIColor.systemGray
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = self.colour.cgColor
        layer.shadowOffset = CGSize(width: self.offsetWidth, height: self.offsetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        layer.shadowOpacity = Float(self.offsetShadowOpacity)
    }
}
