// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "79d369e1d134ef5577c92e5097cf49c6"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: MobileAppUser.self)
    ModelRegistry.register(modelType: SaveLocation.self)
    ModelRegistry.register(modelType: InitialHealthData.self)
    ModelRegistry.register(modelType: InitialVehicleData.self)
    ModelRegistry.register(modelType: MainSensorData.self)
    ModelRegistry.register(modelType: DateStored.self)
  }
}