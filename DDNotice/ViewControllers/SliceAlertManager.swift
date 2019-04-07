//
//  SliceAlertManager.swift
//  Slice
//
//  Created by donglyu on 2019/4/5.
//  Copyright © 2019 donglyu. All rights reserved.
//

import Cocoa

class SliceAlertManager: NSObject {

    
    static let sharedManager = SliceAlertManager()
    
    override init() {
        super.init()
    }
    
    
    
    func PopNormalAlertNoticeView() -> NSApplication.ModalResponse{
        
        
        print("Show Alert!")
        let myPopUp:NSAlert = NSAlert()

        myPopUp.messageText = "计时j结束"
        let showMsg = UserDefaults.standard.string(forKey: UserDefaultMsgShow) ?? ""
        
        myPopUp.informativeText = showMsg
        
        //
        myPopUp.alertStyle = NSAlert.Style.critical
        myPopUp.addButton(withTitle: "OK")
        
        let action = myPopUp.runModal()
        return action
    }
    
}
