//
//  ViewController.swift
//  DDNotice
//
//  Created by donglyu on 17/3/18.
//  Copyright © 2017年 donglyu. All rights reserved.
//

import Cocoa
import AVFoundation
import NotificationCenter

class ViewController: NSViewController, TimerDelegate {

    @IBOutlet weak var hourLabel: NSTextField!
    @IBOutlet weak var minuteLabel: NSTextField!
    @IBOutlet weak var secondsLabel: NSTextField!
    
    @IBOutlet weak var abortBtn: NSButton!
    @IBOutlet weak var startBtn: NSButton!
    
    let timer = DDTimer()

    var soundPlayer : AVAudioPlayer?

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        [self.view setWantLayers:YES];
//        [self.view.layer setBackgroundColor:[[NSColor redColor] CGColor];
        self.view.layer?.backgroundColor = NSColor.black.cgColor
        
        hourLabel.stringValue = "00"
        minuteLabel.stringValue = "00"
        secondsLabel.stringValue = "00"
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: NSNotification.Name.NSTextDidChange , object: nil)
        
        timer.delegate = self
        
//        if let window? = self.view, let screen = window.screen {
//            let offsetFromLeftOfScreen: CGFloat = 20
//            let offsetFromTopOfScreen: CGFloat = 20
//            let screenRect = screen.visibleFrame
//            let newOriginY = CGRectGetMaxY(screenRect) - window.frame.height
//                - offsetFromTopOfScreen
//            window.setFrameOrigin(NSPoint(x: offsetFromLeftOfScreen, y: newOriginY))
//        }
        // 软件初始位置如何设置/
        
        
    }
    

    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func abortBtnClick(_ sender: Any) {
        timer.abortSleepTimer()
        // update Label str.
        self.setLabelEditable(editable: true)
        
    }

    @IBAction func startBtnClick(_ sender: Any) {
        let hour = hourLabel.integerValue
        let minute = minuteLabel.integerValue
        let seconds = secondsLabel.integerValue
        
        let timeInterval = ((hour*3600)+(minute*60)+seconds)
        if timeInterval > 0 {
            self.setLabelEditable(editable: false)
            timer .runSleepTimer(seconds: NSNumber(value: timeInterval))
        }
        
    }
}

extension ViewController{
    func textDidChanged(textfield:NSTextField)  {
        if hourLabel.stringValue.characters.count > 2 {
            let index = hourLabel.stringValue.index(hourLabel.stringValue.startIndex, offsetBy: 2)
            let value = hourLabel.stringValue.substring(to: index )
            hourLabel.stringValue = value;
        }
        if minuteLabel.stringValue.characters.count > 2 {
            let index = minuteLabel.stringValue.index(minuteLabel.stringValue.startIndex, offsetBy: 2)
            let value = minuteLabel.stringValue.substring(to: index)
            minuteLabel.stringValue  = value
        }
        if secondsLabel.stringValue.characters.count > 2 {
            let index = secondsLabel.stringValue.index(secondsLabel.stringValue.startIndex, offsetBy: 2)
            let value = secondsLabel.stringValue.substring(to: index)
            secondsLabel.stringValue  = value
        }
        
    }

    func setLabelEditable(editable:Bool)  {
        hourLabel.isEditable = editable
        minuteLabel.isEditable = editable
        secondsLabel.isEditable = editable
        hourLabel.isSelectable = editable
        minuteLabel.isSelectable = editable
        secondsLabel.isSelectable = editable
        
        if editable {
            hourLabel.stringValue = "00"
            minuteLabel.stringValue = "00"
            secondsLabel.stringValue = "00"
        }
        
    }
    
    // MARK: Delegate
    func updateRemainingTime(remaining: CFAbsoluteTime) {
        let hours = Int.init(remaining/3600)
        let temp = remaining.truncatingRemainder(dividingBy: 3600)
        let minutes =  Int.init(temp/60)
        let seconds = Int.init(remaining.truncatingRemainder(dividingBy: 60)) //%60
   
        
//        print("hours: \(hours) ,minutes: \(minutes),seconds: \(seconds)")
        
        hourLabel.stringValue = String.init(format: "%0.2d", hours)
        minuteLabel.stringValue = String.init(format: "%0.2d", minutes)
        secondsLabel.stringValue = String.init(format: "%0.2d", seconds)

    }
    
    func TimerEndAction() {
        setLabelEditable(editable: true)
        
        
        let isPlaySounds = UserDefaults.standard.integer(forKey:UserDefaultIsPlaySounds)
    
        if isPlaySounds == 1 || UserDefaults.standard.object(forKey: UserDefaultIsPlaySounds) == nil {
            self.prepareSound()
            self.playSound()
        }
        
        
        // MARK: Notification
        
//        let noti = NSNotification.init(name: NSNotification.Name(rawValue: "notiName"), object: nil)
//        NSNotification.init
//        // Notification End
        

        
        print("show Alert!")
        let myPopUp:NSAlert = NSAlert()
        myPopUp.messageText = "人就像弹簧，适时松一些未尝不好哦。"
        let showMsg = UserDefaults.standard.string(forKey: UserDefaultMsgShow) ?? ""
    
        myPopUp.informativeText = showMsg
        
            //
        myPopUp.alertStyle = NSAlertStyle.informational
        myPopUp.addButton(withTitle: "OK")
        //        myPopUp.addButton(withTitle: "Cancel")
        myPopUp.runModal()
        
        

        
    }


}

// MARK: Private Method!
extension ViewController{
    func prepareSound() {
        
        if soundPlayer != nil {
            return
        }
        
        guard let audioFileUrl = Bundle.main.url(forResource: "ding",
                                                 withExtension: "mp3") else {
                                                    return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }

    
    /*
     1. 选择本地音乐， 复制到沙盒文件中... // 文件选择框，获取路劲
     2. 播放音乐
     */
    
    
    //5-5 .play
    func prepareAndPlaySound(filePath: String) {
        
        //
        
    }
}
