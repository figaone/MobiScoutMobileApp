// swiftlint:disable all
import Amplify
import Foundation

extension MainSensorData {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case latitude
    case longitude
    case accelerationX
    case accelerationY
    case accelerationZ
    case gyrodataX
    case gyrodataY
    case gyrodataZ
    case pitchData
    case rollData
    case yawData
    case quarternionX
    case quarternionY
    case quarternionZ
    case quarternionW
    case userAccelerationX
    case userAccelerationY
    case userAccelerationZ
    case timeStamp
    case unixTimeStamp
    case heartRateWearablePart
    case speedMobileDevice
    case speedVehicleOBD
    case rpmVehicleOBD
    case temperatureVehicleOBD
    case videoName
    case videoID
    case traveledDistanceInMetres
    case straightDistanceInMetres
    case header
    case altitude
    case savelocationID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let mainSensorData = MainSensorData.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.syncPluralName = "MainSensorData"
    
    model.attributes(
      .index(fields: ["savelocationID"], name: "bySaveLocation")
    )
    
    model.fields(
      .id(),
      .field(mainSensorData.latitude, is: .optional, ofType: .double),
      .field(mainSensorData.longitude, is: .optional, ofType: .double),
      .field(mainSensorData.accelerationX, is: .optional, ofType: .double),
      .field(mainSensorData.accelerationY, is: .optional, ofType: .double),
      .field(mainSensorData.accelerationZ, is: .optional, ofType: .double),
      .field(mainSensorData.gyrodataX, is: .optional, ofType: .double),
      .field(mainSensorData.gyrodataY, is: .optional, ofType: .double),
      .field(mainSensorData.gyrodataZ, is: .optional, ofType: .double),
      .field(mainSensorData.pitchData, is: .optional, ofType: .double),
      .field(mainSensorData.rollData, is: .optional, ofType: .double),
      .field(mainSensorData.yawData, is: .optional, ofType: .double),
      .field(mainSensorData.quarternionX, is: .optional, ofType: .double),
      .field(mainSensorData.quarternionY, is: .optional, ofType: .double),
      .field(mainSensorData.quarternionZ, is: .optional, ofType: .double),
      .field(mainSensorData.quarternionW, is: .optional, ofType: .double),
      .field(mainSensorData.userAccelerationX, is: .optional, ofType: .double),
      .field(mainSensorData.userAccelerationY, is: .optional, ofType: .double),
      .field(mainSensorData.userAccelerationZ, is: .optional, ofType: .double),
      .field(mainSensorData.timeStamp, is: .optional, ofType: .double),
      .field(mainSensorData.unixTimeStamp, is: .optional, ofType: .double),
      .field(mainSensorData.heartRateWearablePart, is: .optional, ofType: .double),
      .field(mainSensorData.speedMobileDevice, is: .optional, ofType: .string),
      .field(mainSensorData.speedVehicleOBD, is: .optional, ofType: .string),
      .field(mainSensorData.rpmVehicleOBD, is: .optional, ofType: .string),
      .field(mainSensorData.temperatureVehicleOBD, is: .optional, ofType: .string),
      .field(mainSensorData.videoName, is: .optional, ofType: .string),
      .field(mainSensorData.videoID, is: .optional, ofType: .string),
      .field(mainSensorData.traveledDistanceInMetres, is: .optional, ofType: .double),
      .field(mainSensorData.straightDistanceInMetres, is: .optional, ofType: .double),
      .field(mainSensorData.header, is: .optional, ofType: .string),
      .field(mainSensorData.altitude, is: .optional, ofType: .double),
      .field(mainSensorData.savelocationID, is: .optional, ofType: .string),
      .field(mainSensorData.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(mainSensorData.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
