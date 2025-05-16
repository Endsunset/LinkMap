//
//  Tutorial.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/10.
//

import SwiftUI

struct Help: View {
    var body: some View {
        List{
            NavigationLink("About LinkMap (Incomplete)") {
                HelpIntroduction()
            }
            NavigationLink("Map (Incomplete)") {
                HelpMap()
            }
            NavigationLink("Annotation (Incomplete)") {
                ScrollView {
                    Text("Incomplete")
                }
            }
            NavigationLink("Group (Incomplete)") {
                ScrollView {
                    Text("Incomplete")
                }
            }
            NavigationLink("Share Document") {
                HelpShare()
            }
        }
        .navigationTitle("Help")
    }
}

#Preview {
    NavigationStack {
        Help()
    }
}
