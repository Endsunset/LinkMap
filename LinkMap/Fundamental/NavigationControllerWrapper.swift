//
//  NavigationControllerWrapper.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/18.
//

import SwiftUI

struct NavigationControllerWrapper<Content: View>: UIViewControllerRepresentable {
    // Use a closure to generate the content
    let content: () -> Content

    // Initialize with a @ViewBuilder closure
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let host = UIHostingController(rootView: content())
        
        // Critical adjustments:
        host.view.backgroundColor = .clear
        host.view.isOpaque = false
        
        let navController = UINavigationController(rootViewController: host)
        navController.view.backgroundColor = .clear
        navController.view.isOpaque = false
        navController.navigationBar.isHidden = true
        
        // Disable UIKit's edge appearance overrides
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = true
        
        return navController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

