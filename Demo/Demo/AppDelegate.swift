import Cocoa
import Stenotype

struct Size {
  var width = 0.0
}

let log = LoggersManager()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    var c1 = Logger()
    var c2 = c1
    c2.shouldDisplayDate = false
    c2.minimumLevelToLog = .Warning
    
    log.addLogger(c1)
    log.addLogger(c2)
    
    log.error("ERROR")
    log.verbose {
      return "VERBOSE"
    }
  }
}

