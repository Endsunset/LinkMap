//
//  HelpGroupList.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/18.
//

import SwiftUI

struct HelpGroupList: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("Group List")
                    .font(.largeTitle)
                    .bold()
                Text("")
                    .font(.title3)
                Image("UI_Help_Group_List")
                    .resizable()
                    .scaledToFit()
                Text("Add and Delete")
                    .font(.title)
                    .bold()
                Text("The + button enables you creating new group, and the Edit button let you delete group, you can also slide the group to the left to delete them.")
                Text("Editing Details")
                    .font(.title)
                    .bold()
                Text("Tap on any group to view the details of the group.")
            }
            .padding()
        }
    }
}

#Preview {
    HelpGroupList()
}
