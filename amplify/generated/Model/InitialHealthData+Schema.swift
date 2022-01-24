// swiftlint:disable all
import Amplify
import Foundation

extension InitialHealthData {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case heartRate
    case stepCount
    case distanceWalkedInMetres
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let initialHealthData = InitialHealthData.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.syncPluralName = "InitialHealthData"
    
    model.fields(
      .id(),
      .field(initialHealthData.heartRate, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(initialHealthData.stepCount, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(initialHealthData.distanceWalkedInMetres, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(initialHealthData.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(initialHealthData.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
