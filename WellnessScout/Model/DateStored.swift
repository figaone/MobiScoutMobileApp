// swiftlint:disable all
import Amplify
import Foundation

public struct DateStored: Model {
  public let id: String
  public var dateStored: String?
  public var driverMonitorURL: String?
  public var roadViewURL: String?
  public var sensorDataURL: String?
  public var initiaLHealthData: String?
  public var initialVehicleData: String?
  public var uploadStatus: Bool?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      dateStored: String? = nil,
      driverMonitorURL: String? = nil,
      roadViewURL: String? = nil,
      sensorDataURL: String? = nil,
      initiaLHealthData: String? = nil,
      initialVehicleData: String? = nil,
      uploadStatus: Bool? = nil) {
    self.init(id: id,
      dateStored: dateStored,
      driverMonitorURL: driverMonitorURL,
      roadViewURL: roadViewURL,
      sensorDataURL: sensorDataURL,
      initiaLHealthData: initiaLHealthData,
      initialVehicleData: initialVehicleData,
      uploadStatus: uploadStatus,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      dateStored: String? = nil,
      driverMonitorURL: String? = nil,
      roadViewURL: String? = nil,
      sensorDataURL: String? = nil,
      initiaLHealthData: String? = nil,
      initialVehicleData: String? = nil,
      uploadStatus: Bool? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.dateStored = dateStored
      self.driverMonitorURL = driverMonitorURL
      self.roadViewURL = roadViewURL
      self.sensorDataURL = sensorDataURL
      self.initiaLHealthData = initiaLHealthData
      self.initialVehicleData = initialVehicleData
      self.uploadStatus = uploadStatus
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}