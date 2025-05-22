//
//  SearchBar.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/10.
//

import SwiftUI
import MapKit

struct SearchBarView: View {
    @Binding var searchText: String
    var onCommit: () -> Void  // Add closure
    
    var body: some View {
        TextField("Search location", text: $searchText, onCommit: onCommit)  // Use closure
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .submitLabel(.done)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""), onCommit: {})  // Now valid
        .padding()
}
