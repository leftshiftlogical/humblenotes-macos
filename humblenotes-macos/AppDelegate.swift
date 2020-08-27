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
    var statusItem: NSStatusItem!
    var statusMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()

        statusMenu = NSMenu()
        statusMenu.addItem(NSMenuItem(title: "Quit Humble Notes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient // this should hide popover when focus switches to another app but doesn't ...
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusItem.button {
            button.image = NSImage(named: "MenuIcon")
            button.action = #selector(handleStatusBarClick(_:))
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
        }
        // set popover to key so user does not have to click twice to
        // interact with popover content
        self.popover.contentViewController?.view.window?.becomeKey()
    }
    
    @objc func handleStatusBarClick(_ sender: AnyObject?) {
        let event = NSApp.currentEvent!

        switch event.type {
        case NSEvent.EventType.rightMouseDown:
            // HACK: once you set a menu any click will
            // activate it so set the menu, trigger a
            // synthetic click, then unset the menu
            // to allow other actions again
            statusItem.menu = statusMenu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        case NSEvent.EventType.leftMouseDown:
            self.showPopover(sender)
        default:
            // do nothing
            return
        }
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if self.popover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }
        
    func hidePopover(_ sender: AnyObject?) {
        self.popover.performClose(sender)
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            // fix for popover not closing on focus change
            // must always be called before self.popover.show
            // in order for applicationWillResignActive to be called
            NSApp.activate(ignoringOtherApps: true)
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        // fix for popover not closing on focus change
        if self.popover.isShown {
            self.popover.performClose(nil)
        }
    }
    
}
