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
extension AXUIElement {
    
    static func from(pid: pid_t) -> AXUIElement { AXUIElementCreateApplication(pid) }
    
    var windows: [AXUIElement]? { value(forAttribute: kAXWindowsAttribute) }
    
    var children: [AXUIElement]? { value(forAttribute: kAXChildrenAttribute) }
    
    func value<T>(forAttribute attribute: String) -> T? {
        var attributeValue: CFTypeRef?
        AXUIElementCopyAttributeValue(self, attribute as CFString, &attributeValue)
        return attributeValue as? T
    }
}
struct ContentView: View {
    @State private var showDetails = false
    @State public var adjustGridStatus = false
    @State var showingPanel = false
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    @State private var changeLine = false
    let screenSize: CGSize = (NSScreen.main?.frame.size)!
    @State private var yValue = 200.0
    @State private var insetAmount = 50.0
    @State var showMenu = false
    var detect = DetectActiveWindow(isActived: false)
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
//                    let win = NSApplication.shared.keyWindow
//                    let type = CGWindowListOption.optionOnScreenOnly
//                    let windowList = CGWindowListCopyWindowInfo(type, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]
//
//                    for entry  in windowList!
//                    {
//                      let owner = entry[kCGWindowOwnerName as String] as! String
////                      var bounds = entry[kCGWindowBounds as String] as? [String: Int]
//                      let pid = entry[kCGWindowOwnerPID as String] as? Int32
//                        print ("owner #\(owner)")
////                      if owner == "Safari"
////                      {
//                        let appRef = AXUIElementCreateApplication(pid!);  //TopLevel Accessability Object of PID
//
//                          let app = AXUIElement.from(pid: pid!)
//                          print ("====================================result #\(app.windows)")
//                          if let firstWindow = app.windows?.first{
//                              print ("====================================result #\(appRef)")
//                              print(firstWindow, firstWindow.children)
//                          }
//
//
//                        var value: AnyObject?
//                        let result = AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &value)
//
//                        if let windowList = value as? [AXUIElement]
//                        { print ("windowList #\(windowList)")
//                            if let window = windowList.first
//                          {
//                            var position : CFTypeRef
//                            var size : CFTypeRef
//                            var  newPoint = CGPoint(x: 0, y: 0)
//                            var newSize = CGSize(width: 800, height: 800)
//
//                            position = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!,&newPoint)!;
//                            AXUIElementSetAttributeValue(windowList.first!, kAXPositionAttribute as CFString, position);
//
//                            size = AXValueCreate(AXValueType(rawValue: kAXValueCGSizeType)!,&newSize)!;
//                            AXUIElementSetAttributeValue(windowList.first!, kAXSizeAttribute as CFString, size);
//                          }
//                        }
////                      }
//                    }
//                    let paths = ["/Users/admin/Downloads"]
//                    let fileURLs = paths.map{ URL(fileURLWithPath: $0)}
//                    NSWorkspace.shared.activateFileViewerSelecting(fileURLs)
                    detect.OnDetecting()
                    
//                    let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
//                    let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
//                    guard let infoList = windowListInfo as NSArray? as? [[String: AnyObject]] else { return }
//                    if let window = infoList.first(where: { ($0["kCGWindowNumber"] as? Int32) == 158}), let pid = window["kCGWindowOwnerPID"] as? Int32 {
//                        let app = NSRunningApplication(processIdentifier: pid)
//                        app?.activate(options: .activateIgnoringOtherApps)
//                    }
//                    if let windowInfo = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[ String : Any]] {
//                        print(windowInfo)
//                        for windowDict in windowInfo {
////                            print(windowDict)
////                            print("==============================================================")
//                            if let windowName = windowDict[kCGWindowOwnerName as String] as? String {
//                                if windowName == "Finder" {
//                                    print(windowDict[kCGWindowOwnerPID as String] as Any)
////                                    switchToAppName(named: windowName)
//                                    switchToAppID(withWindow: 417)
//                                }
////                                print(windowDict[kCGWindowOwnerPID as String])
//                            }
//                        }
//                    }
                    
                } label: {
                   ZStack{
                   Image("common_img_monitor_s_bg_sel")
                   Text("Test")
                   }
                   
               }
               .buttonStyle(GrowingButton())
                Button {
//                    let windown = NSApplication.keyWindow
                    let mousePosition = NSPoint(x: 100,y: 350)
                    let screenPosition: NSPoint = mousePosition
                    print(NSApplication.shared.keyWindow as Any)
                    print(NSWindow.windowNumber(at: screenPosition, belowWindowWithWindowNumber: 0))
                    if let windowInfo = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[ String : Any]] {
                        print(windowInfo)
//                        for windowDict in windowInfo {
////                            print(windowDict)
//                            print("==============================================================")
//                            if let windowName = windowDict[kCGWindowOwnerName as String] as? String {
//                                print(windowName)
//                                print(windowDict[kCGWindowOwnerPID as String])
//                            }
//                        }
                    }
                    showingPanel.toggle()
                    _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                        print("Timer fired!")
                        showingPanel.toggle()
                        changeLine.toggle()
                    }
                    
                } label: {
                   ZStack{
                   Image("common_img_monitor_s_bg_sel")
                   Image("common_img_monitor_s_06")
                   }
                   
               }
               .buttonStyle(GrowingButton())
               .floatingPanel(isPresented: $showingPanel, content: {

                   MovingLineContentView()
                   
               }
                              
               )
            }
            
            HStack {
                Spacer()
                Label("\(names[1])", systemImage: "display")
                Spacer()
            }
            
            Button{
                showingPanel.toggle()
                _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
//                    showingPanel.toggle()
                }
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
                                
                            }
                            .stroke(.red, lineWidth: 1)
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

