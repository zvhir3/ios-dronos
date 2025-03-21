//
//  GifImage.swift
//  DronosUTM
//
//  Created by Hidayatul Nadhirah on 04/08/2023.
//  Copyright © 2023 DJI. All rights reserved.
//
import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
                webView.contentMode = .scaleAspectFit
                webView.clipsToBounds = true

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }

}

struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GifImage("bg")
//    .scaledToFill()
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .edgesIgnoringSafeArea(.all)
//    .background(Color.red)
    }
}
