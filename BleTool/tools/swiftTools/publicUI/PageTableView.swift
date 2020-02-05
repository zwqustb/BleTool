//
//  MoreTableView.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/27.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
//分页table
class PageTableView: UITableView {
    //不能为0
    var m_nPageSize = 20
    var m_cmdHttp = ""
    var m_dicParam = ["userId":"","pageNo":"1","pageSize":"10"]
    var m_aryData = NSMutableArray.init()
    var m_bHasMore = true
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.tableFooterView = UIView.init(frame: CGRect.zero)
//        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            self.m_dicParam["pageNo"] = "1"
//            self.m_dicParam["userId"] = LogicTool.getUserId()
//            self.refreshData()
//        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func willDisplayCell(_ indexPath: IndexPath) {
        if indexPath.row >= m_aryData.count-1 {
            let nMultiple = m_aryData.count / m_nPageSize
            let nRemine = m_aryData.count % m_nPageSize
            m_dicParam["pageNo"] = "\(nMultiple+1)"
            m_dicParam["userId"] = LogicTool.getUserId()
            m_dicParam["pageSize"] = "\(m_nPageSize)"
            if nRemine == 0 && m_bHasMore{
                self.m_bHasMore = false
                HttpTools.get(m_cmdHttp, m_dicParam) { (bRet, dicRet) in
                    if bRet{
                        let aryData = dicRet["data"] as? [Any] ?? []
                        if aryData.count == self.m_nPageSize{
                            self.m_bHasMore = true
                        }else if aryData.count == 0{
                            return
                        }
                      // aryData.forEach({ (pAny) in
                             self.m_aryData.addObjects(from: aryData)
                        //})
                        self.reloadData()
                    }
                }
            }
        }
    }
    func getHttpData()  {
        if m_aryData.count == 0 {
            HttpTools.get(m_cmdHttp, m_dicParam) { (bRet, dicRet) in
                if bRet{
                    let aryData = dicRet["data"] as? [Any] ?? []
                    if aryData.count == self.m_nPageSize{
                        self.m_bHasMore = true
                    }else if aryData.count == 0{
                        return
                    }
                    // aryData.forEach({ (pAny) in
                    self.m_aryData.addObjects(from: aryData)
                    //})
                    self.reloadData()
                }
            }
        }else{
            self.reloadData()
        }
       
    }
    func refreshData(){
        HttpTools.get(m_cmdHttp, m_dicParam) { (bRet, dicRet) in
           // self.mj_header.endRefreshing()
            if bRet{
                let aryData = dicRet["data"] as? [Any] ?? []
                if aryData.count == self.m_nPageSize{
                    self.m_bHasMore = true
                }else if aryData.count == 0{
                    return
                }
                self.m_aryData.removeAllObjects()
                // aryData.forEach({ (pAny) in
                self.m_aryData.addObjects(from: aryData)
                //})
                self.reloadData()
            }
        }
    }
}