func switchToAppID(withWindow windowNumber: Int32) {
    let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
    let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
    guard let infoList = windowListInfo as NSArray? as? [[String: AnyObject]] else { return }
    if let window = infoList.first(where: { ($0["kCGWindowNumber"] as? Int32) == windowNumber}), let pid = window["kCGWindowOwnerPID"] as? Int32 {
        let app = NSRunningApplication(processIdentifier: pid)
        app?.activate(options: .activateIgnoringOtherApps)
    }
}
func switchToAppName(named windowOwnerName: String) {
    let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
    let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
    guard let infoList = windowListInfo as NSArray? as? [[String: AnyObject]] else { return }

    if let window = infoList.first(where: { ($0["kCGWindowOwnerName"] as? String) == windowOwnerName}), let pid = window["kCGWindowOwnerPID"] as? Int32 {
        let app = NSRunningApplication(processIdentifier: pid)
        app?.activate(options: .activateIgnoringOtherApps)
    }
}

struct MovingLine: Shape {
    var yValue: Double
    
    var animatableData: Double{
        get { yValue }
        set { yValue = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x:0, y:yValue))
        path.addLine(to: CGPoint(x:rect.maxX , y:yValue))
        path.addLine(to: CGPoint(x:rect.maxX , y:yValue+50.0))
        path.addLine(to: CGPoint(x:0 , y:yValue+50.0))
        path.addLine(to: CGPoint(x:0 , y:yValue))
        return path
    }
}
class MouseYLocation : ObservableObject {
    @Published var yValue = 50.0
    
