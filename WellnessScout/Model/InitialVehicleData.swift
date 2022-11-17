// swiftlint:disable all
import Amplify
import Foundation

public struct InitialVehicleData: Model {
  public let id: String
  public var carModel: String?
  public var carOiLevel: String?
  public var carModelYear: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      carModel: String? = nil,
      carOiLevel: String? = nil,
      carModelYear: String? = nil) {
    self.init(id: id,
      carModel: carModel,
      carOiLevel: carOiLevel,
      carModelYear: carModelYear,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      carModel: String? = nil,
      carOiLevel: String? = nil,
      carModelYear: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.carModel = carModel
      self.carOiLevel = carOiLevel
      self.carModelYear = carModelYear
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}