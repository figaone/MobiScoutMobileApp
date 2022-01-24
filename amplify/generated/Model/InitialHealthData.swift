// swiftlint:disable all
import Amplify
import Foundation

public struct InitialHealthData: Model {
  public let id: String
  public var heartRate: [Double?]?
  public var stepCount: [Double?]?
  public var distanceWalkedInMetres: [Double?]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      heartRate: [Double?]? = nil,
      stepCount: [Double?]? = nil,
      distanceWalkedInMetres: [Double?]? = nil) {
    self.init(id: id,
      heartRate: heartRate,
      stepCount: stepCount,
      distanceWalkedInMetres: distanceWalkedInMetres,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      heartRate: [Double?]? = nil,
      stepCount: [Double?]? = nil,
      distanceWalkedInMetres: [Double?]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.heartRate = heartRate
      self.stepCount = stepCount
      self.distanceWalkedInMetres = distanceWalkedInMetres
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}