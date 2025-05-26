//
//  DebugNavigationBar.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/25.
//

import SwiftUI

struct CustomStack<Content: View>: View {
    let title: String
    let content: Content
    @Environment(\.dismiss) private var dismiss
    
    public enum toolbarStyleType {
        case standard
        case sheet
        case new
    }
    
    @State private var toolbarStyle: toolbarStyleType
    
    init(title: String, toolbarStyle: toolbarStyleType, @ViewBuilder content: () -> Content) {
        self.title = title
        self.toolbarStyle = toolbarStyle
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom toolbar that looks like debug mode
            HStack(alignment: .center) {
                if toolbarStyle == .standard {
                    Spacer()
                    Text(title).font(.headline)
                    Spacer()
                } else if toolbarStyle == .sheet {
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                } else if toolbarStyle == .new {
                    Button("Delete") {
                        
                    }
                    Spacer()
                    Text(title).font(.headline)
                    Button("Save") {
                        
                    }
                }
            }
            .padding()
            .background(.clear)
            // Content
            content
        }
    }
}
