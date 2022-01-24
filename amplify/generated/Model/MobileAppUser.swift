// swiftlint:disable all
import Amplify
import Foundation

public struct MobileAppUser: Model {
  public let id: String
  public var UserAndData: List<SaveLocation>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      UserAndData: List<SaveLocation>? = []) {
    self.init(id: id,
      UserAndData: UserAndData,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      UserAndData: List<SaveLocation>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.UserAndData = UserAndData
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}