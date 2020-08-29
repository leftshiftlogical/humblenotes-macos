//
//  Webview.swift
//  humblenotes
//
//  Created by Frank Chiarulli Jr. on 8/29/20.
//  Copyright © 2020 Left Shift Logical, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

public struct Webview {
    public typealias NSViewType = WKWebView

    let url: URL
    let webview = WKWebView()
    
    private func loadURL(url: URL) {
        let request = URLRequest(url: url)
        webview.load(request)
    }
}

#if os(macOS)
extension Webview: NSViewRepresentable {
    
    public func makeNSView(context: NSViewRepresentableContext<Webview>) -> WKWebView {
        self.loadURL(url: self.url)
        return webview
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<Webview>) { }
}
#endif

#if os(iOS)
extension Webview: UIViewRepresentable {

    public func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        self.loadURL(url: self.url)
        return webview
    }

    public func updateUIView(_ nsView: WKWebView, context: UIViewRepresentableContext<Webview>) { }
}
#endif
