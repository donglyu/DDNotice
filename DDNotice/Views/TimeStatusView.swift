//
//  TimeStatusView.swift
//  Slice
//
//  Created by donglyu on 2019/4/2.
//  Copyright © 2019 donglyu. All rights reserved.
//

import Cocoa
import SnapKit




class TimeStatusView: NSView, TimerDelegate {

    var showTextF:NSTextField!
    var statusButton:NSButton!
    
    var isCurrentRuning:Bool = false
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        DDTimer.shared.delegate = self
        
        self.wantsLayer = true // 这个属性重要
        self.layer?.backgroundColor = NSColor.init(red: 250/255.0, green: 178/255.0, blue: 123/255.0, alpha: 0.14).cgColor // 橙
//        NSColor.init(red: 133/255.0, green: 82/255.0, blue: 161/255.0, alpha: 1) // 紫色
        let image = NSImage.init(named: NSImage.Name("setting_white"))!
        statusButton = NSButton.init(image:image , target: self, action: #selector(clickStatusIconBtn))
        
        
  
        self.addSubview(statusButton)
        statusButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(22)
        }
        
        showTextF = NSTextField.init(frame: frame)
//        label1.backgroundColor = NSColor.purple
        self.addSubview(showTextF)
        showTextF.stringValue = "00:00:00"
        showTextF.textColor = NSColor.orange
            //NSColor.init(red: 29/255.0, green: 149/255.0, blue: 63/255.0, alpha: 1) // 绿色
            //NSColor.red
        showTextF.alignment = .center
        showTextF.isEnabled = false
        
        showTextF.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(statusButton.snp.right)
            make.right.equalTo(self)
        }
        
    }
    
    // 后续监听系统风格，设置这些文字颜色。
    
    @objc func clickStatusIconBtn(){
        print("click status icon btn......")
        
//        NotificationCenter.default.post(name: NSNotification.Name(NotiOpenPanelTimeView), object: nil)
        
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
        }
        
    }
    
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // 下面的方法也可设置背景色。
//        [[NSColor yellowColor] setFill];
//        NSRectFill(dirtyRect);
//
//        [super drawRect:dirtyRect];
        
        
    }
    
    
    
    // MARK : Timer Delegate
    
    
    func updateRemainingTime(remaining: CFAbsoluteTime) {
        let hours = Int.init(remaining/3600)
        let temp = remaining.truncatingRemainder(dividingBy: 3600)
        let minutes =  Int.init(temp/60)
        let seconds = Int.init(remaining.truncatingRemainder(dividingBy: 60)) //%60
        
        
        showTextF.stringValue = String.init(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
    
    func TimerEndAction() {
        SliceAlertManager.sharedManager.PopNormalAlertNoticeView()
        
        showTextF.stringValue = "00:00:00"
        
        NotificationCenter.default.post(name: NSNotification.Name(NotiOpenPanelTimeViewMode), object: nil)
    }
    
}
