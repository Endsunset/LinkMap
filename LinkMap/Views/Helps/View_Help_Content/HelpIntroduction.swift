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
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("About LinkMap")
                    .font(.largeTitle)
                    .bold()
                Text("A quick introduction to LinkMap.")
                    .font(.title3)
                Text("Overview")
                    .font(.title)
                    .bold()
                Text("Discover how this new application has made it easier than ever for you to make annotations, distribute groups, and more.")
                Text("Map Interface")
                    .font(.title)
                    .bold()
                Text("The map interface provides several useful tools for you to view the map, and helps you to manage the annotations easily.")
                Image("UI_Help_Map_Interface")
                    .resizable()
                    .scaledToFit()
                Text("Annotation List")
                    .font(.title)
                    .bold()
                Text("The annotation list is where you review all the annotations you've added, see corresponding section for further details.")
                Image("UI_Help_Annotation_List")
                    .resizable()
                    .scaledToFit()
                Text("Group List")
                    .font(.title)
                    .bold()
                Text("The group list is where you review all the annotation you've added.")
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
