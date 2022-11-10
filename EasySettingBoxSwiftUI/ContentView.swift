//
//  ContentView.swift
//  TestApp
//
//  Created by Admin on 28/10/2022.
//

import SwiftUI
import Cocoa



extension NSScreen {
    class func externalScreens() -> [NSScreen] {
        let description: NSDeviceDescriptionKey = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
        return screens.filter {
            guard let deviceID = $0.deviceDescription[description] as? NSNumber else { return false }
            print(deviceID)
            return CGDisplayIsBuiltin(deviceID.uint32Value) == 0
        }
    }
}
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
func decToHexString(number:UInt8) -> String {
//        let result = decToHexStringFormat()
    var h1:String = "0x"
    if (number <= 16) {
        h1 += "0"
        h1 += String( number,radix: 16).uppercased()
    }
    else{
        h1 += String( number,radix: 16).uppercased()
    }
    
    return h1
}
func screenNames() -> [String] {
//  let externalScreens = NSScreen.externalScreens()
  var names = [String]()
  var object : io_object_t
  var serialPortIterator = io_iterator_t()
  let matching = IOServiceMatching("IODisplayConnect")

    let kernResult = IOServiceGetMatchingServices(kIOMainPortDefault,
                                                matching,
                                                &serialPortIterator)
  if KERN_SUCCESS == kernResult && serialPortIterator != 0 {
    repeat {
      object = IOIteratorNext(serialPortIterator)
      let info = IODisplayCreateInfoDictionary(object, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary as! [String:AnyObject]
      if let productName = info["DisplayProductName"] as? [String:String],
         let firstKey = Array(productName.keys).first {
            names.append(productName[firstKey]!)
      }
        if let displayEDID = info["IODisplayEDID"] as? Data {
            var edid = [String]()
            for data in displayEDID{

                edid.append(decToHexString(number: data))
            }
//            let array = Array(displayEDID)
            
            print("\(edid)" as String) // Result for my mac is "APP"       }
        }
    } while object != 0
  }
    //print(externalScreens.description)
    print(NSScreen.screens)
  IOObjectRelease(serialPortIterator)
    NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
                                           object: NSApplication.shared,
                                           queue: OperationQueue.main) {
        notification -> Void in
        print("screen parameters changed")
    }
  return names
}

struct ContentView: View {
    @State private var showDetails = false
    @State public var adjustGridStatus = false
    @State var showingPanel = false
    var body: some View {
        let names = screenNames()
        Spacer()
        VStack{
            HStack{
                Spacer()
                Text("")
                    .font(.system(size: 48))
                    .padding()
                Spacer()
            }
            Spacer()
            
            HStack{
                Button {
                    showingPanel.toggle()
               } label: {
                   ZStack{
                   Image("common_img_monitor_s_bg_sel")
                   Image("common_img_monitor_s_06")
                   //Text("Adjust")
                   }
                   
               }
               .buttonStyle(GrowingButton())
               .floatingPanel(isPresented: $showingPanel, content: {
//                   VisualEffectView(material: .fullScreenUI,blendingMode: .behindWindow, state:.active,emphasized: false)
//                           ZStack {
//                               Rectangle()
//                                   .fill(.white)
//                               Text("I'm a floating panel. Click anywhere to dismiss me.")
//                                   .foregroundColor(.brown)
//                           }
                   GeometryReader { geometry in
                               VStack {
                                   Text("\(geometry.size.width) x \(geometry.size.height)")
                               }.frame(width: geometry.size.width, height: geometry.size.height)
                                   Path { path in
                                       path.move(to: CGPoint(x: 0, y: 10))
                                       path.addLine(to: CGPoint(x: geometry.size.width , y: 10))
                       //                path.addLine(to: CGPoint(x: 300, y: 300))
                       //                path.addLine(to: CGPoint(x: 200, y: 100))
                                       path.closeSubpath()
                                   }
                                   .stroke(.red, lineWidth: 10)
                           }
                       })
               
               
            }
            
            HStack {
                Spacer()
                Label("\(names[1])", systemImage: "display")
                Spacer()
            }
            
            Button{
                adjustGridStatus = true
            } label: {
                ZStack{
                    Image("common_img_monitor_s_bg_nor")
                        .resizable()
                        .frame(width: 96.0, height: 40.0)
                    Text("Adjust Grid")
                        .padding()
                        .foregroundColor(Color.white)

                }
            }
            .buttonStyle(GrowingButton())
            GeometryReader { geometry in
                        VStack {
                            Text("\(geometry.size.width) x \(geometry.size.height)")
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 10))
                                path.addLine(to: CGPoint(x: geometry.size.width , y: 10))
                //                path.addLine(to: CGPoint(x: 300, y: 300))
                //                path.addLine(to: CGPoint(x: 200, y: 100))
                                path.closeSubpath()
                            }
                            .stroke(.red, lineWidth: 10)
                    }
            
            Spacer()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

