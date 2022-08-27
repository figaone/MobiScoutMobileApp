//
//  StyleKit.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/17/22.
//

import UIKit

public class StyleKit : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawRecordButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 48, height: 45), resizing: ResizingBehavior = .aspectFit, isRecording: Bool = true) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 48, height: 45), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 48, y: resizedFrame.height / 45)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 48, resizedFrame.height / 45)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.714)
        let color3 = UIColor(red: 0.149, green: 0.619, blue: 0.149, alpha: 1.000)

        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 5

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 24, y: 8))
        bezierPath.addCurve(to: CGPoint(x: 16.59, y: 9.95), controlPoint1: CGPoint(x: 21.31, y: 8), controlPoint2: CGPoint(x: 18.78, y: 8.71))
        bezierPath.addCurve(to: CGPoint(x: 9, y: 23), controlPoint1: CGPoint(x: 12.06, y: 12.53), controlPoint2: CGPoint(x: 9, y: 17.41))
        bezierPath.addCurve(to: CGPoint(x: 24, y: 38), controlPoint1: CGPoint(x: 9, y: 31.28), controlPoint2: CGPoint(x: 15.72, y: 38))
        bezierPath.addCurve(to: CGPoint(x: 39, y: 23), controlPoint1: CGPoint(x: 32.28, y: 38), controlPoint2: CGPoint(x: 39, y: 31.28))
        bezierPath.addCurve(to: CGPoint(x: 24, y: 8), controlPoint1: CGPoint(x: 39, y: 14.72), controlPoint2: CGPoint(x: 32.28, y: 8))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 42, y: 23))
        bezierPath.addCurve(to: CGPoint(x: 24, y: 41), controlPoint1: CGPoint(x: 42, y: 32.94), controlPoint2: CGPoint(x: 33.94, y: 41))
        bezierPath.addCurve(to: CGPoint(x: 6, y: 23), controlPoint1: CGPoint(x: 14.06, y: 41), controlPoint2: CGPoint(x: 6, y: 32.94))
        bezierPath.addCurve(to: CGPoint(x: 14.17, y: 7.92), controlPoint1: CGPoint(x: 6, y: 16.69), controlPoint2: CGPoint(x: 9.25, y: 11.13))
        bezierPath.addCurve(to: CGPoint(x: 24, y: 5), controlPoint1: CGPoint(x: 17, y: 6.07), controlPoint2: CGPoint(x: 20.37, y: 5))
        bezierPath.addCurve(to: CGPoint(x: 42, y: 23), controlPoint1: CGPoint(x: 33.94, y: 5), controlPoint2: CGPoint(x: 42, y: 13.06))
        bezierPath.close()
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        color.setFill()
        bezierPath.fill()
        context.restoreGState()

        UIColor.lightGray.setStroke()
        bezierPath.lineWidth = 0.25
        bezierPath.stroke()


        if (isRecording) {
            //// Oval Drawing
            let ovalPath = UIBezierPath(ovalIn: CGRect(x: 9, y: 8, width: 30, height: 30))
            context.saveGState()
            context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
            color3.setFill()
            ovalPath.fill()
            context.restoreGState()

            UIColor.gray.setStroke()
            ovalPath.lineWidth = 0.25
            ovalPath.stroke()
        }
        
        context.restoreGState()

    }

    @objc dynamic public class func drawRecordingView(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 128, height: 128), resizing: ResizingBehavior = .aspectFit, timeLabel: String = "00:00:00") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 128, height: 128), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 128, y: resizedFrame.height / 128)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.714)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0.5, y: 0.5, width: 127, height: 127), cornerRadius: 10)
        color.setFill()
        rectanglePath.fill()
        UIColor.lightGray.setStroke()
        rectanglePath.lineWidth = 1
        rectanglePath.stroke()


        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        UIColor.gray.setFill()
        bezierPath.fill()


        //// Text Drawing
        let textRect = CGRect(x: 1, y: 32, width: 126, height: 96)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: UIFont.labelFontSize),
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
        ] as [NSAttributedString.Key: Any]

        let textTextHeight: CGFloat = timeLabel.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        timeLabel.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()


        //// Text 2 Drawing
        let text2Rect = CGRect(x: 0, y: 0, width: 127, height: 37)
        let text2TextContent = "Auto Save"
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .center
        let text2FontAttributes = [
            .font: UIFont.systemFont(ofSize: UIFont.labelFontSize),
            .foregroundColor: UIColor.white,
            .paragraphStyle: text2Style,
        ] as [NSAttributedString.Key: Any]

        let text2TextHeight: CGFloat = text2TextContent.boundingRect(with: CGSize(width: text2Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text2FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: text2Rect)
        text2TextContent.draw(in: CGRect(x: text2Rect.minX, y: text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, width: text2Rect.width, height: text2TextHeight), withAttributes: text2FontAttributes)
        context.restoreGState()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 1, y: 29, width: 126, height: 3))
        UIColor.lightGray.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawSpeedView(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 103, height: 45), resizing: ResizingBehavior = .aspectFit, speedLabel: String = "75 mph") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 103, height: 45), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 103, y: resizedFrame.height / 45)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.714)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: 99, height: 41.5), cornerRadius: 5)
        color.setFill()
        rectanglePath.fill()
        UIColor.lightGray.setStroke()
        rectanglePath.lineWidth = 1
        rectanglePath.stroke()


        //// Text Drawing
        let textRect = CGRect(x: 2, y: 20, width: 99, height: 23)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: UIFont.labelFontSize),
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
        ] as [NSAttributedString.Key: Any]

        let textTextHeight: CGFloat = speedLabel.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        speedLabel.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()


        //// Text 2 Drawing
        let text2Rect = CGRect(x: 2, y: 2, width: 99, height: 16)
        let text2TextContent = "Speed"
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .center
        let text2FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.white,
            .paragraphStyle: text2Style,
        ] as [NSAttributedString.Key: Any]

        let text2TextHeight: CGFloat = text2TextContent.boundingRect(with: CGSize(width: text2Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text2FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: text2Rect)
        text2TextContent.draw(in: CGRect(x: text2Rect.minX, y: text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, width: text2Rect.width, height: text2TextHeight), withAttributes: text2FontAttributes)
        context.restoreGState()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 2, y: 18, width: 99, height: 2))
        UIColor.lightGray.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawSwitchButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50), resizing: ResizingBehavior = .aspectFit, cameraPressed: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 50, height: 50), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 50, y: resizedFrame.height / 50)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 50, resizedFrame.height / 50)


        //// Color Declarations
        let cameraClear = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.607)
        let clickedColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.332)
        let black = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.810)

        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 5

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 24.25, y: 8.25))
        bezierPath.addCurve(to: CGPoint(x: 14.78, y: 11.24), controlPoint1: CGPoint(x: 20.73, y: 8.25), controlPoint2: CGPoint(x: 17.46, y: 9.35))
        bezierPath.addCurve(to: CGPoint(x: 7.75, y: 24.75), controlPoint1: CGPoint(x: 10.53, y: 14.22), controlPoint2: CGPoint(x: 7.75, y: 19.16))
        bezierPath.addCurve(to: CGPoint(x: 24.25, y: 41.25), controlPoint1: CGPoint(x: 7.75, y: 33.86), controlPoint2: CGPoint(x: 15.14, y: 41.25))
        bezierPath.addCurve(to: CGPoint(x: 40.75, y: 24.75), controlPoint1: CGPoint(x: 33.36, y: 41.25), controlPoint2: CGPoint(x: 40.75, y: 33.86))
        bezierPath.addCurve(to: CGPoint(x: 24.25, y: 8.25), controlPoint1: CGPoint(x: 40.75, y: 15.64), controlPoint2: CGPoint(x: 33.36, y: 8.25))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 44.75, y: 24.75))
        bezierPath.addCurve(to: CGPoint(x: 24.25, y: 45.25), controlPoint1: CGPoint(x: 44.75, y: 36.07), controlPoint2: CGPoint(x: 35.57, y: 45.25))
        bezierPath.addCurve(to: CGPoint(x: 3.75, y: 24.75), controlPoint1: CGPoint(x: 12.93, y: 45.25), controlPoint2: CGPoint(x: 3.75, y: 36.07))
        bezierPath.addCurve(to: CGPoint(x: 11.42, y: 8.76), controlPoint1: CGPoint(x: 3.75, y: 18.29), controlPoint2: CGPoint(x: 6.74, y: 12.52))
        bezierPath.addCurve(to: CGPoint(x: 24.25, y: 4.25), controlPoint1: CGPoint(x: 14.93, y: 5.94), controlPoint2: CGPoint(x: 19.39, y: 4.25))
        bezierPath.addCurve(to: CGPoint(x: 44.75, y: 24.75), controlPoint1: CGPoint(x: 35.57, y: 4.25), controlPoint2: CGPoint(x: 44.75, y: 13.43))
        bezierPath.close()
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        black.setFill()
        bezierPath.fill()
        context.restoreGState()

        cameraClear.setStroke()
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()


        //// CameraIcon
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        context.beginTransparencyLayer(auxiliaryInfo: nil)


        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 27.62, y: 15.91))
        bezier2Path.addCurve(to: CGPoint(x: 29.25, y: 18.13), controlPoint1: CGPoint(x: 28.64, y: 16.27), controlPoint2: CGPoint(x: 29.25, y: 17.15))
        bezier2Path.addCurve(to: CGPoint(x: 29.25, y: 18.25), controlPoint1: CGPoint(x: 29.25, y: 18.25), controlPoint2: CGPoint(x: 29.25, y: 18.25))
        bezier2Path.addCurve(to: CGPoint(x: 29.25, y: 19.75), controlPoint1: CGPoint(x: 29.25, y: 18.25), controlPoint2: CGPoint(x: 29.25, y: 19.05))
        bezier2Path.addLine(to: CGPoint(x: 33.72, y: 19.75))
        bezier2Path.addCurve(to: CGPoint(x: 34.58, y: 19.82), controlPoint1: CGPoint(x: 34.16, y: 19.75), controlPoint2: CGPoint(x: 34.38, y: 19.75))
        bezier2Path.addCurve(to: CGPoint(x: 35.18, y: 20.38), controlPoint1: CGPoint(x: 34.88, y: 19.92), controlPoint2: CGPoint(x: 35.08, y: 20.12))
        bezier2Path.addCurve(to: CGPoint(x: 35.25, y: 21.28), controlPoint1: CGPoint(x: 35.25, y: 20.62), controlPoint2: CGPoint(x: 35.25, y: 20.84))
        bezier2Path.addLine(to: CGPoint(x: 35.25, y: 31.22))
        bezier2Path.addCurve(to: CGPoint(x: 35.18, y: 32.08), controlPoint1: CGPoint(x: 35.25, y: 31.66), controlPoint2: CGPoint(x: 35.25, y: 31.88))
        bezier2Path.addCurve(to: CGPoint(x: 34.62, y: 32.68), controlPoint1: CGPoint(x: 35.08, y: 32.38), controlPoint2: CGPoint(x: 34.88, y: 32.58))
        bezier2Path.addCurve(to: CGPoint(x: 33.72, y: 32.75), controlPoint1: CGPoint(x: 34.38, y: 32.75), controlPoint2: CGPoint(x: 34.16, y: 32.75))
        bezier2Path.addLine(to: CGPoint(x: 14.78, y: 32.75))
        bezier2Path.addCurve(to: CGPoint(x: 13.92, y: 32.68), controlPoint1: CGPoint(x: 14.34, y: 32.75), controlPoint2: CGPoint(x: 14.12, y: 32.75))
        bezier2Path.addCurve(to: CGPoint(x: 13.32, y: 32.12), controlPoint1: CGPoint(x: 13.62, y: 32.58), controlPoint2: CGPoint(x: 13.42, y: 32.38))
        bezier2Path.addCurve(to: CGPoint(x: 13.25, y: 31.22), controlPoint1: CGPoint(x: 13.25, y: 31.88), controlPoint2: CGPoint(x: 13.25, y: 31.66))
        bezier2Path.addLine(to: CGPoint(x: 13.25, y: 21.28))
        bezier2Path.addCurve(to: CGPoint(x: 13.32, y: 20.42), controlPoint1: CGPoint(x: 13.25, y: 20.84), controlPoint2: CGPoint(x: 13.25, y: 20.62))
        bezier2Path.addCurve(to: CGPoint(x: 13.88, y: 19.82), controlPoint1: CGPoint(x: 13.42, y: 20.12), controlPoint2: CGPoint(x: 13.62, y: 19.92))
        bezier2Path.addCurve(to: CGPoint(x: 14.78, y: 19.75), controlPoint1: CGPoint(x: 14.12, y: 19.75), controlPoint2: CGPoint(x: 14.34, y: 19.75))
        bezier2Path.addLine(to: CGPoint(x: 19.25, y: 19.75))
        bezier2Path.addCurve(to: CGPoint(x: 19.25, y: 18.25), controlPoint1: CGPoint(x: 19.25, y: 19.05), controlPoint2: CGPoint(x: 19.25, y: 18.25))
        bezier2Path.addLine(to: CGPoint(x: 19.25, y: 18.12))
        bezier2Path.addCurve(to: CGPoint(x: 20.78, y: 15.94), controlPoint1: CGPoint(x: 19.25, y: 17.15), controlPoint2: CGPoint(x: 19.86, y: 16.27))
        bezier2Path.addCurve(to: CGPoint(x: 22.31, y: 15.75), controlPoint1: CGPoint(x: 21.23, y: 15.8), controlPoint2: CGPoint(x: 21.65, y: 15.76))
        bezier2Path.addCurve(to: CGPoint(x: 22.53, y: 15.75), controlPoint1: CGPoint(x: 22.38, y: 15.75), controlPoint2: CGPoint(x: 22.45, y: 15.75))
        bezier2Path.addCurve(to: CGPoint(x: 23.02, y: 15.75), controlPoint1: CGPoint(x: 22.68, y: 15.75), controlPoint2: CGPoint(x: 22.85, y: 15.75))
        bezier2Path.addLine(to: CGPoint(x: 26.19, y: 15.75))
        bezier2Path.addCurve(to: CGPoint(x: 27.62, y: 15.91), controlPoint1: CGPoint(x: 26.58, y: 15.75), controlPoint2: CGPoint(x: 27.13, y: 15.75))
        bezier2Path.close()
        black.setFill()
        bezier2Path.fill()

        ////// Bezier 2 Inner Shadow
        context.saveGState()
        context.clip(to: bezier2Path.bounds)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((shadow.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let bezier2OpaqueShadow = (shadow.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: bezier2OpaqueShadow.cgColor)
        context.setBlendMode(.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        bezier2OpaqueShadow.setFill()
        bezier2Path.fill()

        context.endTransparencyLayer()
        context.endTransparencyLayer()
        context.restoreGState()

        cameraClear.setStroke()
        bezier2Path.lineWidth = 0.5
        bezier2Path.stroke()


        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 16, y: 21.5, width: 2, height: 2))
        cameraClear.setFill()
        ovalPath.fill()


        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 19.75, y: 21.75, width: 9, height: 9))
        cameraClear.setStroke()
        oval2Path.lineWidth = 0.5
        oval2Path.stroke()


        context.endTransparencyLayer()
        context.restoreGState()


        if (cameraPressed) {
            //// Oval 3 Drawing
            let oval3Path = UIBezierPath(ovalIn: CGRect(x: 3.75, y: 4.25, width: 41, height: 41))
            clickedColor.setFill()
            oval3Path.fill()
        }


        //// Group 2
        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 22, y: 23.73, width: 4, height: 4)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: -180 * CGFloat.pi/180, endAngle: -400 * CGFloat.pi/180, clockwise: true)

        UIColor.gray.setStroke()
        oval4Path.lineWidth = 1
        oval4Path.stroke()


        //// Polygon Drawing
        context.saveGState()
        context.translateBy(x: 26, y: 24.73)
        context.rotate(by: 134.71 * CGFloat.pi/180)

        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: -0, y: -1.5))
        polygonPath.addLine(to: CGPoint(x: -1.3, y: 0.75))
        polygonPath.addLine(to: CGPoint(x: 1.3, y: 0.75))
        polygonPath.close()
        UIColor.gray.setFill()
        polygonPath.fill()

        context.restoreGState()




        //// Group
        //// Oval 5 Drawing
        let oval5Rect = CGRect(x: 22.5, y: 25, width: 4, height: 4)
        let oval5Path = UIBezierPath()
        oval5Path.addArc(withCenter: CGPoint(x: oval5Rect.midX, y: oval5Rect.midY), radius: oval5Rect.width / 2, startAngle: -360 * CGFloat.pi/180, endAngle: -580 * CGFloat.pi/180, clockwise: true)

        UIColor.gray.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.stroke()


        //// Polygon 2 Drawing
        context.saveGState()
        context.translateBy(x: 22.5, y: 28)
        context.rotate(by: 134.71 * CGFloat.pi/180)

        let polygon2Path = UIBezierPath()
        polygon2Path.move(to: CGPoint(x: 0, y: 1.5))
        polygon2Path.addLine(to: CGPoint(x: 1.3, y: -0.75))
        polygon2Path.addLine(to: CGPoint(x: -1.3, y: -0.75))
        polygon2Path.close()
        UIColor.gray.setFill()
        polygon2Path.fill()

        context.restoreGState()
        
        context.restoreGState()

    }

    //// Generated Images

    @objc dynamic public class func imageOfSwitchButton(cameraPressed: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 50), false, 0)
            StyleKit.drawSwitchButton(cameraPressed: cameraPressed)

        let imageOfSwitchButton = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfSwitchButton
    }




    @objc(StyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}