    init() {
        self.yValue = 50.0
    }
}
struct MovingLineContentView: View {
    @StateObject private var mouseY = MouseYLocation()
    @State private var yValue = 50.0
    @GestureState private var startPosition: CGPoint = .zero
    @State private var pt: CGPoint = .zero
    @State var showMenu = false
    @State private var point1: NSPoint = .zero
    @State private var point2: NSPoint = .zero
    var body: some View {
        let myGesture = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged{ gesture in
//                DispatchQueue.global().async {
//                    self.pt = gesture.startLocation
//                    print("left mouse: \(pt.y)")
//                }
//                DispatchQueue.main.async {
//                    withAnimation {
//                        yValue = Double(pt.y)
//                        print("yValue: \(yValue)")
//                    }
//                }
                _ = getScreenWithMouse()
//                print("\(String(describing: a))")
            }
                .onEnded({
                    self.pt = $0.startLocation
                        withAnimation {
                            yValue = Double(pt.y)
                        }
                })
                

                // Spacers needed to make the VStack occupy the whole screen
                return VStack {
                    GeometryReader { geometry in
                        //                        RightClickableSwiftUIView(onClick: $showMenu)
                        
                                                MovingLine(yValue: yValue)
                                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                                    .animation(.easeOut(duration: 0.1))//.linear(duration: 0.01))
                        
//                        Triangle(yValue: mouseY.yValue)
//                            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .trackingMouse { location in
////                                DispatchQueue.global().async {
//                                    self.point1 = location
//                                    mouseY.yValue = Double(location.y)
////                                }
//                            }
                        }
//                    Text("\(String(format: "X = %.0f, Y = %.0f", self.point1.x, mouseY.yValue))")//self.point1.y))")
                    
                }
                .border(Color.green)
                .contentShape(Rectangle()) // Make the entire VStack tappabable, otherwise, only the areay with text generates a gesture
                .gesture(myGesture) // Add the gesture to the Vstack
    }
}
//struct RightClickableSwiftUIView: NSViewRepresentable {
//    @Binding var onClick: Bool
//    func updateNSView(_ nsView: RightClickableView, context: NSViewRepresentableContext<RightClickableSwiftUIView>) {
//    }
//    func makeNSView(context: Context) -> RightClickableView {
//            RightClickableView(onClick: $onClick)
//    }
//}
//class RightClickableView : NSView {
//    @State private var pt: CGPoint = .zero
//        required init?(coder: NSCoder) {
//                fatalError("init(coder:) has not been implemented")
//        }
//        init(onClick: Binding<Bool>) {
//                _onClick = onClick
//                super.init(frame: NSRect())
//        }
//        @Binding var onClick: Bool
//        override func mouseDown(with theEvent: NSEvent) {
////            print("left mouse: \(NSEvent.mouseLocation.y)")
//        }
//        override func rightMouseDown(with theEvent: NSEvent) {
//                onClick = true
////                print("right mouse: \(NSEvent.mouseLocation.y)")
//        }
//}
func getScreenWithMouse() -> NSScreen? {
  let mouseLocation = NSEvent.mouseLocation
  let screens = NSScreen.screens
  let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

  return screenWithMouse
}
struct Triangle: Shape {
    var yValue: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x:0, y:yValue))
        path.addLine(to: CGPoint(x:rect.maxX , y:yValue))
        path.addLine(to: CGPoint(x:rect.maxX , y:yValue+50.0))
        path.addLine(to: CGPoint(x:0 , y:yValue+50.0))
        path.addLine(to: CGPoint(x:0 , y:yValue))

        return path
    }
}
extension View {
    func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
        TrackinAreaView(onMove: onMove) { self }
    }
}

struct TrackinAreaView<Content>: View where Content : View {
    let onMove: (NSPoint) -> Void
    let content: () -> Content
    
    init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onMove = onMove
        self.content = content
    }
    
    var body: some View {
        TrackingAreaRepresentable(onMove: onMove, content: self.content())
    }
}
struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    let onMove: (NSPoint) -> Void
    let content: Content
    
    func makeNSView(context: Context) -> NSHostingView<Content> {
        return TrackingNSHostingView(onMove: onMove, rootView: self.content)
    }
    
    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
    }
}

class TrackingNSHostingView<Content>: NSHostingView<Content> where Content : View {
    let onMove: (NSPoint) -> Void
    
    init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
        self.onMove = onMove
        
        super.init(rootView: rootView)
        
        setupTrackingArea()
    }
    
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
        self.addTrackingArea(NSTrackingArea.init(rect: .zero, options: options, owner: self, userInfo: nil))
    }
        
    override func mouseMoved(with event: NSEvent) {
        self.onMove(self.convert(event.locationInWindow, from: nil))
    }
}
