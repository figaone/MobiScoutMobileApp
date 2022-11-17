// swiftlint:disable all
import Amplify
import Foundation

public struct SaveLocation: Model {
  public let id: String
  public var TimeandDate: String?
  public var mobileappuserID: String?
  public var SaveLocationAndHealth: InitialHealthData?
  public var SaveLocationAndInitialVehicle: InitialVehicleData?
  public var SaveLocationAndMainSensorData: List<MainSensorData>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      TimeandDate: String? = nil,
      mobileappuserID: String? = nil,
      SaveLocationAndHealth: InitialHealthData? = nil,
      SaveLocationAndInitialVehicle: InitialVehicleData? = nil,
      SaveLocationAndMainSensorData: List<MainSensorData>? = []) {
    self.init(id: id,
      TimeandDate: TimeandDate,
      mobileappuserID: mobileappuserID,
      SaveLocationAndHealth: SaveLocationAndHealth,
      SaveLocationAndInitialVehicle: SaveLocationAndInitialVehicle,
      SaveLocationAndMainSensorData: SaveLocationAndMainSensorData,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      TimeandDate: String? = nil,
      mobileappuserID: String? = nil,
      SaveLocationAndHealth: InitialHealthData? = nil,
      SaveLocationAndInitialVehicle: InitialVehicleData? = nil,
      SaveLocationAndMainSensorData: List<MainSensorData>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.TimeandDate = TimeandDate
      self.mobileappuserID = mobileappuserID
      self.SaveLocationAndHealth = SaveLocationAndHealth
      self.SaveLocationAndInitialVehicle = SaveLocationAndInitialVehicle
      self.SaveLocationAndMainSensorData = SaveLocationAndMainSensorData
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}