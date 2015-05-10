import Foundation

public struct Configuration {
  public var minimumLevelToLog: Level? = .Verbose
  
  public var logHandler: (message: String) -> () = { print($0) }
  
  public var colorsEnabled: Bool = true
  public var colors: [Level: (foregroundColor: Color?, backgroundColor: Color?)] = [
    .Warning: (Color(red: 255, green: 150, blue: 0), nil),
    .Error: (Color(red: 255, green: 0, blue: 0), nil)
  ]
  
  public var shouldTrimFilePath: Bool = true
  public var shouldDisplayFile: Bool = true
  public var shouldDisplayLineNumber: Bool = true
  public var shouldDisplayFunction: Bool = true
  
  public init() {
    
  }
}
