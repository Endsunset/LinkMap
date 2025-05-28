//
//  VideoPlayer.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/27.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoName: String
    let videoExtension: String
    
    init(videoName: String, videoExtension: String) {
        self.videoName = videoName
        self.videoExtension = videoExtension
    }
    
    var body: some View {
        Group {
            if let url = Bundle.main.url(forResource: videoName, withExtension: videoExtension) {
                CustomVideoPlayer(videoURL: url)
                    .aspectRatio(16/9, contentMode: .fit) // Fits inside parent (may have empty space)
                    .frame(maxWidth: .infinity) // Expands to full width
            } else {
                Text("Video \(videoName).\(videoExtension) not found")
                    .foregroundColor(.red)
            }
        }
    }
}

struct CustomVideoPlayer: UIViewControllerRepresentable {
    let videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: videoURL)
        controller.showsPlaybackControls = true // Show play/pause buttons
        controller.entersFullScreenWhenPlaybackBegins = true // Auto-fullscreen (optional)
        controller.exitsFullScreenWhenPlaybackEnds = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#Preview {
    VideoPlayerView(videoName: "Introduction", videoExtension: ".mov")
}
