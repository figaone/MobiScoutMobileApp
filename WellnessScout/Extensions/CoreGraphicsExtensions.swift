//
//  CoreGraphicsExtensions.swift
//  WellnessScout
//
//  Created by Adu-Gyamfi, Kojo K [CCE E] on 9/3/22.
//

import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
  return CGPoint(x: left.x * right, y: left.y * right)
}

extension CGSize {
  var cgPoint: CGPoint {
    return CGPoint(x: width, y: height)
  }
}

extension CGPoint {
  var cgSize: CGSize {
    return CGSize(width: x, height: y)
  }
  
  func absolutePoint(in rect: CGRect) -> CGPoint {
    return CGPoint(x: x * rect.size.width, y: y * rect.size.height) + rect.origin
  }
}

extension CGRect {
    func scaled(to size: CGSize) -> CGRect {
        return CGRect(
            x: self.origin.x * size.width,
            y: self.origin.y * size.height,
            width: self.size.width * size.width,
            height: self.size.height * size.height
        )
    }
}
