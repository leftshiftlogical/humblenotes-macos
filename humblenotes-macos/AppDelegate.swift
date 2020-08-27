//
//  AppDelegate.swift
//  humblenotes-macos
//
//  Created by Frank Chiarulli Jr. on 8/26/20.
//  Copyright © 2020 Left Shift Logical, LLC. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient // should hide popover when focus switches to another app but doesn't ...
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "MenuIcon")
            button.action = #selector(togglePopover(_:))
        }
        
        // set popover to key so user does not have to click twice to
        // interact with popover content
        self.popover.contentViewController?.view.window?.becomeKey()
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                // fix for popover not closing on focus change
                // must always be called before self.popover.show
                // in order for applicationWillResignActive to be called
                NSApp.activate(ignoringOtherApps: true)
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        // fix for popover not closing on focus change
        if self.popover.isShown {
            self.popover.performClose(nil)
        }
    }
    
}
