//
//  WatchConfigTab.swift
//  Loop
//
//  Created by Ally Rilling on 6/3/22.
//

import SwiftUI

struct WatchConfigTab: View {
    
    var frameWidth: CGFloat = 400 / 2
    var frameHeight: CGFloat = 500 / 2
    
    @State var showControls = true
    @State var showNowPlaying = true
    
    var body: some View {
        
        // TODO: you should be able to add as many config as you want, edit them, and name them
        NavigationView {
            VStack {
                List() {
                    Section(header: Text("Data Configurations")) {
                        NavigationLink(destination:
                            Configuration(name: "Primary", screens: ["Heart Rate", "Distance"])
                        ) {
                               Text("Configuration 1")
                           }
                        NavigationLink(destination: HStack {
                            Text("Configuration 2")
                        }) {
                               Text("Configuration 2")
                           }
                        NavigationLink(destination: HStack {
                            Text("Configuration 3")
                        }) {
                               Text("Configuration 3")
                           }
                    }
                    
                    Section(header: Text("Screens")) {
                        NavigationLink(destination: HStack {
                            Text("Configure Controls Screen")
                        }) {
                            Toggle(isOn: $showControls, label: {Text("Show controls screen")})
                           }
                        Toggle(isOn: $showNowPlaying, label: {Text("Show now playing screen")})
                    }
                }
            }.navigationTitle("Watch Configuration")
        }
        
        
    }
}

struct WatchConfigTab_Previews: PreviewProvider {
    static var previews: some View {
        WatchConfigTab()
    }
}


/*
 VStack {
     HStack {
         Text("Screens")
             .font(.system(size: 60, design: .rounded))
             .fontWeight(.bold)
             .padding(.horizontal)
         Spacer()
     }

     // TODO: each one of these should be its own component so that it can be reused in the watch app
     // TODO: add selection and ordering mechanism
     // TODO: add combo views
     ScrollView() {
         VStack {
             HStack {
                 ZStack {
                     Rectangle()
                         .frame(width: frameWidth, height: frameHeight, alignment: .center)
                         .cornerRadius(20)
                     VStack {
                         Text("152")
                             .font(.system(size: 80, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.red)
                         HStack {
                             Image(systemName: "heart.fill")
                                 .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             Text("bpm")
                         }.font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                     }
                 }
                 ZStack {
                     Rectangle()
                         .frame(width: frameWidth, height: frameHeight, alignment: .center)
                         .cornerRadius(20)
                     VStack() {
                         Text("7.14")
                             .font(.system(size: 66, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.blue)
                             .fixedSize(horizontal: true, vertical: true)
                         Text("mi")
                             .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                     }
                 }
             }.padding(.horizontal)

             HStack {
                 ZStack {
                     Rectangle()
                         .frame(width: frameWidth, height: frameHeight, alignment: .center)
                         .cornerRadius(20)
                     VStack() {
                         Text("1:05:39")
                             .font(.system(size: 52, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.yellow)
                             .fixedSize(horizontal: true, vertical: true)
                         Text("elapsed time")
                             .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                     }
                 }

                 ZStack {
                     Rectangle()
                         .frame(width: frameWidth, height: frameHeight, alignment: .center)
                         .cornerRadius(20)
                     VStack() {
                         Text("7:54")
                             .font(.system(size: 66, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.mint)
                             .fixedSize(horizontal: true, vertical: true)
                         Text("avg pace")
                             .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                     }
                 }
             }.padding(.horizontal)

             HStack {
                 ZStack {
                     Rectangle()
                         .frame(width: frameWidth, height: frameHeight, alignment: .center)
                         .cornerRadius(20)
                     VStack() {
                         Text("7:32")
                             .font(.system(size: 66, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.orange)
                             .fixedSize(horizontal: true, vertical: true)
                         Text("current pace")
                             .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                     }
                 }

                 ZStack {
                     Rectangle()
                         .frame(width: frameWidth, height: frameHeight, alignment: .center)
                         .cornerRadius(20)
                     VStack() {
                         Text("1003")
                             .font(.system(size: 66, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.purple)
                             .fixedSize(horizontal: true, vertical: true)
                         Text("feet")
                             .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                         Text("current elevation")
                             .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                             .foregroundColor(.white)
                     }
                 }
             }.padding(.horizontal)

         }
         
     }
 }
 */
