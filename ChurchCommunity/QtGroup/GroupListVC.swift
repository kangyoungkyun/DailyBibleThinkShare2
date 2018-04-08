//
//  GroupListVC.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 4. 8..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

class GroupListVC: UITableViewController {
let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        tableView.backgroundView?.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        
        self.navigationController?.navigationBar.isTranslucent = false

        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "그룹생성", style: .plain, target: self, action:  #selector(makeGroup))
        
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "그룹찾기", style: .plain, target: self, action:  #selector(searcgGroup))
        
        //네비게이션 바 버튼 아이템 글꼴 바꾸기
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 15.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: UIControlState())
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 15.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: UIControlState())
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = "온누리교회 qt방"
        cell.detailTextLabel?.text = "김동준"
        return cell
    }
  
    
    @objc func makeGroup(){
        print("묵상 그룹을 만드시겠습니까?")
    }
    
    @objc func searcgGroup(){
        print("묵상 그룹 찾기")
    }
 


}
