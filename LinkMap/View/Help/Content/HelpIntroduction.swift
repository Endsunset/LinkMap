//
//  HelpIntroduction.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/16.
//

import SwiftUI

struct HelpIntroduction: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("About LinkMap")
                    .font(.largeTitle)
                    .bold()
                Text("A quick introduction to LinkMap.")
                    .font(.title3)
                Text("Map Interface")
                    .font(.title)
                    .bold()
                Image("UI_Help_Map_Interface")
                    .resizable()
                    .scaledToFit()
                Text("Annotation List")
                    .font(.title)
                    .bold()
                Image("UI_Help_Annotation_List")
                    .resizable()
                    .scaledToFit()
                Text("Group List")
                    .font(.title)
                    .bold()
                Image("UI_Help_Group_List")
                    .resizable()
                    .scaledToFit()
            }
            .padding()
        }
    }
}

#Preview {
    HelpIntroduction()
}
