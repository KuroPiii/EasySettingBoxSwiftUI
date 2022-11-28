//
//  DetectActiveWindow.swift
//  EasySettingBoxSwiftUI
//
//  Created by Admin on 24/11/2022.
//

import Foundation
import SwiftUI
import Cocoa

class DetectActiveWindow {
     var isActived: Bool
    init(isActived: Bool){
        self.isActived = isActived
    }
    
    func OnDetecting() -> Bool {
        DispatchQueue.global().async {
            var count = 0
//            let win = NSApplication.shared.keyWindow
            let type = CGWindowListOption.optionOnScreenOnly
            let windowList = CGWindowListCopyWindowInfo(type, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]
            while (true) {
            for entry  in windowList!
            {
              let owner = entry[kCGWindowOwnerName as String] as! String
              let pid = entry[kCGWindowOwnerPID as String] as? Int32
                print ("owner #\(owner)")
//              if owner == "Terminal"
//              {
                let appRef = AXUIElementCreateApplication(pid!);  //TopLevel Accessability Object of PID

                var value: AnyObject?
                let result: AXError = AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &value)
//                let result = AXUIElementCopyAttributeValue(appRef, kAXFocusedWindowAttribute as CFString, &value)
                print ("====================================&value #\(String(describing: result))")
                if let windowList = value as? [AXUIElement]
                { print ("windowList #\(windowList)")
                  if let window = windowList.first
                  {
                    var position : CFTypeRef
                    var size : CFTypeRef
                    var  newPoint = CGPoint(x: 0, y: 0)
                    var newSize = CGSize(width: 800, height: 800)

                    position = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!,&newPoint)!;
                    AXUIElementSetAttributeValue(windowList.first!, kAXPositionAttribute as CFString, position);

                    size = AXValueCreate(AXValueType(rawValue: kAXValueCGSizeType)!,&newSize)!;
                    AXUIElementSetAttributeValue(windowList.first!, kAXSizeAttribute as CFString, size);
                  }
                }
//              }
            }

//                print("Count per second: \(count)")
                

                
//                let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
//                if let windowInfo = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[ String : Any]] {
////                    let a = windowInfo.first(where: { ($0["kCGWindowOwnerName"] as? String) })
//                        for windowDict in windowInfo {
////                            print("==============================================================")
//
//                            if let windowName = windowDict[kCGWindowOwnerName as String] as? String {
//                                print(windowName)
//                            }
//                        }
//                }
                sleep(5)
                count+=1
            }
        }
        DispatchQueue.main.async {
            print(NSApplication.shared.keyWindow as Any)
            sleep(1)
        }
        return false
        
    }
    func showWindow() {
        var windowRef:NSWindow
        windowRef = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
//        windowRef.contentView = NSHostingView(rootView: MyView(myWindow: windowRef))
        windowRef.makeKeyAndOrderFront(nil)
    }
}
