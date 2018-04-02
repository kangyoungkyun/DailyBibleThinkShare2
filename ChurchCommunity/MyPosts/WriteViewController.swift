//
//  WriteViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 13..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
class WriteViewController: UIViewController,UITextViewDelegate {
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
            
            //데이터 객체 만들기
            let postInfo: [String:Any] = ["pid" : PostKey,
                                          "uid" : userId,
                                          "name" : userName!,
                                          "text" : textMsg!,
                                          "hit": 0,
                                          "date": ServerValue.timestamp(),
                                          "reply":0,
                                          "show":"y"]
            //해당 경로에 삽입
            PostReference.setValue(postInfo)
            
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
