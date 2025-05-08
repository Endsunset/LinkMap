//
//  BottomLeftToolBar.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/7.
//

import SwiftUI
import MapKit

/*struct BottomLeftToolBar: View {
    @Binding var isAddingEnabled : Bool
    
    private enum MapStyleType {
        case standard, imagery, hybrid
    }
    
    @State private var mapStyle: MapStyleType // Initial style matches current .hybrid
    
    init(isAddingEnabled: Bool) {
        self.isAddingEnabled = isAddingEnabled
        self.mapStyle = .standard
    }
    
    var body: some View {
        VStack {
            Button {
                isAddingEnabled.toggle()
            } label: {
                SquareButtonLabel(systemName: isAddingEnabled ? "mappin" : "mappin.slash")
                    .padding(.vertical)
            }
            
            Button {
                switch mapStyle {
                case .standard:
                    mapStyle = .hybrid
                case .hybrid:
                    mapStyle = .imagery
                case .imagery:
                    mapStyle = .standard
                }
            } label: {
                SquareButtonLabel(systemName: "map")
            }
        }
        .padding(.horizontal)
    }
    
    private var currentMapStyle: MapStyle {
        switch mapStyle {
        case .standard:
            return MapStyle.standard(elevation: .realistic)
        case .imagery:
            return MapStyle.imagery(elevation: .realistic)
        case .hybrid:
            return MapStyle.hybrid(elevation: .realistic)
        }
    }
}

#Preview {
    BottomLeftToolBar(isAddingEnabled: false)
}*/
