//
//  extArray.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/12.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension  NSArray {
    func sortDicByKey(_ strKey:String)->NSArray{
        let aryRet = self.sortedArray(comparator: { (pFirst, pSecond) -> ComparisonResult in
            let dic1 = pFirst as? NSDictionary
            let dic2 = pSecond as? NSDictionary
            let nSort1 = dic1?.getInt(strKey) ?? -1
            let nSort2 = dic2?.getInt(strKey) ?? -1
            if nSort1 > nSort2 {
                return ComparisonResult.orderedDescending
            }else{
                return ComparisonResult.orderedAscending
            }
        }) as NSArray
        return aryRet
    }
    func getValue(_ nIndex:Int)->Any?{
        if (nIndex>=0&&nIndex<self.count){
            return self[nIndex]
        }
        return nil
    }
}
extension  Array {
    func getValue<T>(_ nIndex:Int)->T?{
        if (nIndex>=0&&nIndex<self.count){
            return self[nIndex] as? T
        }
        return nil
    }
}
