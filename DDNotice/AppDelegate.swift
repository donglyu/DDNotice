//
//  AppDelegate.swift
//  DDNotice
//
//  Created by donglyu on 17/3/18.
//  Copyright © 2017年 donglyu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        
        
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
        return true;
    }
    
    func applicationDidHide(_ notification: Notification) {
        print("applicationDidHide")
    }
    
    func applicationDidUpdate(_ notification: Notification) {
        print("applicationDidUpdate")
    }
    
//    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
//        print("applicationDockMenu")
//    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        print("applicationBecomeActive")
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        print("applicationDidResignActive")
    }
    
    
    

}

