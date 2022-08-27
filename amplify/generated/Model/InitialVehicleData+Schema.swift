// swiftlint:disable all
import Amplify
import Foundation

extension InitialVehicleData {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case carModel
    case carOiLevel
    case carModelYear
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let initialVehicleData = InitialVehicleData.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.syncPluralName = "InitialVehicleData"
    
    model.fields(
      .id(),
      .field(initialVehicleData.carModel, is: .optional, ofType: .string),
      .field(initialVehicleData.carOiLevel, is: .optional, ofType: .string),
      .field(initialVehicleData.carModelYear, is: .optional, ofType: .string),
      .field(initialVehicleData.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(initialVehicleData.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
