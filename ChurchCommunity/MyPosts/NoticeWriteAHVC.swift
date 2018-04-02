//
//  NoticeWriteAHVC.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 23..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
class NoticeWriteAHVC: UIViewController,UITextViewDelegate {

    var placeholderLabel : UILabel = {
        let ph = UILabel()
        ph.text = "당신의 생각을 들려주세요 :)"
        ph.font = UIFont.systemFont(ofSize: 18)
        ph.sizeToFit()
        return ph
    }()
    
    
    //글쓰기 텍스트 필드
    let textFiedlView : UITextView = {
        let tf = UITextView()
        //tf.backgroundColor = UIColor.brown
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.tintColor = .black
        tf.font = UIFont.systemFont(ofSize: 18)
        //키보드 항상 보이게
        tf.becomeFirstResponder()
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        self.navigationItem.title = "글쓰기"
        
        //취소 바 버튼
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "ic_cancel.png"), style: .plain, target: self, action:  #selector(cancelAction))
        //보내기 바 버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_send.png"), style: .plain, target: self, action:  #selector(writeAction))
        
        
        view.backgroundColor = UIColor.white
        
        
        //텍스트 뷰의 위임자를 자기자신으로 - 반드시 해줘야 함!
        textFiedlView.delegate = self
        
        view.addSubview(textFiedlView)
        
        //계층 구조를 이용해서 텍스트 뷰에 lable을 넣어 주었음
        textFiedlView.addSubview(placeholderLabel)
        
        //라벨의 위치를 정해 줌
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textFiedlView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textFiedlView.text.isEmpty
        
        setLayout()
    }
    
    //텍스트 뷰에 글을 쓸때 호출됨
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textFiedlView.text.isEmpty
        //print("textViewDidChange")
    }
    
    //취소 함수
    @objc func cancelAction(){
        //print("cancelAction")
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
                return
            }
            
            let textMsg = textFiedlView.text
            
            //데이터 베이스 참조 함수
            var ref: DatabaseReference!
            ref = Database.database().reference()
            //랜덤 키
            let PostKey = ref.child("notices").childByAutoId().key
            //부모키 user를 만들고 그 밑에 각자의 아이디로 또 자식을 만든다.
            let PostReference = ref.child("notices").child(PostKey)
            
            //데이터 객체 만들기
            let postInfo: [String:Any] = ["pid" : PostKey,
                                          "uid" : userId,
                                          "name" : userName!,
                                          "text" : textMsg!,
                                          "hit": 0,
                                          "date": ServerValue.timestamp(),
                                          "reply":0]
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
        textFiedlView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:4).isActive = true
        textFiedlView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-4).isActive = true
        textFiedlView.heightAnchor.constraint(equalToConstant:view.frame.height / 2).isActive = true
        
    }
}
