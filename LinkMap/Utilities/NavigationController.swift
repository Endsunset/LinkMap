//
//  NavigationController.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/25.
//

import SwiftUI

class NavigationController: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedSheet: AnyView?
    @Published var isSheetPresented = false
    
    func present<Content: View>(_ view: Content) {
        presentedSheet = AnyView(view)
        isSheetPresented = true
    }
}
