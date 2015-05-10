import Foundation

public struct Configuration {
  public var shouldTrimFilePath: Bool = true
  public var logHandler: (message: String) -> () = { println($0) }
  public var colors: [Level: (foregroundColor: Color?, backgroundColor: Color?)] = [
    .Warning: (Color(red: 255, green: 150, blue: 0), nil),
    .Error: (Color(red: 255, green: 0, blue: 0), nil)
  ]
  public var minimumLevelToLog: Level? = .Verbose
  public var colorsEnabled: Bool = true
  
  public init() {
    
  }
}
