//
//  ContentView.swift
//  Loop
//
//  Created by Ally Rilling on 1/13/22.
//

import SwiftUI

struct ContentView: View {
    let layouts = [LayoutX(layoutName: "Layout #1"), LayoutX(layoutName: "Layout #2"), LayoutX(layoutName: "Layout #3")]
    @State var selection: LayoutX?
    
    var body: some View {
        NavigationView {
            List(layouts, id: \.self, selection: $selection) { layout in
                LayoutRow(layout: layout).onTapGesture {
                    print()
                }
            }.navigationTitle("Layouts")
        }
    }
}

struct LayoutX: Identifiable, Hashable {
    var layoutName: String
    var id = UUID()
}

struct LayoutRow: View {
    var layout: LayoutX
    
    var body: some View {
        HStack {
            Text(layout.layoutName)
            Spacer()
        }.padding(.all)
        .border(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
