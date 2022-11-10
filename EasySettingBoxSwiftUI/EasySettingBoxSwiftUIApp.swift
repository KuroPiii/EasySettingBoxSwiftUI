//
//  EasySettingBoxSwiftUIApp.swift
//  EasySettingBoxSwiftUI
//
//  Created by Admin on 04/11/2022.
//

import SwiftUI
class TransparentWindowView: NSView {
  override func viewDidMoveToWindow() {
    window?.backgroundColor = .clear
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
