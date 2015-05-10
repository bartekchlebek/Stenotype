import Foundation

//MARK:Globals

private let queue = dispatch_queue_create("com.bartekchlebek.logger", DISPATCH_QUEUE_SERIAL)

public enum Level: Int {
  case Verbose, Info, Warning, Error
}

public class Logger {
  public var configuration: Configuration
  
  public init(configuration: Configuration) {
    self.configuration = configuration
  }
  
  public convenience init() {
    self.init(configuration: Configuration())
  }
  
  private func log<T>(
    file: StaticString,
    _ line: UWord,
    _ function: StaticString,
    @noescape _ message: () -> T,
    _ level: Level) {
      
      if let minimumLevel = configuration.minimumLevelToLog {
        if minimumLevel.rawValue <= level.rawValue {
          
          let fileString: String
          if configuration.shouldTrimFilePath {
            fileString = "\(file)".componentsSeparatedByString("/").last ?? "\(file)"
          }
          else {
            fileString = "\(file)"
          }
          
          let messageValue = message()
          let date = NSDate().description
          dispatch_sync(queue, { () -> Void in
            let colors = self.configuration.colorsEnabled ? self.configuration.colors[level] : nil
            let message = "\(date) \(fileString):\(line) \(function) \(messageValue)".withForegroundColor(colors?.foregroundColor, backgroundColor: colors?.backgroundColor)
            self.configuration.logHandler(message: message)
          })
        }
      }
  }
}

//MARK:Empty log syntax, e.g. log.verbose()
extension Logger {
  public func verbose(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Verbose)
  }
  
  public func info(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Info)
  }
  
  public func warning(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Warning)
  }
  
  public func error(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, {""}, .Error)
  }
}

//MARK:Standard syntax with message
extension Logger {
  public func verbose<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Verbose)
  }
  
  public func info<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Info)
  }
  
  public func warning<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Warning)
  }
  
  public func error<T>(
    @autoclosure message: () -> T,
    _ file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__) {
      
      self.log(file, line, function, message, .Error)
  }
}

//MARK:Trailing closure syntax
extension Logger {
  public func verbose(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Verbose)
  }
  
  public func info(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Info)
  }
  
  public func warning(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
    _ function: StaticString = __FUNCTION__,
    @noescape trailingClosure: () -> Any) {
      
      self.log(file, line, function, trailingClosure, .Warning)
  }
  
  public func error(
    file: StaticString = __FILE__,
    _ line: UWord = __LINE__,
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
