//
//  WriteViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 13..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
class GroupWrite: UIViewController,UITextViewDelegate {
    var placeholderLabel : UILabel = {
        let ph = UILabel()
        ph.text = "일상에서 당신의 묵상을 들려주세요. "
        ph.sizeToFit()
        ph.numberOfLines = 2
        ph.minimumScaleFactor = 10
        ph.adjustsFontSizeToFitWidth = true
        ph.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 14.5)
        return ph
    }()
    
    
    
    
    
    //버튼
    lazy var switctButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        
        button.setTitle("묵상공개", for: UIControlState())
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: UIControlState())
        button.titleLabel?.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = 5; // this value vary as per your desire
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(switchValueDidChange), for: .touchUpInside)
        return button
    }()
    
    
    @objc func switchValueDidChange(){
        
        if(switctButton.titleLabel?.text == "묵상공개"){
            
            switctButton.setTitle("나만보기", for: UIControlState())
        }else{
            switctButton.setTitle("묵상공개", for: UIControlState())
        }
    }
    
    //글쓰기 텍스트 필드
    let textFiedlView : UITextView = {
        let tf = UITextView()
        //tf.backgroundColor = UIColor.brown
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.tintColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        //tf.textAlignment = .center
        tf.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 14.5)
        //키보드 항상 보이게
        tf.becomeFirstResponder()
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action:  #selector(cancelAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action:  #selector(writeAction))
        
        //텍스트 뷰의 위임자를 자기자신으로 - 반드시 해줘야 함!
        textFiedlView.delegate = self
        
        view.addSubview(textFiedlView)
        
        //계층 구조를 이용해서 텍스트 뷰에 lable을 넣어 주었음
        textFiedlView.addSubview(placeholderLabel)
        textFiedlView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        //라벨의 위치를 정해 줌
        placeholderLabel.frame.origin = CGPoint(x: 8, y: (textFiedlView.font?.pointSize)! / 2)
        
        //placeholderLabel.frame.size = CGSize(width: 300, height: 50)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textFiedlView.text.isEmpty
        
        
        textFiedlView.addSubview(switctButton)
        
        switctButton.centerXAnchor.constraint(equalTo: textFiedlView.centerXAnchor).isActive = true
        switctButton.centerYAnchor.constraint(equalTo: textFiedlView.centerYAnchor,constant: -15).isActive = true
        switctButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        switctButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        //네비게이션 바 타이틀 폰트 바꾸기
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
             NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 15.5)!]
        
        
        //네비게이션 바 버튼 아이템 글꼴 바꾸기
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 14)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState())
        
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 14)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState())
        setNavTitle()
        setLayout()
        checkGroupId()
    }
    //그룹에 가입한 유저인지 체크 해서 그룹아이디 변수에 할당해주기
    var checkGroupid : String?
    func checkGroupId(){
        let ref = Database.database().reference()
        let userKey = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userKey!).observeSingleEvent(of: .value) { (snpat) in
            
            let childSnapshot = snpat //자식 DataSnapshot 가져오기
            let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
            
            if let checkGroup = childValue["groupid"]{
                self.checkGroupid = checkGroup as! String
            }
        }
        ref.removeAllObservers()
    }
    
    //몇번째 시편인지 가져오기
    func setNavTitle(){
        var allCount = 0
        let myId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("posts").queryOrdered(byChild: "date").observe(.value) { (snapshot) in
            for child in snapshot.children{
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                if let uid = childValue["uid"]{
                    if(myId == String(describing: uid)){
                        allCount = allCount + 1
                    }
                }
            }
            self.navigationItem.title = "묵상 \(allCount + 1)"
            allCount = 0
        }
        ref.removeAllObservers()
    }
    
    //텍스트 뷰에 글을 쓸때 호출됨
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textFiedlView.text.isEmpty
    }
    
    //weak var pvc = self.presentingViewController
    //취소 함수
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //완료 함수
    @objc func writeAction(){
        //인디케이터 시작
        AppDelegate.instance().showActivityIndicator()
        
        //현재 접속한 유저 정보 가져오기
        if let CurrentUser = Auth.auth().currentUser{
            
            let userId = CurrentUser.uid
            let userName = CurrentUser.displayName
            
            if textFiedlView.text.count == 0{
                let alert = UIAlertController(title: "알림 ", message:"내용을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                AppDelegate.instance().dissmissActivityIndicator()
                return
            }
            
            let textMsg = textFiedlView.text
            
            //데이터 베이스 참조 함수
            var ref: DatabaseReference!
            ref = Database.database().reference()
            //랜덤 키
            let PostKey = ref.child("posts").childByAutoId().key
            //부모키 user를 만들고 그 밑에 각자의 아이디로 또 자식을 만든다.
            let PostReference = ref.child("posts").child(PostKey)
            
            //if문으로 groupid가 있으면 넣어주고
            if(checkGroupid != nil){
                //데이터 객체 만들기
                
                //question ? answer1 : answer2
                
                
                print("그룹에 가입해서 그룹아이디가 있네요. 그룹에도 공개 되었습니다.")
                //print(self.checkGroupid)
                let postInfo: [String:Any] = ["pid" : PostKey,
                                              "uid" : userId,
                                              "name" : userName!,
                                              "text" : textMsg!,
                                              "hit": 0,
                                              "date": ServerValue.timestamp(),
                                              "reply":0,
                                              "show":(self.switctButton.titleLabel?.text == "묵상공개" ? "y" : "n"),
                                              "groupid":self.checkGroupid]
                PostReference.setValue(postInfo)
            }else{
                print("그룹에 가입안해서 그룹아이디가 없네요. 그룹에는 안들어가요")
                //탈퇴하면 그룹아이디를 없에 버려야함
                //데이터 객체 만들기
                let postInfo: [String:Any] = ["pid" : PostKey,
                                              "uid" : userId,
                                              "name" : userName!,
                                              "text" : textMsg!,
                                              "hit": 0,
                                              "date": ServerValue.timestamp(),
                                              "reply":0,
                                              "show":(self.switctButton.titleLabel?.text == "묵상공개" ? "y" : "n")]
                PostReference.setValue(postInfo)
                
            }
            //해당 경로에 삽입
            ref.removeAllObservers()
            //인디케이터 종료
            AppDelegate.instance().dissmissActivityIndicator()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func setLayout(){
        
        textFiedlView.topAnchor.constraint(equalTo: view.topAnchor,constant:50).isActive = true
        textFiedlView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0).isActive = true
        textFiedlView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0).isActive = true
        textFiedlView.heightAnchor.constraint(equalToConstant:view.frame.height).isActive = true
        
    }
}
