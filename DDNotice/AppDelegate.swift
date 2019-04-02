//
//  AppDelegate.swift
//  DDNotice
//
//  Created by donglyu on 17/3/18.
//  Copyright © 2017年 donglyu. All rights reserved.
//
/**
 状态栏图标相关： https://www.jianshu.com/p/988480268043 待实验
 
 */

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        if let button = statusItem.button {
            button.image = NSImage(named: "settings") //  状态栏图标名称
            button.action = #selector(AppDelegate.ClickTopMenuBarItem(sender:))
            
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) { // 终止
        // Insert code here to tear down your application
        
        
    }
    // hud 点击关闭 调用
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {

        /*
         OC:
         if self window isVisible
         returnNO
         
         return YES
         
         */
        return false;
    }
    
    func applicationDidHide(_ notification: Notification) {
        print("applicationDidHide")
    }
    
    func applicationDidUpdate(_ notification: Notification) {
//        print("applicationDidUpdate")
    }
    
//    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
//        print("applicationDockMenu")
//    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        print("applicationBecomeActive")
        
        NotificationCenter.default.post(name: NSNotification.Name("AppBecomeActive"), object: nil)
        
        
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        print("applicationDidResignActive")
        
        NotificationCenter.default.post(name: NSNotification.Name("AppResignActive"), object: nil)
    }
    
    
    @objc func ClickTopMenuBarItem(sender:AnyObject){ // AnyObject.
//        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
//        let quoteAuthor = "Mark Twain"
//
//        print("\(quoteText) — \(quoteAuthor)")
        
        
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let mainWindowController = storyboard.instantiateController(withIdentifier: "TimeFiled") as! NSWindowController
        
        if let timeWindow = mainWindowController.window {
            
            // 2
            let mainFieldCtrler = timeWindow.contentViewController as! ViewController
            
            // 3
//            let application = NSApplication.shared()
//            application.runModal(for: wordCountWindow)
            
//            wordCountWindow.close()
            
//            wordCountWindow .makeKey()
//            timeWindow.close()
//            timeWindow.orderOut(Any?.self) // 这个也可以。
//            timeWindow.orderFront(Any?.self)
            timeWindow.windowController?.close()
            timeWindow.windowController?.showWindow(Any?.self)
            
//            wordCountViewController.make
        }
    }

}

