//
//  WriteViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 13..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

protocol ChildViewControllerDelegate
{
    func childViewControllerResponse(text:String)
}

import UIKit
import Firebase
class ModifyVC: UIViewController,UITextViewDelegate {
    
    var delegate: ChildViewControllerDelegate?
    
    
    var modifyMainText:String?
    var pid:String?
    
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
        setLayout()
    }
    
    
    //텍스트 뷰에 글을 쓸때 호출됨
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textFiedlView.text.isEmpty
    }
    
    
    //완료 함수
    @objc func writeAction(){
        print("수정완료 클릭")
        //인디케이터 시작
        AppDelegate.instance().showActivityIndicator()

        //현재 접속한 유저 정보 가져오기
        if let CurrentUser = Auth.auth().currentUser{


            if textFiedlView.text.count == 0{
                let alert = UIAlertController(title: "알림 ", message:"내용을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                AppDelegate.instance().dissmissActivityIndicator()
                return
            }


            self.modifyMainText = textFiedlView.text
            let ref = Database.database().reference()
            ref.child("posts").child(pid!).updateChildValues(["text":self.modifyMainText ?? "",
                       "date":ServerValue.timestamp()])
            
            //let viewVC = DetailTalkViewController()
           // viewVC.onePost?.text = self.modifyMainText
            //self.delegate?.childViewControllerResponse(text: textFiedlView.text)
            
           // let a = self.navigationController?.viewControllers[1] as! DetailTalkViewController
            //a.onePost?.text = self.modifyMainText
            //elf.navigationController?.popToViewController(a, animated: true)
            
            //인디케이터 종료
            AppDelegate.instance().dissmissActivityIndicator()
            
        navigationController?.popViewController(animated: true)
    
        }
    }
    
    
    
    func setLayout(){
        
        textFiedlView.topAnchor.constraint(equalTo: view.topAnchor,constant:50).isActive = true
        textFiedlView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0).isActive = true
        textFiedlView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0).isActive = true
        textFiedlView.heightAnchor.constraint(equalToConstant:view.frame.height).isActive = true
        
    }
}

