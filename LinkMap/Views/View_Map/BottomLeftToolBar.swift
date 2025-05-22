//
//  BottomLeftToolBar.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/7.
//

import SwiftUI
import MapKit

struct BottomLeftToolBar: View {
    @Binding var isAddingEnabled: Bool
    @Binding var mapStyle: MapView.MapStyleType
    
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
                    mapStyle = .imagery
                case .imagery:
                    mapStyle = .hybrid
                case .hybrid:
                    mapStyle = .standard
                }
            } label: {
                SquareButtonLabel(systemName: "map")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    BottomLeftToolBar(
        isAddingEnabled: .constant(false),
        mapStyle: .constant(.standard)
    )
}
