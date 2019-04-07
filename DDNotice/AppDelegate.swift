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

    // 1.NSStatusItem
//    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    
    var statusItem:NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        // 1.
//        if let button = statusItem.button {
//            button.image = NSImage(named: "settings") //  状态栏图标名称
//            button.action = #selector(AppDelegate.ClickTopMenuBarItem(sender:))
//        }
        
        
        // 2.
       let isShowStaturBarTimeView = UserDefaults.standard.bool(forKey: UserDefaultSwitchShowStatusTimeView)
        
        if isShowStaturBarTimeView{
            let statusBar = NSStatusBar.system
            statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength) // 需要动态宽度的对象
            // 然后需要一个自定义view
            let timeStatusView = self.CreateTimeStaturView()
            statusItem.view = timeStatusView
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveNotiOpenStatusTimemMode), name: NSNotification.Name(NotiOpenPanelTimeViewMode), object: nil)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) { // 终止
        // Insert code here to tear down your application
        
        // 退出应用时，需要删掉。
        let statusBar = NSStatusBar.system
        //删除item
        statusBar.removeStatusItem(self.statusItem)
        
        
    }
    // hud 点击关闭 调用。:主窗口关闭时退出Cocoa应用程序
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
  
    
    @objc func ReceiveNotiOpenStatusTimemMode(objc: NSNotification){
        
        print("\(objc.object ?? "")")
        
         let value = objc.object as! Int
        
       
        
        if value == 1 {
            
                
                statusItem.view = self.CreateTimeStaturView()
 
//                statusItem.view = self.CreateTimeStaturView()
            
        }else{
            statusItem.view = nil
        }
        
    
        
        
        
        
        
    }
    
    func CreateTimeStaturView()->TimeStatusView{
        
        let timeStatusView = TimeStatusView.init(frame: NSRect.init(x: 0, y: 0, width: 90, height: 22));
        return timeStatusView
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

}

