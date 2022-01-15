//
//  FirstScreenConfigView.swift
//  Loop
//
//  Created by Ally Rilling on 1/13/22.
//

import SwiftUI

struct FirstScreenConfigView: View {
    @State var distance = true
    @State var duration = true
    @State var heartrate = true
    @State var pace = true
    
    var body: some View {
        VStack {
            Button(action: {
                print("sup")
            }, label: {
                Text("Edit")
            })
            
            List() {
                Toggle(isOn: $distance) {
                    Text("Distance")
                }
                
                Toggle(isOn: $duration) {
                    Text("Duration")
                }
                
                Toggle(isOn: $heartrate) {
                    Text("Heart Rate")
                }
                
                Toggle(isOn: $pace) {
                    Text("Pace")
                }
            }
            .font(.title)
            .navigationTitle("First Screen")
        }
    }
}

struct FirstScreenConfigView_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreenConfigView()
    }
}

