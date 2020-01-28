//
//  DialogHeader.swift
//  MobileHealth
//
//  Created by boeDev on 2018/11/27.
//  Copyright © 2018 Jiankun Zhang. All rights reserved.
//

import UIKit
@objc protocol DialogHeaderDelegate:NSObjectProtocol {
    func onClickDialogHeaderOk()
    func onClickDialogHeaderCancel()
}
class DialogHeader: UIView {
     weak var delegate:DialogHeaderDelegate?
    
    @IBOutlet weak var title: UILabel!
    @IBAction func OnClickCancek(_ sender: UIButton) {
        delegate?.onClickDialogHeaderCancel()
    }
    
    @IBAction func OnClickOk(_ sender: UIButton) {
        delegate?.onClickDialogHeaderOk()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
