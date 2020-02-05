//
//  BleCmdVC.swift
//  BleTool
//
//  Created by boeDev on 2019/5/31.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit

class BleCmdVC: UITableViewController {
    let pDataClass = CmdLocalData.shareInstence
    let arySupport = NSMutableArray.init()
    var m_aryCurData = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "指令验证"
        BleTool.shareInstence.m_pVC = self
        self.tableView.register(UINib.init(nibName: "FunctionCell", bundle: nil), forCellReuseIdentifier: "CmdCell")
        let strName = pDataClass.getCurCmdName()
        m_aryCurData = pDataClass.getCmdAryByName(strName)
        m_aryCurData.forEach { (str) in
            if str == ""{
                arySupport.add(-1)
            }else{
                arySupport.add(0)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //测试代码:
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.perform(#selector(testFunc), with: nil, afterDelay: 1)
//        testFunc()
    }
   @objc func testFunc(){
//            var bytes = [UInt8](Data.init())
//            bytes = [30,131,0,89,0,103,0,227,7,3,26,15,39,0,77,0,1,4,0]
//            let data = Data.init(bytes: bytes)
//            let strHex = data.hexString()
//            print(strHex)
//        BleTool.shareInstence.onRecevicedBleData("5505ee044e")
//        BleTool.shareInstence.onRecevicedBleData("550802040b0b007b")
//        BleTool.shareInstence.onRecevicedBleData("550e031906051353006e004e49f7")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pDataClass.aryName.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CmdCell", for: indexPath)
        as? FunctionCell ?? FunctionCell.init()
        cell.selectionStyle = .none
        if indexPath.row < pDataClass.aryName.count{
            cell.lTitle.text = pDataClass.aryName[indexPath.row]
        }
        if indexPath.row < m_aryCurData.count{
            cell.lCmd.text = m_aryCurData[indexPath.row]
        }
        let btnTitle = pDataClass.aryBtn[indexPath.row]
        if btnTitle == "" {
            cell.pButton.isHidden = true
        }else{
            cell.pButton.isHidden = false
            cell.pButton.setTitle(btnTitle, for: .normal)
        }
        let nSupport = arySupport[indexPath.row] as? Int ?? -1
        switch nSupport {
        case -1:
            cell.colorView.backgroundColor = .red
            break
        case 1:
            cell.colorView.backgroundColor = .green
            break
        default:
            cell.colorView.backgroundColor = .yellow
            break
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
