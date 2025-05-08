//
//  SquareButtonLabel.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/5.
//

import SwiftUI

struct SquareButtonLabel: View {
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20) // Fixed icon size
            .animation(nil, value: systemName)
            .padding()
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 44, height: 44)
    }
}
