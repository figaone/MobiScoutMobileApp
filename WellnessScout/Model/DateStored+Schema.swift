// swiftlint:disable all
import Amplify
import Foundation

extension DateStored {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case dateStored
    case driverMonitorURL
    case roadViewURL
    case sensorDataURL
    case initiaLHealthData
    case initialVehicleData
    case uploadStatus
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let dateStored = DateStored.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.syncPluralName = "DateStoreds"
    
    model.fields(
      .id(),
      .field(dateStored.dateStored, is: .optional, ofType: .string),
      .field(dateStored.driverMonitorURL, is: .optional, ofType: .string),
      .field(dateStored.roadViewURL, is: .optional, ofType: .string),
      .field(dateStored.sensorDataURL, is: .optional, ofType: .string),
      .field(dateStored.initiaLHealthData, is: .optional, ofType: .string),
      .field(dateStored.initialVehicleData, is: .optional, ofType: .string),
      .field(dateStored.uploadStatus, is: .optional, ofType: .bool),
      .field(dateStored.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(dateStored.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
