//
//  GroupListVC.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 4. 8..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
class GroupListVC: UITableViewController {
    let cellId = "cellId"
    var groupList = [GroupInfo]()
    
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
        
        tableView.register(GroupCell.self, forCellReuseIdentifier: cellId)
        
        showGroupList()
    }
    
    func showGroupList(){
        let ref = Database.database().reference()
        ref.child("group").observe(.value) { (snapshot) in
            self.groupList.removeAll() //배열을 안지워 주면 계속 중복해서 쌓이게 된다.
            for child in snapshot.children{
                
                let groupToShow = GroupInfo() //데이터를 담을 클래스
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                
                print("만들어진 그룹 방 보여줘요.   \(childValue)")
                if let leaderid = childValue["leaderid"],  let leadername = childValue["leadername"], let groupname = childValue["groupname"], let count = childValue["count"],let password = childValue["password"]{
                    
                    groupToShow.leaderid = leaderid as! String
                    groupToShow.leadername = leadername as! String
                    groupToShow.groupname = groupname as! String
                    groupToShow.password = password as! String
                    groupToShow.count = String(describing: count)
                    
                    self.groupList.insert(groupToShow, at: 0)
                }
            }
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? GroupCell
        
       let groupData = groupList[indexPath.row]
        cell?.groupTitleLabel.text = groupData.groupname
        cell?.groupNameLabel.text = groupData.leadername
        cell?.groupCountLabel.text = "  \(groupData.count!) 명"
        return cell!
    }
    
    //그룹 만들기 - 나중에 그룹을 몇개 만들었는지 체크 하고 그룹 삭제 기능도 넣자 그리고 그룹 탈퇴 기능도..
    @objc func makeGroup(){
        var txt : String?
        var pass: String?
        
        print("묵상 그룹을 만드시겠습니까?")
        let alert = UIAlertController(title: "", message: "묵상방 만들기", preferredStyle: .alert)
        alert.addTextField { (myTextField) in
            
            myTextField.textColor = UIColor.darkGray
            myTextField.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
            myTextField.placeholder = "묵상방 이름"
        }
        
        alert.addTextField { (passwordTextField) in
            
            passwordTextField.textColor = UIColor.darkGray
            passwordTextField.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
            passwordTextField.isSecureTextEntry = true
            passwordTextField.placeholder = "비밀번호"
        }
        
        let ok = UIAlertAction(title: "만들기", style: .default) { (ok) in
            txt = alert.textFields?[0].text
            pass = alert.textFields?[1].text
            
            //유효성 검사
            if(txt == "" || pass == ""){
                let alert = UIAlertController(title: "알림 ", message:"빈칸을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //print(txt,pass)
            let userKey = Auth.auth().currentUser?.uid
            let userName = Auth.auth().currentUser?.displayName
            print(userKey)
            //nil 값 검사
            if let groupname = alert.textFields?[0].text, let password = alert.textFields?[1].text,
                let leaderid = userKey, let leadername = userName{
                let ref = Database.database().reference()
                let groupKey = ref.child("group").childByAutoId().key
                
                
                //그룹 db 만들어 준다.
                ref.child("group").child(groupKey).setValue(["leaderid" : leaderid,
                                                             "leadername" : leadername,
                                                             "groupname" : groupname,
                                                             "password" : password,
                                                             "count" : 1])
            }
            
            let leader = ["leader" : "y",
                          "group" : "y"]
            //여기가 문제
            let ref = Database.database().reference()
            ref.child("users").child(userKey!).updateChildValues(leader)
            
            let alert = UIAlertController(title: "축하합니다", message:"묵상방이 생성되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
            //code
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func searcgGroup(){
        print("묵상 그룹 찾기")
    }
    
    
    
}
