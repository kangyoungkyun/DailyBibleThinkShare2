//
//  MoreNoticeViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 19..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//  더 보기 페이지

import UIKit

class MoreNoticeViewController: UIViewController {

    var text: String?{
        didSet{
            //textFiedlView.text = text
            textFiedlView.text = text?.replacingOccurrences(of: "\\n", with: "\n")
            textFiedlView.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 15.5)
        }
    }
    
    var titleName: String?{
        didSet{
            self.navigationItem.title = titleName
            
        }
    }
    
    //댓글쓰기 텍스트 필드
    let textFiedlView : UITextView = {
        let tf = UITextView()
        //tf.backgroundColor = UIColor.brown
        tf.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        tf.isEditable = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.tintColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        tf.font = UIFont.systemFont(ofSize: 16)
        //tf.alpha = 0.5
        tf.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        
        //키보드 항상 보이게
        //tf.becomeFirstResponder()
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //네비게이션 바 색깔 변경

        self.navigationController?.navigationBar.isTranslucent = false

        self.view.backgroundColor = UIColor.white
        
        
        //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        
        
        //네비게이션 바 타이틀 폰트 바꾸기
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
             NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 18.5)!]
        
        
        self.navigationItem.title = titleName
        //navigationController?.navigationBar.prefersLargeTitles = false
      view.addSubview(textFiedlView)
        textFiedlView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
         textFiedlView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
         textFiedlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
         textFiedlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        
    }





}
