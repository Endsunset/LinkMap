//
//  HelpShare.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/16.
//

import SwiftUI

struct HelpShare: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("Share Document")
                    .font(.largeTitle)
                    .bold()
                Text("Prepare to share the document.")
                    .font(.title3)
                Text("Overview")
                    .font(.title)
                    .bold()
                Text("Most applications does not support the sharing of documents with unqiue extension. In this tutorial, you will learn how to share such documents freely.")
                Text("Step 1")
                    .font(.title)
                    .bold()
                Text("To share the document, you need to compress it first, this will require the using of Files, a native application on iOS device.")
                Image("UI_Help_Share_Homepage")
                    .resizable()
                    .scaledToFit()
                Text("Step 2")
                    .font(.title)
                    .bold()
                Text("Once entered the app, find the document you want to compress, either by searching its name in the search bar on the top, or do as one pleases.")
                Image("UI_Help_Share_Files_Navigation")
                    .resizable()
                    .scaledToFit()
                Text("Step 3")
                    .font(.title)
                    .bold()
                Text("Press and hold the document for a while to bring out the tool bar.")
                Image("UI_Help_Share_Files_LinkMap")
                    .resizable()
                    .scaledToFit()
                Text("Step 4")
                    .font(.title)
                    .bold()
                Text("Press the Compress button to compress the document.")
                Image("UI_Help_Share_Files_Compress")
                    .resizable()
                    .scaledToFit()
                Text("Step 5")
                    .font(.title)
                    .bold()
                Text("Now there should be a .zip file on your screen, press and hold the file for a while to bring out the tool bar again.")
                Image("UI_Help_Share_Files_LinkMap_Compressed")
                    .resizable()
                    .scaledToFit()
                Text("Step 6")
                    .font(.title)
                    .bold()
                Text("Press the Share button, now you should be able to share the file freely.")
                Image("UI_Help_Share_Files_Share")
                    .resizable()
                    .scaledToFit()
            }
            .padding()
        }
    }
}

#Preview {
    HelpShare()
}
