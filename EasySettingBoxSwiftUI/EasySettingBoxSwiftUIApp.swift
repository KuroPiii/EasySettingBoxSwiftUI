//
//  EasySettingBoxSwiftUIApp.swift
//  EasySettingBoxSwiftUI
//
//  Created by Admin on 04/11/2022.
//

import SwiftUI
class TransparentWindowView: NSView {
  override func viewDidMoveToWindow() {
      window?.backgroundColor = NSColor(red: 0.0, green: 0.6, blue: 0.6,alpha: 1.0)//.clear
    super.viewDidMoveToWindow()
  }
}

struct TransparentWindow: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView { return TransparentWindowView() }
   func updateNSView(_ nsView: NSView, context: Context) { }
}

@main
struct EasySettingBoxSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(TransparentWindow())
//                .background(TransparentWindow().ignoresSafeArea())
        }
        .windowStyle(.hiddenTitleBar)
    }
}
