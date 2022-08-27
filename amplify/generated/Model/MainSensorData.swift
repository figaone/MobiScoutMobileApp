// swiftlint:disable all
import Amplify
import Foundation

public struct MainSensorData: Model {
  public let id: String
  public var latitude: Double?
  public var longitude: Double?
  public var accelerationX: Double?
  public var accelerationY: Double?
  public var accelerationZ: Double?
  public var gyrodataX: Double?
  public var gyrodataY: Double?
  public var gyrodataZ: Double?
  public var pitchData: Double?
  public var rollData: Double?
  public var yawData: Double?
  public var quarternionX: Double?
  public var quarternionY: Double?
  public var quarternionZ: Double?
  public var quarternionW: Double?
  public var userAccelerationX: Double?
  public var userAccelerationY: Double?
  public var userAccelerationZ: Double?
  public var timeStamp: Double?
  public var unixTimeStamp: Double?
  public var heartRateWearablePart: Double?
  public var speedMobileDevice: String?
  public var speedVehicleOBD: String?
  public var rpmVehicleOBD: String?
  public var temperatureVehicleOBD: String?
  public var videoName: String?
  public var videoID: String?
  public var traveledDistanceInMetres: Double?
  public var straightDistanceInMetres: Double?
  public var header: String?
  public var altitude: Double?
  public var savelocationID: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      latitude: Double? = nil,
      longitude: Double? = nil,
      accelerationX: Double? = nil,
      accelerationY: Double? = nil,
      accelerationZ: Double? = nil,
      gyrodataX: Double? = nil,
      gyrodataY: Double? = nil,
      gyrodataZ: Double? = nil,
      pitchData: Double? = nil,
      rollData: Double? = nil,
      yawData: Double? = nil,
      quarternionX: Double? = nil,
      quarternionY: Double? = nil,
      quarternionZ: Double? = nil,
      quarternionW: Double? = nil,
      userAccelerationX: Double? = nil,
      userAccelerationY: Double? = nil,
      userAccelerationZ: Double? = nil,
      timeStamp: Double? = nil,
      unixTimeStamp: Double? = nil,
      heartRateWearablePart: Double? = nil,
      speedMobileDevice: String? = nil,
      speedVehicleOBD: String? = nil,
      rpmVehicleOBD: String? = nil,
      temperatureVehicleOBD: String? = nil,
      videoName: String? = nil,
      videoID: String? = nil,
      traveledDistanceInMetres: Double? = nil,
      straightDistanceInMetres: Double? = nil,
      header: String? = nil,
      altitude: Double? = nil,
      savelocationID: String? = nil) {
    self.init(id: id,
      latitude: latitude,
      longitude: longitude,
      accelerationX: accelerationX,
      accelerationY: accelerationY,
      accelerationZ: accelerationZ,
      gyrodataX: gyrodataX,
      gyrodataY: gyrodataY,
      gyrodataZ: gyrodataZ,
      pitchData: pitchData,
      rollData: rollData,
      yawData: yawData,
      quarternionX: quarternionX,
      quarternionY: quarternionY,
      quarternionZ: quarternionZ,
      quarternionW: quarternionW,
      userAccelerationX: userAccelerationX,
      userAccelerationY: userAccelerationY,
      userAccelerationZ: userAccelerationZ,
      timeStamp: timeStamp,
      unixTimeStamp: unixTimeStamp,
      heartRateWearablePart: heartRateWearablePart,
      speedMobileDevice: speedMobileDevice,
      speedVehicleOBD: speedVehicleOBD,
      rpmVehicleOBD: rpmVehicleOBD,
      temperatureVehicleOBD: temperatureVehicleOBD,
      videoName: videoName,
      videoID: videoID,
      traveledDistanceInMetres: traveledDistanceInMetres,
      straightDistanceInMetres: straightDistanceInMetres,
      header: header,
      altitude: altitude,
      savelocationID: savelocationID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      latitude: Double? = nil,
      longitude: Double? = nil,
      accelerationX: Double? = nil,
      accelerationY: Double? = nil,
      accelerationZ: Double? = nil,
      gyrodataX: Double? = nil,
      gyrodataY: Double? = nil,
      gyrodataZ: Double? = nil,
      pitchData: Double? = nil,
      rollData: Double? = nil,
      yawData: Double? = nil,
      quarternionX: Double? = nil,
      quarternionY: Double? = nil,
      quarternionZ: Double? = nil,
      quarternionW: Double? = nil,
      userAccelerationX: Double? = nil,
      userAccelerationY: Double? = nil,
      userAccelerationZ: Double? = nil,
      timeStamp: Double? = nil,
      unixTimeStamp: Double? = nil,
      heartRateWearablePart: Double? = nil,
      speedMobileDevice: String? = nil,
      speedVehicleOBD: String? = nil,
      rpmVehicleOBD: String? = nil,
      temperatureVehicleOBD: String? = nil,
      videoName: String? = nil,
      videoID: String? = nil,
      traveledDistanceInMetres: Double? = nil,
      straightDistanceInMetres: Double? = nil,
      header: String? = nil,
      altitude: Double? = nil,
      savelocationID: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.latitude = latitude
      self.longitude = longitude
      self.accelerationX = accelerationX
      self.accelerationY = accelerationY
      self.accelerationZ = accelerationZ
      self.gyrodataX = gyrodataX
      self.gyrodataY = gyrodataY
      self.gyrodataZ = gyrodataZ
      self.pitchData = pitchData
      self.rollData = rollData
      self.yawData = yawData
      self.quarternionX = quarternionX
      self.quarternionY = quarternionY
      self.quarternionZ = quarternionZ
      self.quarternionW = quarternionW
      self.userAccelerationX = userAccelerationX
      self.userAccelerationY = userAccelerationY
      self.userAccelerationZ = userAccelerationZ
      self.timeStamp = timeStamp
      self.unixTimeStamp = unixTimeStamp
      self.heartRateWearablePart = heartRateWearablePart
      self.speedMobileDevice = speedMobileDevice
      self.speedVehicleOBD = speedVehicleOBD
      self.rpmVehicleOBD = rpmVehicleOBD
      self.temperatureVehicleOBD = temperatureVehicleOBD
      self.videoName = videoName
      self.videoID = videoID
      self.traveledDistanceInMetres = traveledDistanceInMetres
      self.straightDistanceInMetres = straightDistanceInMetres
      self.header = header
      self.altitude = altitude
      self.savelocationID = savelocationID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}