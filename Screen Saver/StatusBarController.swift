//
//  StatusBarController.swift
//  WeatherApp
//
//  Created by Charlie Levine on 3/2/21.
//

import AppKit
import SwiftUI
import Foundation

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "Weather")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(togglePopover(sender: ))
            statusBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject) {
        let event = NSApp.currentEvent!
        print("hasOppened = \(AppDelegate.hasOpened)")
        if AppDelegate.hasOpened {
            if event.type == NSEvent.EventType.rightMouseUp {
                print("Start Screen Saver")
                if(popover.isShown) {
                    hidePopover(sender)
                }else {
        //            showPopover(sender)
                    let url = NSURL(fileURLWithPath: "/System/Library/CoreServices/ScreenSaverEngine.app", isDirectory: true) as URL
                    let path = "/bin"
                    let configuration = NSWorkspace.OpenConfiguration()
                    configuration.arguments = [path]
                    NSWorkspace.shared.openApplication(at: url,
                                                       configuration: configuration,
                                                       completionHandler: nil)
                }
            } else {
                print("Show Menu")
                if(popover.isShown) {
                    hidePopover(sender)
                }else {
                    showPopover(sender)
                }
            }
        }else {
            if(popover.isShown) {
                hidePopover(sender)
            }else {
                AppDelegate.hasOpened = true
                UserDefaults.standard.set(true, forKey: "hasOpened")
                showPopover(sender)
            }
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }
}
