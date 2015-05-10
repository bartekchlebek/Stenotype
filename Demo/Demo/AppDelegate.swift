import Cocoa
import Stenotype

struct Size {
  var width = 0.0
}

let log = Logger()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    
    log.error(aNotification)
    log.verbose {
      println("A")
      return aNotification
    }
  }
}

