//
//  SelectView.swift
//  MobileHealth
//
//  Created by boeDev on 2018/10/10.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
protocol SelectViewDelegate:NSObjectProtocol {
    func onSelectOption(_ strOption:String,_ nIndex:Int)
    func onSelectOver()
}
class SelectView: UIView,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_aryOption?.count ?? 0
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if pCell == nil {
             pCell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
//            let pView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 40))
        
           // pImgView.tag = 11
            
         //  let lOption = UILabel.init(frame: CGRect.init(x: 136, y: 9, width: 80, height: 20))
             pCell?.textLabel?.text = m_aryOption?[indexPath.row] as? String
             pCell?.textLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
             pCell?.textLabel?.textColor = UIColor.appBlackColor()
//            pCell?.addSubview(pView)
//            pView.addSubview(lOption)
            
        }
        pCell?.imageView?.frame = CGRect.init(x: 100, y: 11, width: 16, height: 16)
       
//        pCell!.imageView?.addConstraint(NSLayoutConstraint.init(item: pCell!.imageView!, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: pCell!.imageView!.superview, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 100))
        let strImgName  = (indexPath.row == m_nSelectIndex) ? "iconOptionSelect":"iconOption"
        pCell?.imageView?.image = UIImage.init(named: strImgName)
  
        return pCell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        m_nSelectIndex = indexPath.row
        let strOption = m_aryOption?[indexPath.row] as? String ?? ""
        self.delegate?.onSelectOption(strOption,indexPath.row)
        tableView.reloadData()
    }
    var m_aryOption:NSArray?
    var m_nSelectIndex = -1
    weak var delegate:SelectViewDelegate?
    class func initWith(title :String,aryOption:[String],delegate:SelectViewDelegate,defaultSelectIndex:Int) -> SelectView {
        let fViewWidth = 300.0
        let fTableWidth = 150.0
        //自己
        let pSelectView = SelectView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: fViewWidth, height: 252.0))
        pSelectView.delegate = delegate
        pSelectView.m_nSelectIndex = defaultSelectIndex
        //头
        let pTitleView = AlertTitleLabel.initWith(title: title)
        //分割线
        let pLineView = UIView.init(frame: CGRect.init(x: 0.0, y: 46.0, width: fViewWidth, height: 2.0))
        pLineView.backgroundColor = UIColor.appLineColor()
        //选项
        let pOptionTableView = UITableView.init(frame: CGRect.init(x: (fViewWidth-fTableWidth)*0.5, y: 48.0, width: fTableWidth, height: 130.0))
        pOptionTableView.delegate = pSelectView
        pOptionTableView.dataSource = pSelectView
        pOptionTableView.separatorStyle = .none
        pSelectView.m_aryOption = NSArray.init(array: aryOption)
        //按钮
        let pBtn = UIButton.init(frame: CGRect.init(x: 70, y: 188, width: 159, height: 40))
        pBtn.backgroundColor = UIColor.appBlueColor()
        pBtn.setTitle("下一步", for: .normal)
        pBtn.layer.cornerRadius = 20
        pBtn.clipsToBounds = true
        pBtn.addTarget(pSelectView, action: #selector(clickBtn), for: .touchUpInside)
        
        pSelectView.addSubview(pTitleView)
        pSelectView.addSubview(pLineView)
        pSelectView.addSubview(pOptionTableView)
        pSelectView.addSubview(pBtn)
        return pSelectView
    }
    @objc func clickBtn(){
        if m_nSelectIndex != -1 {
            self.delegate?.onSelectOver()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
