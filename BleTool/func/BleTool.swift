//
//  BleTool.swift
//  BleTool
//
//  Created by boeDev on 2019/6/3.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit
import CoreBluetooth
class BleTool: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    static let shareInstence = BleTool.init()
    var centerManager:CBCentralManager?
    var m_pPeripheral:CBPeripheral?
    var m_dicData:NSDictionary?
    var m_pCharaterWrite:CBCharacteristic?
    var m_strReceivedStr = NSMutableString.init()
    var curLogicLine = "line1"
    weak var m_pVC:BleCmdVC?
    weak var m_pTestVC:CmdTestVC?
    var m_pLastSendDate:Date?
    var m_nErrorCount = 0
    var m_nErrorTotal = 0
    var m_strPackageTitle = ""
    func startScan()  {
        if centerManager == nil {
            addLog("初始化蓝牙引擎")
            centerManager = CBCentralManager.init(delegate: self, queue: .main)
            centerManager?.delegate = self
        }else{
            addLog("开始搜索设备")
            centerManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    func disconnectDevice(){
        if(m_pPeripheral != nil){
            addLog("主动断开与设备的连接")
            centerManager?.cancelPeripheralConnection(m_pPeripheral!)
            m_pPeripheral = nil
        }
    }
    //MARK:BLE delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            addLog("手机蓝牙打开,开始搜索设备")
            centerManager?.scanForPeripherals(withServices: nil, options: nil)
            break
        case .poweredOff:
            addLog("手机蓝牙关闭")
            break
        default:
            break
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var curName = peripheral.name
//        let needName = m_pVC?.m_aryCurData.first ?? ""
        if curName == nil{
            return
        }
        addLog("蓝牙搜到设备\(curName!)")
        var targetName = m_dicData?.getStr("bleName")
        if StringTool.isBlank(targetName) {
            addLog("参数中的名字不能为空")
            return
        }
//        curName = "BOE N-massager-"
//        targetName = "boe n-massager- "
        if curName!.lowercased().contains(targetName!) == true {
            addLog("停止搜索")
            central.stopScan()
//            m_pVC?.pDataClass.aryBtn[0] = "搜到并开始连接\(curName!)"
//            m_pVC?.arySupport[0] = 1
            let strBda = advertisementData["kCBAdvDataLocalName"] as? String ?? ""
//            m_pVC?.m_aryCurData[1] = strBda
            if strBda != ""{
//              m_pVC?.arySupport[1] = 1
            }
//            m_pVC?.tableView.reloadData()
            m_pPeripheral = peripheral
            addLog("开始连接\(curName ?? "")")
            centerManager?.connect(peripheral, options: nil)
            peripheral.delegate = self
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        addLog("\(peripheral.name ?? "")连接成功")
        centerManager?.stopScan()
        m_pVC?.pDataClass.aryBtn[0] = "设备已连接,断开连接?"
        m_pVC?.tableView.reloadData()
        peripheral.discoverServices(nil)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if  m_pPeripheral != nil{
            
        }else{
            addLog("\(peripheral.name ?? "")连接已断开")
            m_pVC?.pDataClass.aryBtn[0] = "开始搜索"
            m_pVC?.tableView.reloadData()
        }
        
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        addLog("\(peripheral.name ?? "")连接失败")
        m_pVC?.pDataClass.aryBtn[0] = "连接失败,重新搜索?"
        m_pVC?.tableView.reloadData()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        addLog("\(peripheral.name ?? "")发现了描述符\(characteristic.uuid)")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        var strSeverID =  m_dicData?["serviceID"] as? String ?? ""
        strSeverID = strSeverID.replacingOccurrences(of:" ", with: "")
        peripheral.services?.forEach({ (pCBService) in
            addLog("\(peripheral.name ?? "")发现了服务\(pCBService.uuid)")
            if pCBService.uuid.uuidString.lowercased().contains(strSeverID){
                addLog("开始搜索特征")
                peripheral.discoverCharacteristics(nil, for: pCBService)
            }
        })
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
       // let strCCCD = m_pVC?.m_aryCurData[21] ?? ""
        var writeCID = m_dicData?["setCID"] as? String ?? ""
        writeCID = writeCID.replacingOccurrences(of: " ", with:"")
        var readCID = m_dicData?["getCID"] as? String ?? ""
        readCID = readCID.replacingOccurrences(of: " ", with:"")
        service.characteristics?.forEach({ (pCBCharacteristic) in
            let strUUID = pCBCharacteristic.uuid.uuidString.lowercased()
//            addLog("\(peripheral.name ?? "")发现了特征\(strUUID)")
            if(strUUID.contains(writeCID)){
                addLog("发现了写ID:\(strUUID)")
                m_pCharaterWrite = pCBCharacteristic
                self.perform(#selector(startLogic), with: nil, afterDelay: 3)
            }else if(strUUID.contains(readCID)){
                addLog("发现了读ID:\(strUUID)")
                //peripheral.readValue(for: pCBCharacteristic)
                peripheral.setNotifyValue(true, for: pCBCharacteristic)
            }
        })
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("didWriteValueFor descriptor\(descriptor.uuid.uuidString)")
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValueFor characteristic\(characteristic.uuid.uuidString)")
    }
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        self.readDataFromCharacter(characteristic)
        if let error = error {
            print("订阅\(characteristic.uuid.uuidString)失败: \(error)")
            return
        }
        if characteristic.isNotifying {
            print("订阅\(characteristic.uuid.uuidString)成功")
        } else {
            print("取消\(characteristic.uuid.uuidString)订阅")
        }
    }
    //MARK:设置属性值保存
    @objc func startLogic(){
        let dicCurLine = getCurDicLine()
        let cmdKey = dicCurLine.getStr("type")
        switch cmdKey {
        case "send":
            let cmdTitle = dicCurLine.getStr("content")
             m_strPackageTitle = cmdTitle
            if !StringTool.isBlank(cmdKey) {
                let cmdValueReplaced = getReplacedStr(dicCurLine)
                writeData(cmdValueReplaced)
            }
        case "sendAll":
            let arySendCmd = m_dicData?["sendCmd"] as? [String] ?? []
            arySendCmd.forEach { (strCmd) in
                m_strPackageTitle = strCmd
                let cmdValueReplaced = getReplacedStr(dicCurLine)
                writeData(cmdValueReplaced)
            }
            break
        case "readData":
            m_strPackageTitle = dicCurLine.getStr("content")
            let cmdValueReplaced = getReplacedStr(dicCurLine)
            addReceiveLog(cmdValueReplaced)
            break
        default:
            break
        }
    }
    //客户端特性配置描述符(Client Characteristic Configuration Descriptor，CCCD) 里写值
    func writeToCCCD(_ characteristic:CBCharacteristic,_ strContent:String){
        let aryDescriptor = characteristic.descriptors ?? []
        //let data0 = strContent.hex2data()
        let bytes:[UInt8] = [0x02,0x00];
        let data0 = Data.init(bytes: bytes)
        for descriptor in aryDescriptor{
             print("d_UUID:\(descriptor.uuid.uuidString)")
            //if descriptor.uuid.uuidString == "2902"{
                self.m_pPeripheral?.writeValue(data0, for: descriptor)
           // }
        }
        self.m_pPeripheral?.writeValue(data0, for: characteristic, type: .withResponse)
    }
    //MARK:收到数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data = characteristic.value
                if data != nil{
        //            print("value = \(characteristic.value), len = \(characteristic.value?.count ?? 0)")
        //            print("/n")
                    let pCodeType = m_dicData?.getStr("codeType") ?? ""
                    if pCodeType == "hex" {
                        let str = data?.hexString()
                        if str != nil {
                            m_strReceivedStr.append(str!)
                            if m_strReceivedStr.hasPrefix("aa55") {
                               //攀高按摩仪为了不分包,硬件前边有8位与boe无关的前缀
                                let strCutted = m_strReceivedStr.substring(from: 8)
                                m_strReceivedStr = NSMutableString(string: strCutted)
                            }
                            self.handleReceiveData()
                        }
                    }else if pCodeType == "ascii"{
                        let str = String.init(data: data!, encoding: .ascii) ?? ""
                        m_strReceivedStr.append(str)
                        let strCmdEnd = m_dicData?.getStr("packetEnd") ?? ""
                        if m_strReceivedStr.hasSuffix(strCmdEnd) {
                            self.handleReceiveData()
                        }
                    }
                   
                }
    }
    //编写数据
    func sendDataByType(_ nType:NSInteger){
        var data = NSData.init()
        //生成字符串
        var cmd = ""
        switch nType {
        case 1:
            //同步时间
            cmd = m_pVC?.m_aryCurData[6] ?? ""
            
            break
        case 3:
            //获取电量
            cmd = m_pVC?.m_aryCurData[8] ?? ""
            break
        case 9:
            //开始测量
            cmd = m_pVC?.m_aryCurData[14] ?? ""
            break
        case 21:
            //二次握手
            cmd = m_pVC?.m_aryCurData[22] ?? ""
            break
        default:
            break
        }
        if StringTool.isBlank(cmd){
            return
        }
        var S_ID:String? = nil
        var C_ID:String? = nil
        let aryCmd = cmd.split(separator: "_")
        var content = String(aryCmd.last!)
        if aryCmd.count == 3 {
            S_ID = String(aryCmd[0])
            C_ID = String(aryCmd[1])
            content = String(aryCmd.last!)
        }
        //编码方式
        let cmdContent = self.handleSendStr(strIn: content)
        let strCodeType = m_pVC?.m_aryCurData[5] ?? ""
        switch strCodeType {
        case "Hex":
            data = cmdContent.hex2data()! as NSData
            break
        case "UInt8":
            break
        default:
            break
        }
        self.sendDataToDeviceByBle(data, S_ID: S_ID, C_ID: C_ID)
    }
    //处理发送的字符串,去掉空格,替换掉占位符
    func handleSendStr(strIn:String)->String{
        let str1 =  strIn.replacingOccurrences(of: " ", with: "")
        var strDate = DateTools.date2String(Date.init(), "yyyyMMddHHmmss")
        var str2 =  str1.replacingOccurrences(of: "yyyyMMddHHmmss", with: strDate)
        strDate = DateTools.date2String(Date.init(), "yyMMddHHmmss")
        str2 =  str2.replacingOccurrences(of: "yyMMddHHmmss", with: strDate)
        str2 = str2.replacingOccurrences(of: "Z", with: "0")
        
        let date = Date()
        let calendar = Calendar.current
        var comp = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second, .weekday, .nanosecond], from: date)
        let milisecond = comp.nanosecond!/1000000
