//
//  Configuration.swift
//  Loop
//
//  Created by Ally Rilling on 6/3/22.
//

import SwiftUI

struct Configuration: View {
    var name:String
    @State var screens:Array<String>
    @State private var editMode = EditMode.inactive

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Included Screens")) {
                    ForEach( screens, id: \.self) {
                        Text("\($0)")
                    }.onMove { indexSet, offset in
                        screens.move(fromOffsets: indexSet, toOffset: offset)
                    }
                }
                Section("Excluded Sections") {
                    ForEach( screens, id: \.self) {
                        Text("\($0)")
                    }.onMove { indexSet, offset in
                        screens.move(fromOffsets: indexSet, toOffset: offset)
                    }
                }
            }
            .navigationBarTitle(Text(name))
            .navigationBarItems(leading: EditButton())
            .environment(\.editMode, $editMode)
        }
    }


}

//struct Configuration_Previews: PreviewProvider {
//    static var previews: some View {
//        Configuration(name: "al;ksjdf", screens: ["asdf"])
//    }
//}
