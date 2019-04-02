//
//  DDTimer.swift
//  DDNotice
//
//  Created by donglyu on 17/3/19.
//  Copyright © 2017年 donglyu. All rights reserved.
//

import Cocoa

protocol TimerDelegate :NSObjectProtocol{ // 不写NSObjectProtocol 暂时不会报错, 但是写属性是无法写weak
    func updateRemainingTime(remaining:CFAbsoluteTime)
    func TimerEndAction()
}


class DDTimer: NSObject {

    
    var activityTimer:Timer?
    
    var sleepTimer:Timer?
    
    var endTime:CFAbsoluteTime = 0.0
    
    weak var delegate:TimerDelegate?
    
    
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
        
        
    }
    
    @objc func updateTime(timer: Timer) {
        let remainingTime:CFAbsoluteTime = endTime - CFAbsoluteTimeGetCurrent()
        
        delegate?.updateRemainingTime(remaining: remainingTime)
        
//        print("DDTimer's updateTime \(remainingTime)")

        if remainingTime<0{
            self.abortSleepTimer()
            
            // 执行要做的操作.....// 睡眠还是直接弹出提醒!
            self.showAlert()
        }
        
    }
    
    func showAlert()  {

        
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
