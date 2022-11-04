//
//  ContentView.swift
//  TestApp
//
//  Created by Admin on 28/10/2022.
//

import SwiftUI
import Cocoa

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

struct ContentView: View {
    @State private var showDetails = false
    @State public var adjustGridStatus = false
    
    var body: some View {
        Spacer()
        VStack{
            HStack{
                Spacer()
                Text("ESB porting ")
                    .font(.system(size: 48))
                    .padding()
                Spacer()
            }
            Spacer()
            
            HStack{
                Button {
                   
               } label: {
                   ZStack{
                   Image("common_img_monitor_s_bg_sel")
                   Image("common_img_monitor_s_06")
//                   Text("ClickNow")
                   }
               }
               .buttonStyle(GrowingButton())
            }
            
            Spacer()
            
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
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
