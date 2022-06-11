//
//  ExportTab.swift
//  Loop
//
//  Created by Ally Rilling on 6/3/22.
//

import SwiftUI

struct ExportTab: View {
    var body: some View {
        VStack {
            Button(action: {print("sync to strava")} ) {Text("Sync to Strava")}
            Button(action: {print("export notes")} ) {Text("Export Notes")}
            Button(action: {print("export gpx")} ) {Text("Export GPX")}
        }
    }
}

struct ExportTab_Previews: PreviewProvider {
    static var previews: some View {
        ExportTab()
    }
}
