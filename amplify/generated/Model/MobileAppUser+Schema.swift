// swiftlint:disable all
import Amplify
import Foundation

extension MobileAppUser {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case UserAndData
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let mobileAppUser = MobileAppUser.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.syncPluralName = "MobileAppUsers"
    
    model.fields(
      .id(),
      .hasMany(mobileAppUser.UserAndData, is: .optional, ofType: SaveLocation.self, associatedWith: SaveLocation.keys.mobileappuserID),
      .field(mobileAppUser.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(mobileAppUser.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
