import Foundation

public struct Color {
  var red: UInt8
  var green: UInt8
  var blue: UInt8
  private let z: UInt8 = 0 // fix for issue described here http://stackoverflow.com/questions/30157538/exc-arm-da-align-on-device
  
  public init(red: UInt8, green: UInt8, blue: UInt8) {
    self.red = red
    self.green = green
    self.blue = blue
  }
}