//        let quiterValue = milisecond/256
//        let year_mso = comp.year! & 0xFF
//        let year_lso = (comp.year! >> 8) & 0xFF
        return str2
    }
    func writeTime(_ characteristic:CBCharacteristic){
        let date = Date()
        let calendar = Calendar.current
        var comp = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second, .weekday, .nanosecond], from: date)
        let milisecond = comp.nanosecond!/1000000
        let quiterValue = milisecond/256
        let year_mso = comp.year! & 0xFF
        let year_lso = (comp.year! >> 8) & 0xFF
        let ajjust_reason = 1
        
        let timeZone = calendar.component(.timeZone, from: date)
        let DSTZoon = Calendar.current.timeZone.isDaylightSavingTime()
        
        let Year_MSO = Int8(bitPattern: UInt8(year_mso))
        let Year_LSO = Int8(bitPattern: UInt8(year_lso))
        let MONTH = Int8(bitPattern: UInt8(comp.month!))
        let DAY = Int8(bitPattern: UInt8(comp.day!))
        let HOUR = Int8(bitPattern: UInt8(comp.hour!))
        let MINUTE = Int8(bitPattern: UInt8(comp.minute!))
        let SECOND = Int8(bitPattern: UInt8(comp.second!))
        let WEEKDAY = Int8(bitPattern: UInt8(comp.weekday!))
        let QUITERVALUE = Int8(bitPattern: UInt8(quiterValue))
        let AJRSON = Int8(bitPattern: UInt8(ajjust_reason))
        //Current Time Write on tag
        
        let currentTimeArray = [Year_MSO, Year_LSO, MONTH, DAY ,HOUR ,MINUTE ,SECOND , WEEKDAY , QUITERVALUE , AJRSON];
        let currentTimeArray_data = NSData(bytes: currentTimeArray, length: currentTimeArray.count)
        
        self.m_pPeripheral?.writeValue(currentTimeArray_data as Data, for:characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    //发送数据给某个服务里的某个特征
    func sendDataToDeviceByBle(_ pData:NSData,S_ID:String?,C_ID:String?){
        var strServices =  m_pVC?.m_aryCurData[2] ?? ""
        if S_ID != nil {
            strServices = S_ID!
        }
        var strWrite = m_pVC?.m_aryCurData[3] ?? ""
        if C_ID != nil {
            strWrite = C_ID!
        }
       // let strRead = m_pVC?.m_aryCurData[4] ?? ""
        if m_pPeripheral != nil{
            m_pPeripheral?.services?.forEach({ (pCBService) in
                if pCBService.uuid.uuidString == strServices{
                    m_pVC?.arySupport[2] = 1
                    m_pVC?.tableView.reloadData()
                    pCBService.characteristics?.forEach({ (pCBCharacteristic) in
                        if pCBCharacteristic.uuid.uuidString == strWrite{
                            m_pVC?.arySupport[3] = 1
                            m_pVC?.tableView.reloadData()
                            m_pPeripheral?.writeValue(pData as Data, for: pCBCharacteristic, type: .withoutResponse)
                            let aryCmd = self.m_pVC?.m_aryCurData[6].split(separator: "_")
                            //欧姆龙的写时间
                            if S_ID == String(aryCmd?.first ?? ""){
                                self.writeTime(pCBCharacteristic)
                            }
                        }
                    })
                }
            })
        }
    }
    //MARK:Tool func
    //向硬件发送数据,自动将字符串中的空格去掉
    func writeData(_ strCmd:String){
        let pCodeType = m_dicData?.getStr("codeType")
        if pCodeType == "hex" {
            var strCmdNoBlank = strCmd.replacingOccurrences(of: " ", with: "")
            if strCmdNoBlank == ""{
                return
            }
            let checkSumType = m_dicData?.getStr("checkSum") ?? ""
            if checkSumType != ""{
                 strCmdNoBlank = strCmdNoBlank.substring(to: strCmdNoBlank.count - 2)
                 strCmdNoBlank = strCmdNoBlank.appendCheckSum(checkSumType)
            }
            addSendLog("发送包标题\(m_strPackageTitle)内容:\(strCmdNoBlank)")
            let data = strCmdNoBlank.hex2data()! as Data
            if m_pCharaterWrite == nil{
                addLog("写特征没有找到")
            }else{
                 m_pPeripheral?.writeValue(data, for: m_pCharaterWrite!, type: .withoutResponse)
            }
        }else if pCodeType == "ascii" {
            if  m_pCharaterWrite != nil {
                    let strCmdNoBlank = strCmd.replacingOccurrences(of: " ", with: "")
                    if strCmdNoBlank.length<20{
                        let data = strCmdNoBlank.data(using: .ascii)
                        if data != nil{
                            addSendLog("发送内容:\(strCmd)")
                           // print("发送内容data:\(data!)")
                            m_pPeripheral?.writeValue(data!, for: m_pCharaterWrite!, type: .withResponse)
                        }
                    }else{
                        let allSendCount = Int(ceil(CGFloat(strCmdNoBlank.count)/20))
                        for i in 0..<allSendCount {
                            let cutBgn = i*20
                            let cutLength = min(20,strCmd.count-cutBgn)
                            let subCode = strCmdNoBlank.substring(from: cutBgn, length: cutLength)
                            let subData = subCode.data(using: .ascii)
                            if subData != nil{
                                addSendLog("发送内容:\(subCode)")
                                //print("发送内容data:\(subData!)")
                                m_pPeripheral?.writeValue(subData!, for: m_pCharaterWrite!, type: .withResponse)
                            }
                        }
                    }
               
            }
        }
        m_pLastSendDate = Date.init()
        let dicCurLine = getCurDicLine()
        m_nErrorTotal = dicCurLine.getInt("repeat")
        let nTimeOut = dicCurLine.getInt("timeout")
        if m_nErrorTotal > 0 && m_nErrorCount < m_nErrorTotal  {
           self.perform(#selector(resendData), with: nil, afterDelay: TimeInterval(nTimeOut))
        }
    }
    @objc func resendData(){
        m_nErrorCount += 1
        if m_pLastSendDate != nil {
            let sec = Date.init().timeIntervalSince(m_pLastSendDate!)
            if sec > 1 {
                self.startLogic()
            }
        }
    }
    func handleReceiveData(){
        m_pLastSendDate = nil
        let checkType = m_dicData?.getStr("checkSum")
        let bOk =  isCheckSumOk(m_strReceivedStr as String)
        var checkResult = bOk ? "校验成功" : "校验失败"
        if checkType == ""{
            checkResult = ""
        }
        let strLog = "\(m_strReceivedStr as String)\(checkResult)"
        addReceiveLog(strLog)
        let dicGotCmd = m_dicData?["GotCmd"] as? NSDictionary
        let arykeys = dicGotCmd?.allKeys
        let strNextLogic = ""
        arykeys?.forEach({ (pAny) in
            var strKey = pAny as? String ?? ""
            strKey = strKey.replacingOccurrences(of: " ", with: "")
            //匹配规则,需要优化
            if m_strReceivedStr.contains(strKey){
                var strValue = dicGotCmd?[strKey] as? String ?? ""
                if strValue.hasPrefix("print"){
                    let strCmdReceive = m_strReceivedStr as String
                    strValue = strValue.replacingOccurrences(of: "print", with:strCmdReceive)
                    addReceiveLog(strValue)
                }else{
                    curLogicLine = strValue
                    startLogic()
                    //strNextLogic = getNextLogicNameBy(strValue, m_strReceivedStr as String)
                }
            }
        })
        m_strReceivedStr = NSMutableString.init()
        if strNextLogic == "disconnect"{
            disconnectDevice()
        }else{
            curLogicLine = strNextLogic
            startLogic()
        }
    }
    func isCheckSumOk(_ str:String)->Bool{
        var strValue = str
        if strValue.hasPrefix("aa55") {
           //攀高按摩仪为了不分包,硬件前边有8位与boe无关的前缀
           strValue = strValue.substring(from: 8)
        }
        let strContent = strValue.substring(to: strValue.length - 2)
        let checkSumType = m_dicData?.getStr("checkSum") ?? ""
        let strCheckSum = strContent.appendCheckSum(checkSumType)
        if strValue == strCheckSum {
            return true
        }else{
            return false
        }
        
    }
    //MARK:自定义的函数
    //获取接受数据的固定格式的数组
    func onRecevicedBleData(_ strReceived:String,_ strCID:String){
        let aryData = m_pVC?.m_aryCurData ?? [""]
        if aryData.count != CmdLocalData.shareInstence.aryName.count {
            return
        }
        let strGotTimeRet = aryData[7]
        let strGotPowerRet = aryData[9]
        let strGotHistory = aryData[11]
        let strGotHistoryOver = aryData[13]
        let strStartRet = aryData[15]
        let strStopRet = aryData[17]
        let strMeasureRet = aryData[18]
        let strMeasuringData = aryData[19]
        let strErrorData = aryData[20]
        let strHandshake = aryData[23]
        if strReceived.pairTo(strGotTimeRet,CID: strCID){
            if strGotTimeRet.contains("WW"){
                let hexStr = strReceived.getPairValueBy(strGotTimeRet, "WW")
                let nInt = hexStr?.hex2Decimal() ?? -1
                if nInt == 0{
                    m_pVC?.pDataClass.aryBtn[7] = "设置时间成功"
                }else{
                    m_pVC?.pDataClass.aryBtn[7] = "设置时间失败,错误码:\(nInt)"
                }
            }else if strGotTimeRet.contains("yyyyMMddHHmmss"){
                 let hexStr = strReceived.getPairValueBy(strGotTimeRet, "yyyyMMddHHmmss")
                 m_pVC?.pDataClass.aryBtn[7] = "设备当前的时间是\(hexStr!)"
            }
        }
        if strReceived.pairTo(strGotPowerRet,CID: strCID){
            let hexPower = strReceived.getPairValueBy(strGotPowerRet, "pp")
            let nPower = hexPower?.hex2Decimal() ?? -1
            var strPower = ""
            if nPower != -1{
                strPower  = "电量:\(nPower)%,"
            }
            let hexLow = strReceived.getPairValueBy(strGotPowerRet, "WW")
            let nLow = hexLow?.hex2Decimal() ?? -1
            let strLow = nLow == 0 ? "不是" : "是"
            m_pVC?.pDataClass.aryBtn[7] = "\(strPower),\(strLow)低电量"
        }
        if strReceived.pairTo(strGotHistory,CID: strCID){
            let strDate = strReceived.getPairValueBy(strGotHistory, "yyMMddHHmmss")
            let strHigh1 = strReceived.getPairValueBy(strGotHistory, "h1")
            let strHigh2 = strReceived.getPairValueBy(strGotHistory, "h2")
            let strHigh = "\(strHigh2!)\(strHigh1!)".hex2Decimal()
            let strLow = strReceived.getPairValueBy(strGotHistory, "ll")?.hex2Decimal()
            let strHeartRate = strReceived.getPairValueBy(strGotHistory, "rr")?.hex2Decimal()
            let title = "时间:\(strDate!),高压:\(strHigh),低压:\(strLow!),心率:\(strHeartRate!)"
            m_pVC?.pDataClass.aryBtn[11] = title
        }
        if strReceived.pairTo(strGotHistoryOver,CID: strCID){
            m_pVC?.pDataClass.aryBtn[13] = "历史数据传完了,或者不支持"
        }
        if strReceived.pairTo(strStartRet,CID: strCID){
            let hexStr = strReceived.getPairValueBy(strStartRet, "WW")
            let nInt = hexStr?.hex2Decimal() ?? -1
            if nInt == 0{
                m_pVC?.pDataClass.aryBtn[7] = "开始测量成功"
            }else{
                m_pVC?.pDataClass.aryBtn[7] = "开始测量失败,错误码:\(nInt)"
            }
        }
        if strReceived.pairTo(strStopRet,CID: strCID){
            let hexStr = strReceived.getPairValueBy(strStopRet, "WW")
            let nInt = hexStr?.hex2Decimal() ?? -1
            if nInt == 0{
                m_pVC?.pDataClass.aryBtn[7] = "结束测量成功"
            }else{
                m_pVC?.pDataClass.aryBtn[7] = "结束测量失败,错误码:\(nInt)"
            }
            m_pVC?.arySupport[7] = 1
        }
        if strReceived.pairTo(strMeasureRet,CID: strCID){
            let strDate = strReceived.getPairValueBy(strMeasureRet, "yyMMddHHmmss")
            let strHigh1 = strReceived.getPairValueBy(strGotHistory, "h1")
            let strHigh2 = strReceived.getPairValueBy(strGotHistory, "h2")
            let strHigh = "\(strHigh2!)\(strHigh1!)".hex2Decimal()
            let strLow = strReceived.getPairValueBy(strMeasureRet, "ll")?.hex2Decimal()
            let strHeartRate = strReceived.getPairValueBy(strMeasureRet, "rr")?.hex2Decimal()
            let title = "时间:\(strDate!),高压:\(strHigh),低压:\(strLow!),心率:\(strHeartRate!)"
            m_pVC?.pDataClass.aryBtn[18] = title
            m_pVC?.arySupport[18] = 1
        }
        if strReceived.pairTo(strMeasuringData,CID: strCID){
            let strHigh1 = strReceived.getPairValueBy(strMeasuringData, "P1")
            let strHigh2 = strReceived.getPairValueBy(strMeasuringData, "P2")
            let strHigh = "\(strHigh2!)\(strHigh1!)".hex2Decimal()
            let title = "测量中的压力值:\(strHigh)"
            m_pVC?.pDataClass.aryBtn[19] = title
            m_pVC?.arySupport[19] = 1
        }
        if strReceived.pairTo(strErrorData,CID: strCID){
            let strErrorCode = strReceived.getPairValueBy(strErrorData, "WW")
            let strError = "上一次的错误码:\(strErrorCode!)"
            m_pVC?.pDataClass.aryBtn[20] = strError
            m_pVC?.arySupport[20] = 1
        }
        if strReceived.pairTo(strHandshake,CID: strCID){
            let strErrorCode = strReceived.getPairValueBy(strHandshake, "WW")
            let strError = "握手结果:\(strErrorCode!)"
            m_pVC?.pDataClass.aryBtn[23] = strError
            m_pVC?.arySupport[23] = 1
        }
        m_pVC?.tableView.reloadData()
    }
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//
//    }
}
extension String{
    //是否与某个命令匹配
    func pairTo(_ cmd:String,CID:String)->Bool{
        if cmd == ""{
            return false
        }
        //写法1: SID_CID_content
        let aryCmd = cmd.split(separator: "_")
        if(aryCmd.count == 3){
            let strCid = String(aryCmd[1])
            if strCid == CID{
                return true
            }
            return false
        }
        //写法2:
        let regExpStr = "\\s|h[0-9]|P[0-9]|[G-Za-z]";
        let cmdM = NSMutableString.init(string: cmd)
        let regExp = try?NSRegularExpression.init(pattern: regExpStr, options: .anchorsMatchLines)
        _ = regExp?.replaceMatches(in: cmdM, options: .reportProgress, range: NSRange.init(location: 0, length: cmd.length), withTemplate: "")
        if cmdM != "" && self.uppercased().hasPrefix(cmdM as String) {
            return true
        }
        return false
    }
    //根据关键字获取匹配的值
    func getPairValueBy(_ cmd:String,_ key:String)->String?{
        //写法1: SID_CID_content
        var cmd1 = cmd
        let aryCmd = cmd.split(separator: "_")
        if(aryCmd.count == 3){
            cmd1 = String(aryCmd.last!)
        }
        let cmd2 = NSMutableString.init(string: cmd1)
        cmd2.replaceOccurrences(of: " ", with: "", options: .backwards, range: cmd2.range(of: cmd2 as String))
        let cmd3 = cmd2 as String
        let rang1 = cmd3.range(of: key)
        if rang1 == nil {
            return nil
        }
        let subStr = self[rang1!.lowerBound..<rang1!.upperBound]
        return String(subStr)
    }
    func hasOneOfPrefix(_ strAll:String)->Bool{
        var bRet = false
        let aryPrefix = strAll.split(separator: ",")
        aryPrefix.forEach { (strPrefix) in
            if self.hasPrefix(strPrefix){
                bRet = true
            }
        }
        return bRet
    }
}
