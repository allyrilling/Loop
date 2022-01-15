//
//  ContentView.swift
//  Loop
//
//  Created by Ally Rilling on 1/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Rectangle()
                    .foregroundColor(.white)
                    .border(Color.blue)
                    .frame(width: 300, height: 430)
                    .padding()
                
                
                NavigationLink(destination: FirstScreenConfigView()) {
                        Text("First Screen")
                }.padding()
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: 200))
                
                NavigationLink(destination: FirstScreenConfigView()) {
                        Text("Second Screen")
                }.padding()
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: 200))
                
                NavigationLink(destination: FirstScreenConfigView()) {
                        Text("Controls Screen")
                }.padding()
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: 200))
                
            }.navigationTitle("Customize Interface")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
