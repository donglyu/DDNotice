//
//  PrefsViewController.swift
//  DDNotice
//
//  Created by donglyu on 17/4/4.
//  Copyright © 2017年 donglyu. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {

    
    @IBOutlet weak var isPlaySoundsCheckBtn: NSButton!
    
    @IBOutlet var msgView: NSTextView!
    

    @IBOutlet weak var tipForShowConfirmOK: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // restore UI
        let isPlaySounds = UserDefaults.standard.bool(forKey: UserDefaultIsPlaySounds)
        if UserDefaults.standard.object(forKey: UserDefaultIsPlaySounds) == nil || isPlaySounds  {
            isPlaySoundsCheckBtn.state = 1
        }else{
            isPlaySoundsCheckBtn.state = 0
        }
        
        
        let showMsg = UserDefaults.standard.string(forKey: UserDefaultMsgShow)
        
        if showMsg != nil {
            msgView.insertText(showMsg ?? "继续下一个项目咯！", replacementRange: NSRange.init(location: 0, length: 0))
        }else{
            msgView.insertText("继续下一个项目咯！", replacementRange: NSRange.init(location: 0, length: 0))
            
        }
        
        
        
        
        
        
        //
            
    
        
        
        
    }
    @IBAction func isPlaySoundsCheckBtnClick(_ sender: NSButton) {
        
        print("check box's state:\(sender.state)")
        
        UserDefaults.standard.set(sender.state, forKey: UserDefaultIsPlaySounds)
        UserDefaults.standard.synchronize()
    }
    
    
    @IBAction func msgConfirmBtnClick(_ sender: Any) {
        
        let customMsg = msgView.string;
        UserDefaults.standard.set(customMsg, forKey: UserDefaultMsgShow)
        UserDefaults.standard.synchronize()
        
        tipForShowConfirmOK.textColor = NSColor.blue
        let time: TimeInterval  = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.tipForShowConfirmOK.textColor = NSColor.clear
        }
        
    }

}
