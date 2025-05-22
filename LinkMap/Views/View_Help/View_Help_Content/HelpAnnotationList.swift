//
//  HelpAnnotationList.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/18.
//

import SwiftUI

struct HelpAnnotationList: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("Annotation List")
                    .font(.largeTitle)
                    .bold()
                Image("UI_Help_Group_List")
                    .resizable()
                    .scaledToFit()
                Text("Add and Delete")
                    .font(.title)
                    .bold()
                Text("The + button enables you creating new annotation, and the Edit button let you delete annotation, you can also slide the annotation to the left to delete them.")
                Text("Editing Details")
                    .font(.title)
                    .bold()
                Text("Tap on any annotation to view the details.")
            }
            .padding()
        }
    }
}

#Preview {
    HelpAnnotationList()
}
