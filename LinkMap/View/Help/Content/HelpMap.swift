//
//  HelpMap.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/16.
//

import SwiftUI

struct HelpMap: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Map")
                    .font(.largeTitle)
                    .bold()
                Text("Map interface.")
                    .font(.title3)
                Image("UI_Help_Map_Interface")
                    .resizable()
                    .scaledToFit()
                
                Text("Basic Navigation")
                    .font(.title)
                    .bold()
                Text("Pinch to zoom in/out\nDrag to pan the map\nUse pitch toggle for 3D view")
                
                Text("Map Styles")
                    .font(.title)
                    .bold()
                Image(systemName: "map")
                    .padding()
                    .foregroundStyle(.blue)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Tap the map style button to cycle between:\nStandard (road map)\nImagery (satellite)\nHybrid (satellite with labels)")
                
                Text("Location Services")
                    .font(.title)
                    .bold()
                Text("The app will request location permission to show your current position (blue dot). Enable location services in Settings if needed.")
            }
            .padding()
        }
    }
}

#Preview {
    HelpMap()
}
