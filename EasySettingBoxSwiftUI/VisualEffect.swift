//
//  VisualEffect.swift
//  EasySettingBoxSwiftUI
//
//  Created by Admin on 10/11/2022.
//

import Foundation
import SwiftUI

/// Bridge AppKit's NSVisualEffectView into SwiftUI
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State
    var emphasized: Bool
 
    func makeNSView(context: Context) -> NSVisualEffectView {
        context.coordinator.visualEffectView
    }
 
    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        context.coordinator.update(
            material: material,
            blendingMode: blendingMode,
            state: state,
            emphasized: emphasized
        )
    }
 
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
 
    class Coordinator {
        let visualEffectView = NSVisualEffectView()
 
        init() {
            visualEffectView.blendingMode = .behindWindow
        }
 
        func update(material: NSVisualEffectView.Material,
                        blendingMode: NSVisualEffectView.BlendingMode,
                        state: NSVisualEffectView.State,
                        emphasized: Bool) {
            visualEffectView.material = material
        }
    }
  }