//
//  AppleTable.swift
//  MobileHealth
//
//  Created by boeDev on 2019/3/5.
//  Copyright © 2019 Jiankun Zhang. All rights reserved.
//
//用苹果自己的cell,可以实现的界面,不用绘制新的cell
import UIKit
protocol AppleTableDelegate {
    func onClickDetailView(_ pDetailView:UIView)
}
class AppleTable: UITableView,UITableViewDelegate,UITableViewDataSource {
    //数组中套数组,以支持group的方式展示
    var appleDelegate:AppleTableDelegate?
    var m_aryCell:NSArray = []
    var m_aryHeader:NSArray = []
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initParams()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initParams()
        //fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func initParams(){
        self.dataSource = self
        self.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        self.sectionFooterHeight = 0
        self.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return m_aryCell.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arySubData = m_aryCell.getValue(section) as? NSArray ?? []
        return arySubData.count
    }
    //accessview type [0:没有,1:右箭头,2:switch on,3:switch off]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aryDatasource = m_aryCell.getValue(indexPath.section) as? NSArray ?? []
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        let pCellData = aryDatasource.getValue(indexPath.row)
        cell.detailTextLabel?.text = nil
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.accessoryView = nil
        var bUnableColor = false //不允许点击的字体色
        if pCellData is String{
            let strText = pCellData as! String
            cell.textLabel?.text = strText
            cell.textLabel?.font = UIFont.appFont(15, type: 0)
            cell.textLabel?.textColor = UIColor.appFontLightBlack()
        }else if pCellData is NSAttributedString{
            let attrText = pCellData as! NSAttributedString
            cell.textLabel?.attributedText = attrText
        }else if pCellData is NSArray{
            //["text","detaltext","1/0"]
            cell.textLabel?.font = UIFont.appFont(15, type: 0)
            let aryData = pCellData as! NSArray
            cell.textLabel?.text = aryData.firstObject as? String
            cell.detailTextLabel?.text = aryData.getValue(1) as? String
            let str3 = aryData.getValue(2) as? String
            if str3 == "1"{
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            }else if str3 == "2"{
                let pSwitch = UISwitch.init()
                pSwitch.isOn = true
                pSwitch.tag = indexPath.section*1000+indexPath.row
                pSwitch.addTarget(self, action: #selector(clickDetailView), for: .valueChanged)
                cell.accessoryView = pSwitch
            }else if str3 == "3"{
                let pSwitch = UISwitch.init()
                pSwitch.isOn = false
                pSwitch.tag = indexPath.section*1000+indexPath.row
                pSwitch.addTarget(self, action: #selector(clickDetailView), for: .valueChanged)
                cell.accessoryView = pSwitch
            }
            let str4 = aryData.getValue(3) as? String
            if str4 == "0"{
                bUnableColor = true
            }
        }
        if bUnableColor{
            cell.detailTextLabel?.textColor = UIColor.appTextUnable()
            cell.textLabel?.textColor = UIColor.appTextUnable()
        }else{
            cell.textLabel?.textColor = UIColor.appBlackColor()
            if cell.detailTextLabel?.text == "已开启"{
                cell.detailTextLabel?.textColor =  UIColor.appBlueColor()
            }else{
                cell.detailTextLabel?.textColor =  UIColor.appLightBlackColor()
            }
        }
        return cell
    }
//    override func headerView(forSection section: Int) -> UITableViewHeaderFooterView? {
//
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let strTitle = m_aryHeader.getValue(section) as? String
        return strTitle
    }
    @objc func clickDetailView(_ sender:UIView){
        appleDelegate?.onClickDetailView(sender)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
