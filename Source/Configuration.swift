import Foundation

func filterNils<T>(array: [T?]) -> [T] {
  return array.filter { $0 != nil }.map { $0! }
}

func filterEmptyStrings(array: [String]) -> [String] {
  return array.filter { $0.characters.count > 0 }
}

let defaultDateFormatter = {() -> NSDateFormatter in
  let dateFormatter = NSDateFormatter()
  dateFormatter.dateStyle = .ShortStyle
  dateFormatter.timeStyle = .ShortStyle
  return dateFormatter
}()

public struct Logger {
  public typealias LogFormatter = (entry: Entry) -> String
  public typealias DateFormatter = (date: NSDate) -> String
  public typealias LogHandler = (message: String, messageWithColors: String) -> ()
  
  public var minimumLevelToLog: Level? = .Verbose
  
  public var logFormatter: LogFormatter = {entry in
    let fileAndLine = filterNils([entry.file, entry.line]).joinWithSeparator(":")
    return filterEmptyStrings(filterNils([entry.date, fileAndLine, entry.function, entry.message])).joinWithSeparator(" ")
  }
  
  public var dateFormatter: DateFormatter = {defaultDateFormatter.stringFromDate($0)}
  
  public var logHandler: LogHandler = {print($0.1)}
  
  public var colorsEnabled: Bool = true
  public var colors: [Level: (foregroundColor: Color?, backgroundColor: Color?)] = [
    .Warning: (Color(red: 255, green: 150, blue: 0), nil),
    .Error: (Color(red: 255, green: 0, blue: 0), nil)
  ]
  
  public var shouldTrimFilePath: Bool = true
  public var shouldDisplayDate: Bool = true
  public var shouldDisplayFile: Bool = true
  public var shouldDisplayLineNumber: Bool = true
  public var shouldDisplayFunction: Bool = true
  
  public init() {
    
  }
}

public struct Entry {
  public var level: Level
  public var date: String?
  public var file: String?
  public var line: String?
  public var function: String?
  public var message: String
}
