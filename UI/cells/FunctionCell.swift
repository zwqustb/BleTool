//
//  FunctionCell.swift
//  BleTool
//
//  Created by boeDev on 2019/5/31.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit

class FunctionCell: UITableViewCell {
    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var lCmd: UILabel!
    @IBOutlet weak var pButton: UIButton!
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        let title = sender.title(for: .normal) ?? ""
        if title.contains("开始搜索")||title.contains("重新搜索") {
            BleTool.shareInstence.startScan()
            sender.setTitle("停止搜索", for: .normal)
        }else if title.contains("停止搜索") {
            BleTool.shareInstence.centerManager?.stopScan()
            sender.setTitle("开始搜索", for: .normal)
        }else if title.contains("断开连接") {
            BleTool.shareInstence.disconnectDevice()
            sender.setTitle("开始搜索", for: .normal)
        }else if title.contains("开始测量"){
            BleTool.shareInstence.sendDataByType(9)
        }else if title.contains("同步时间"){
            BleTool.shareInstence.sendDataByType(1)
        }else if title.contains("获取电量"){
            BleTool.shareInstence.sendDataByType(3)
        }
    }
}
