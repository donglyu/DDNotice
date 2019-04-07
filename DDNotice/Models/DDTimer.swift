//
//  DDTimer.swift
//  DDNotice
//
//  Created by donglyu on 17/3/19.
//  Copyright © 2017年 donglyu. All rights reserved.
//

import Cocoa

protocol TimerDelegate :NSObjectProtocol{ // 不写NSObjectProtocol 暂时不会报错, 但是写属性是无法写weak

    /// Timer update 回调方法
    ///
    /// - Parameter remaining: 剩余秒速
    func updateRemainingTime(remaining:CFAbsoluteTime)
    
    /// Timer结束方法
    func TimerEndAction()
}


class DDTimer: NSObject {

    static let shared = DDTimer()
    
    
    var activityTimer:Timer?
    var sleepTimer:Timer?
    
    var endTime:CFAbsoluteTime = 0.0
    
    // 当前timer是否处于生效中。
    public var isMainTimeInEffect = false
    
    weak var delegate:TimerDelegate?
    
    
    override init() {
        super.init()
    }
    
    
    func runSleepTimer(seconds:NSNumber) {
        
        endTime = CFAbsoluteTimeGetCurrent() + seconds.doubleValue;
        
        if (sleepTimer?.isValid) != nil {
            sleepTimer?.invalidate()
        }
    
        
        // schedule timer
        
        sleepTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        // save some power
        sleepTimer?.tolerance = 0.05
        
    }
    
    
    func abortSleepTimer() {
        if (sleepTimer?.isValid) != nil {
            sleepTimer?.invalidate()
        }
        
//        let appDel = (NSApplication.shared().delegate) as! AppDelegate
        
        delegate?.updateRemainingTime(remaining: 0.0)
        
        isMainTimeInEffect = false
    }
    
    @objc func updateTime(timer: Timer) {
        let remainingTime:CFAbsoluteTime = endTime - CFAbsoluteTimeGetCurrent()
        
        // TODO:通知
        delegate?.updateRemainingTime(remaining: remainingTime)
        
//        print("DDTimer's updateTime \(remainingTime)")
        NotificationCenter.default.post(name: NSNotification.Name(NotiTimerUpdate), object: remainingTime)
        

        if remainingTime < 0{
            self.abortSleepTimer()
            // 执行要做的操作. ShowAlert
            self.showAlert()
        }
        
    }
    
    func showAlert()  {

        NotificationCenter.default.post(name: NSNotification.Name(NotiTimerEndAction), object: nil)
        // call delegate method!
        delegate?.TimerEndAction()
        
    }
    
    
    func runSystemActivityTimer()  {
        if (activityTimer?.isValid)! {
            activityTimer?.invalidate()
        }
        
        activityTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(systemActivity), userInfo: nil, repeats: true)
        activityTimer?.tolerance = 1.0
        
    }
    
    func PauseTimer(){
        sleepTimer?.fireDate = NSDate.distantFuture
    }
    
    func ContinueTimer(){
        sleepTimer?.fireDate = NSDate() as Date
    }
    
    
}


// MARK: Private
extension DDTimer{
    @objc func systemActivity()  {
        
    }
    
    func killSynstemActivityTimer()  {
        if (activityTimer?.isValid)! {
            activityTimer? .invalidate()
        }
        activityTimer = nil;
    }

}
