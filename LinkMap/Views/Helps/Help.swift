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
            NavigationLink("About LinkMap") {
                HelpIntroduction()
            }
            NavigationLink("Map") {
                HelpMap()
            }
            NavigationLink("Annotation") {
                ScrollView {
                    HelpAnnotationList()
                }
            }
            NavigationLink("Group") {
                ScrollView {
                    HelpGroupList()
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
