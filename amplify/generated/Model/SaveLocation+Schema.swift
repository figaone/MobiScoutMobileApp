// swiftlint:disable all
import Amplify
import Foundation

extension SaveLocation {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case TimeandDate
    case mobileappuserID
    case SaveLocationAndHealth
    case SaveLocationAndInitialVehicle
    case SaveLocationAndMainSensorData
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let saveLocation = SaveLocation.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.syncPluralName = "SaveLocations"
    
    model.attributes(
      .index(fields: ["mobileappuserID"], name: "byMobileAppUser")
    )
    
    model.fields(
      .id(),
      .field(saveLocation.TimeandDate, is: .optional, ofType: .string),
      .field(saveLocation.mobileappuserID, is: .optional, ofType: .string),
      .belongsTo(saveLocation.SaveLocationAndHealth, is: .optional, ofType: InitialHealthData.self, targetName: "saveLocationSaveLocationAndHealthId"),
      .belongsTo(saveLocation.SaveLocationAndInitialVehicle, is: .optional, ofType: InitialVehicleData.self, targetName: "saveLocationSaveLocationAndInitialVehicleId"),
      .hasMany(saveLocation.SaveLocationAndMainSensorData, is: .optional, ofType: MainSensorData.self, associatedWith: MainSensorData.keys.savelocationID),
      .field(saveLocation.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(saveLocation.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
