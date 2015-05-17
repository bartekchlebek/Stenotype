import Foundation

func filterNils<T>(array: [T?]) -> [T] {
  return array.filter { $0 != nil }.map { $0! }
}

func filterEmptyStrings(array: [String]) -> [String] {
  return array.filter { count($0) > 0 }
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
    let fileAndLine = ":".join(filterNils([entry.file, entry.line]))
    return "\n".join(filterEmptyStrings(filterNils([entry.date, fileAndLine, entry.function, entry.message])))
  }
  
  public var dateFormatter: DateFormatter = {defaultDateFormatter.stringFromDate($0)}
  
  public var logHandler: LogHandler = {println($0.1)}
  
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
  var level: Level
  var date: String?
  var file: String?
  var line: String?
  var function: String?
  var message: String
}
