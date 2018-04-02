//
//  AlertTableViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 15..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//
// 수정 삭제 alert 창
import UIKit

class AlertTableViewController: UITableViewController {
    //위임자
    var delegate: DetailTalkViewController?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize.height = 88
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(indexPath.row == 0 ){
            cell.textLabel!.text = "수정"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.textAlignment = .center
        }else{
            cell.textLabel!.text = "삭제"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        }
        
        
        return cell
    }
    

}
