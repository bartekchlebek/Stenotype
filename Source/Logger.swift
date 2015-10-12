import Foundation

//MARK:Globals

private let queue = dispatch_queue_create("com.bartekchlebek.logger", DISPATCH_QUEUE_SERIAL)

private let xcodeColorsEnabled: Bool = {
  let envValue = getenv("XcodeColors")
  return envValue == nil ? false : NSString(CString: envValue, encoding: NSUTF8StringEncoding) == "YES"
}()

public enum Level: Int {
  case Verbose, Info, Warning, Error
}

public class LoggersManager {
  private var loggers = [Logger]()
  
  public init() {
    
  }
  
  public func addLogger(logger: Logger) {
    loggers.append(logger)
  }
  
  private func log<T>(
    file: StaticString,
    _ line: UInt,
    _ function: StaticString,
    @noescape _ message: () -> T,
    _ level: Level) {
      
      for logger in loggers {
        if logger.minimumLevelToLog?.rawValue > level.rawValue {
          return
        }
        
        let fileString = (logger.shouldTrimFilePath
          ? "\(file)".componentsSeparatedByString("/").last ?? "\(file)"
          : "\(file)")
        
        if logger.colorsEnabled {
          if xcodeColorsEnabled == false {
            print("To use colors in logs install XcodeColors plugin: https://github.com/robbiehanson/XcodeColors and call setenv(\"XcodeColors\", \"YES\", 0) after your app launches")
          }
          else {
            setenv("XcodeColors", "YES", 0)
          }
        }
        
        let messageValue = message()
        dispatch_sync(queue) {
          let entry = Entry(
            level: level,
            date: logger.shouldDisplayDate ? logger.dateFormatter(date: NSDate()) : nil,
            file: logger.shouldDisplayFile ? fileString : nil,
            line: logger.shouldDisplayLineNumber ? "\(line)" : nil,
            function: logger.shouldDisplayFunction ? "\(function)" : nil,
            message: "\(messageValue)"
          )
          let logString = logger.logFormatter(entry: entry)
          let colors = (logger.colorsEnabled && xcodeColorsEnabled) ? logger.colors[level] : nil
          let logStringWithColors = logString.withForegroundColor(colors?.foregroundColor, backgroundColor: colors?.backgroundColor)
          logger.logHandler(message: logString, messageWithColors: logStringWithColors)
        }
      }
  }
}

//MARK:Empty log syntax, e.g. log.verbose()
extension LoggersManager {
  public func verbose(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Verbose)
  }
  
  public func info(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Info)
  }
  
  public func warning(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Warning)
  }
  
  public func error(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Error)
  }
}

//MARK:Standard syntax with message
extension LoggersManager {
  public func verbose<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Verbose)
  }
  
  public func info<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Info)
  }
  
  public func warning<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Warning)
  }
  
  public func error<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Error)
  }
}

//MARK:Trailing closure syntax
extension LoggersManager {
  public func verbose(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Verbose)
  }
  
  public func info(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Info)
  }
  
  public func warning(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Warning)
  }
  
  public func error(
    file: StaticString = __FILE__,
    _ line: UInt = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Error)
  }
}

//MARK:XcodeColors plugin helpers
let escape = "\u{001b}["
let reset = escape + ";"   // Clear any foreground or background color

extension String {
  private func withForegroundColor(foregroundColor: Color?, backgroundColor: Color?) -> String {
    var string = ""
    
    if let color = foregroundColor {
      string += "\(escape)fg\(color.red),\(color.green),\(color.blue);"
    }
    if let color = backgroundColor {
      string += "\(escape)bg\(color.red),\(color.green),\(color.blue);"
    }
    
    string += "\(self)"
    
    if foregroundColor != nil || backgroundColor != nil {
      string += reset
    }
    
    return string
  }
}
