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
    var activityIndicatorView: UIActivityIndicatorView!
    
    var todayPostsCountLable: UILabel = {
        let label = UILabel()
        label.text = "묵상 공동체"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 21.5)
        label.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //소개
    lazy var introLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 14.5)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        //라벨 줄 간격
        let attributedString = NSMutableAttributedString(string: "우리교회 큐티 묵상방을 찾아보세요")
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2.5 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        label.attributedText = attributedString;
        
        return label
    }()
    
    
    //글 개수 / 공개개수
    var countLable: UILabel = {
        let label = UILabel()
        //label.text = "오늘 작성된 묵상글/   편"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 11.5)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerView : UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        return header
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //테이블 뷰 헤더 지정
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:220)
        tableView.tableHeaderView = headerView
        setHeaderViewLayout()
        
        //인디케이터 작동
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -60).isActive = true
        activityIndicatorView.bringSubview(toFront: self.view)
        activityIndicatorView.startAnimating()
        tableView.separatorStyle = .none
        DispatchQueue.main.async {
            OperationQueue.main.addOperation() {
                self.tableView.separatorStyle = .none
                Thread.sleep(forTimeInterval: 1.0)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
        
        //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //테이블 배경 및 뒷배경 흰색 지정
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        tableView.backgroundView?.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        //테이블 셀 등록 및 표시줄 제거
        tableView.register(GroupCell.self, forCellReuseIdentifier: cellId)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        //동적 테이블 셀 높이
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

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
        
        
        
        showGroupList()
        groupidAndLeaderCheck()
    }
    
    
    //동적 테이블 함수
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //동적 테이블 함수
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //그룹을 만든 유저인지 or 그룹에 가입한 유저인지 체크
    func groupidAndLeaderCheck(){
        
        let ref = Database.database().reference()
        let userKey = Auth.auth().currentUser?.uid
        ref.child("users").child(userKey!).observeSingleEvent(of: .value) { (snpat) in
            
            let childSnapshot = snpat //자식 DataSnapshot 가져오기
            let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
            let groupid = childValue["groupid"] as? String
            let leader = childValue["leader"] as? String
            let group = childValue["group"] as? String
            
            if (groupid != "" && leader == "y"){
                print("방을 이미 만드셨습니다.")
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.hidesBackButton = true
                self.navigationItem.rightBarButtonItem = nil
                return
            }
            
            if(groupid != "" && group == "y"){
                print("가입한 방이 있습니다.")
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.hidesBackButton = true
                self.navigationItem.rightBarButtonItem = nil
                return
            }
        }
        ref.removeAllObservers()
    }
    
    
    //그룹 리스트 가져오기
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
        cell?.passwordLabel.text = groupData.password
        return cell!
    }
    
    //묵상 그룹 리스트를 클릭했을 때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? GroupCell
        //indexPath1 = tableView.indexPath(for: cell!)
        //값 할당
        let title = cell?.groupTitleLabel.text
        let name = cell?.groupNameLabel.text
        let count = cell?.groupCountLabel.text
        let password = cell?.passwordLabel.text

        
        let alert = UIAlertController(title: "", message: "환영합니다 :)", preferredStyle: .alert)
        alert.addTextField { (myTextField) in
            
            myTextField.textColor = UIColor.black
            myTextField.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 13.5)
            myTextField.placeholder = "묵상방 비밀번호를 입력해주세요."
        }
        
        let ok = UIAlertAction(title: "입장하기", style: .default) { (ok) in
            //기존의 방 비밀번호와 비교 해서 맞으면 후 추리
           
            //틀리면 밖으로
            
            //빈칸 확인
            let txt = alert.textFields?[0].text
            if(txt == ""){
                let alert = UIAlertController(title: "알림 ", message:"빈칸을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            //비번확인
            if(password != txt){
                let alert = UIAlertController(title: "알림 ", message:"비밀번호를 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }else{
                //user에 update 해주기 group 칼럼
                print("비밀번호가 맞았어요, 방으로 입장합니다.")
            }
            
            
//            let key = Auth.auth().currentUser?.uid
//            let ref = Database.database().reference()
//            ref.child("users").child(key!).updateChildValues(["stateMsg" : txt ?? ""])
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
            //code
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        //print(title,name,count,password)
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
                
                let leader = ["leader" : "y",
                              "group" : "y",
                              "groupid" : groupKey]
                //방을 만든사람 정보 업데이트
                ref.child("users").child(userKey!).updateChildValues(leader)
            }
            

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
    //헤더뷰 레이아웃
    func setHeaderViewLayout(){
        headerView.addSubview(todayPostsCountLable)
        todayPostsCountLable.topAnchor.constraint(equalTo: headerView.topAnchor,constant:40).isActive = true
        todayPostsCountLable.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant:15).isActive = true
        //todayPostsCountLable.widthAnchor.constraint(equalTo : headerView.widthAnchor).isActive = true
        //todayPostsCountLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        headerView.addSubview(introLable)
        introLable.topAnchor.constraint(equalTo: todayPostsCountLable.bottomAnchor,constant:10).isActive = true
        introLable.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant:15).isActive = true
        //introLable.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant:-35).isActive = true
        //introLable.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant:-35).isActive = true
        
        headerView.addSubview(countLable)
        countLable.topAnchor.constraint(equalTo: introLable.bottomAnchor,constant:35).isActive = true
        countLable.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant:-15).isActive = true
        //countLable.heightAnchor.constraint(equalToConstant: 15).isActive = true
        countLable.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant:-5).isActive = true
        
    }
    
    
}
