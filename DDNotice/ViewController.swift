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

    @IBOutlet var TimingContainerView: NSView!
    @IBOutlet weak var TimingNSBox: NSBox!
    @IBOutlet weak var TimingFieldBoxContainerView: NSView!
    @IBOutlet weak var hourLabel: NSTextField!
    @IBOutlet weak var minuteLabel: NSTextField!
    @IBOutlet weak var secondsLabel: NSTextField!
    
    @IBOutlet weak var abortBtn: NSButton!
    @IBOutlet weak var startBtn: NSButton!

    
    let timer = DDTimer()

    var soundPlayer : AVAudioPlayer?

    var isTimeTick = false
    var shadow: NSShadow?
    
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
        
        shadow = NSShadow.init()
        shadow?.shadowColor = NSColor.clear
        shadow?.shadowBlurRadius = 7
        
        hourLabel.wantsLayer = true
        hourLabel.shadow = shadow
        minuteLabel.shadow = shadow;
        minuteLabel.wantsLayer = true
        secondsLabel.shadow = shadow;
        secondsLabel.wantsLayer = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: NSNotification.Name.NSTextDidChange , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: NSNotification.Name("AppBecomeActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: NSNotification.Name("AppResignActive"), object: nil)
        
        timer.delegate = self
        
        
        self.view.layer?.borderColor = NSColor.red.cgColor
        self.view.layer?.borderWidth = 0
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
        startBtn.title = "开始"
        
        self.view.layer?.borderWidth = 0
    }

    @IBAction func startBtnClick(_ sender: Any) {
        
        if isTimeTick { // 点击暂停按钮
            startBtn.title = "继续"
            timer.PauseTimer()
            isTimeTick = false
            self.ChangeTextFiledShadowColor(color: NSColor.yellow)
            self.view.layer?.borderWidth = 2
        }else{ // 点击开始

            self.ChangeTextFiledShadowColor(color: NSColor.green)
            
            startBtn.title = "暂停"
            
            let hour = hourLabel.integerValue
            let minute = minuteLabel.integerValue
            let seconds = secondsLabel.integerValue
            
            let timeInterval = ((hour*3600)+(minute*60)+seconds)
            if timeInterval > 0 {
                self.setLabelEditable(editable: false)
                timer .runSleepTimer(seconds: NSNumber(value: timeInterval))
            }
        
            isTimeTick = true
            
            
            self.view.layer?.borderWidth = 0
        }
        
        
        
    }

    
}

extension ViewController{
//    override func controlTextDidBeginEditing(_ obj: Notification) {
//        TimingFieldBoxContainerView.layer?.backgroundColor = NSColor.clear.cgColor
//    }
    // MARK: Private
    func textDidChanged(textfield:NSTextField)  {
        if hourLabel.stringValue.count > 2 {
            let index = hourLabel.stringValue.index(hourLabel.stringValue.startIndex, offsetBy: 2)
            let value = hourLabel.stringValue.substring(to: index )
            hourLabel.stringValue = value;
        }
        if minuteLabel.stringValue.count > 2 {
            let index = minuteLabel.stringValue.index(minuteLabel.stringValue.startIndex, offsetBy: 2)
            let value = minuteLabel.stringValue.substring(to: index)
            minuteLabel.stringValue  = value
        }
        if secondsLabel.stringValue.count > 2 {
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
    
    func ChangeTextFiledShadowColor(color:NSColor){
        self.shadow?.shadowColor = color
        self.hourLabel.shadow = self.shadow
        self.minuteLabel.shadow = self.shadow
        self.secondsLabel.shadow = self.shadow
    }
    
    // MARK: Noti
    
    func appBecomeActive(){
        self.TimingFieldBoxContainerView.layer?.backgroundColor = NSColor.black.cgColor
        
        if isTimeTick{
            
        }else{
            self.ChangeTextFiledShadowColor(color: NSColor.yellow)
        }
    }
    
    func appResignActive(){
        
        if !isTimeTick {
            self.ChangeTextFiledShadowColor(color: NSColor.yellow)
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

        // uij
        
        
    }
    
    func TimerEndAction() {
        setLabelEditable(editable: true)
        self.view.wantsLayer = true

        
        TimingFieldBoxContainerView.layer?.backgroundColor = NSColor.red.cgColor

        self.ChangeTextFiledShadowColor(color: NSColor.clear)
        
        let isPlaySounds = UserDefaults.standard.integer(forKey:UserDefaultIsPlaySounds)
    
        if isPlaySounds == 1 || UserDefaults.standard.object(forKey: UserDefaultIsPlaySounds) == nil {
            self.prepareSound()
            self.playSound()
        }
        
        
        // MARK: Notification
        
//        let noti = NSNotification.init(name: NSNotification.Name(rawValue: "notiName"), object: nil)
//        NSNotification.init
//        // Notification End
        
        startBtn.title = "开始"
        isTimeTick = false
        
        print("show Alert!")
        let myPopUp:NSAlert = NSAlert()
        myPopUp.messageText = "要做的事完成了吗？" //人就像弹簧，适时松一些未尝不好哦。
        let showMsg = UserDefaults.standard.string(forKey: UserDefaultMsgShow) ?? ""
    
        myPopUp.informativeText = showMsg
        
            //
        myPopUp.alertStyle = NSAlertStyle.critical
        myPopUp.addButton(withTitle: "OK")
        
        //        myPopUp.addButton(withTitle: "Cancel")
        let action = myPopUp.runModal()
        
        if action == NSAlertFirstButtonReturn {
            self.TimingFieldBoxContainerView.layer?.backgroundColor = NSColor.black.cgColor
        }

        
    }


}

// MARK: Private Method!
extension ViewController{
    func prepareSound() {
        
        if soundPlayer != nil {
            return
        }
        
        guard let audioFileUrl = Bundle.main.url(forResource: "优美旋律结尾音效",
                                                 withExtension: "wav") else {
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
