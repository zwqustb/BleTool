//
//  DeviceTool.swift
//  MobileHealth
//
//  Created by boeDev on 2018/12/10.
//  Copyright © 2018 Jiankun Zhang. All rights reserved.
//
//
import UIKit

class DeviceTool: NSObject {
    static var m_systemSoundID: SystemSoundID = 0
    static let shareInstance = DeviceTool.init()
    var audioPlayer:AVAudioPlayer?
    //获取设备音量
    class func getVolume() -> Float {
        let audioSession = AVAudioSession.sharedInstance()
        try?audioSession.setActive(true)
        let currentVol = audioSession.outputVolume
        return currentVol
    }
    //获取手机剩余存储空间(GB)
    class func getUseableStorageSize()->CGFloat{
        let manager = FileManager.default
        do
        {
            //沙盒根路径
            let home = NSHomeDirectory() as NSString
            let attribute = try manager.attributesOfFileSystem(forPath: home as String)
            let freesize = attribute[FileAttributeKey.systemFreeSize]!as! Float
            print("here is freesize : \(freesize)")
            let freesizeGB = freesize/1024/1024/1024
            let freeSizetext = String(format: "%.1f",freesizeGB) + "GB"
            print("\(freeSizetext)")
            return CGFloat(freesizeGB)
        }catch{
            return 0
        }

        
    }
    //获取手机wifi名称
    class func getWifiName()->String{
        return WifiTools.getMAC().ssid
    }
    //播放短音频
    //第一种方式，简单的音频播放
    class func playSound(audioUrl: NSURL, isAlert: Bool , playFinish: ()->()) {
//        // 一. 获取 SystemSoundID
//        //   参数1: 文件路径
//        //   参数2: SystemSoundID, 指针
//        if m_systemSoundID != 0{
//            stopSound()
//        }
//        let urlCF = audioUrl as CFURL
//        var systemSoundID: SystemSoundID = 0
//        AudioServicesCreateSystemSoundID(urlCF, &systemSoundID)
//        //        AudioServicesDisposeSystemSoundID(systemSoundID)
//        // 二. 开始播放
//        m_systemSoundID = systemSoundID
//        if isAlert {
//            // 3. 带振动播放, 可以监听播放完成(模拟器不行)
//            AudioServicesPlayAlertSound(systemSoundID)
//        }else {
//            // 3. 不带振动播放, 可以监听播放完成
//            AudioServicesPlaySystemSound(systemSoundID)
//        }
//        playFinish()
        try?AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try?AVAudioSession.sharedInstance().setActive(true)
        let audioPlayer = try?AVAudioPlayer.init(contentsOf: audioUrl as URL)
        DeviceTool.shareInstance.audioPlayer = audioPlayer
        //设置音频对象播放的音量的大小
        audioPlayer?.volume = 1.0
        //设置音频播放的次数，-1为无限循环播放
        audioPlayer?.numberOfLoops = 0
        audioPlayer?.play()
        
    }
    class func stopSound(){
        DeviceTool.shareInstance.audioPlayer?.stop()
//        AudioServicesDisposeSystemSoundID(m_systemSoundID)
//        m_systemSoundID = 0
    }
}
