//
//  ShowUserPageViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 24..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
class ShowUserPageViewController: UIViewController {

    var activityIndicatorView: UIActivityIndicatorView!
    var userUid: String?
    var userName: String?


    //이름
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "필명"
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        return label
    }()
    
    
    //댓글수
    var birthLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        return label
    }()
    
    //작성댓글
    var mesageLabel: UILabel = {
        let label = UILabel()
        label.text = "작성댓글"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        return label
    }()
    
    //==================================================================================
    
    //이름 텍스트 필드 객체 만들기
    let nameTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "이름"
        tf.isEnabled = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //이름 구분선 만들기
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //==================================================================================
    //글수 텍스트 필드
    let birthTextField : UITextField = {
        let tf = UITextField()
        //tf.placeholder = "미지정"
        tf.isEnabled = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //글수 구분선 만들기
    let birthSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //==================================================================================
    
    
    //댓글수 텍스트 필드 객체 만들기
    let mesageTextField: UITextField = {
        let tf = UITextField()
        tf.isEnabled = false
        //tf.placeholder = "상태메시지가 없습니다."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //구분선 만들기
    let mesageSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    // ========================================= 쪽지보내기 버튼  =========================================
    //쪽지보내기 버튼
    var sendBtn: UIButton = {
        let sendBtn = UIButton()
        sendBtn.setTitle("쪽지보내기", for: UIControlState())
        //sendBtn.font = UIFont.boldSystemFont(ofSize: 17)
        sendBtn.setTitleColor(UIColor.white, for: UIControlState())
        sendBtn.backgroundColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        sendBtn.layer.cornerRadius = 7
        sendBtn.clipsToBounds = true
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.addTarget(self, action: #selector(sendMesageBtnAction), for: .touchUpInside)
        return sendBtn
    }()
    //쪽지보내기 버튼 클릭
    @objc func sendMesageBtnAction(){
        print("쪽지보내기 버튼 클릭")
        
        //내가 보낼때 from은 나다
        let myUid = Auth.auth().currentUser?.uid
        let myName = Auth.auth().currentUser?.displayName
        
        
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .alert)
        
        let modifyAction = UIAlertAction(title: "쪽지보내기", style: .default) { (alert) in
            print("쪽지보내기")
            
            //나에게 보내기
            self.sendMsgController(toid: self.userUid!, toname: self.userName!, fromid: myUid!, fromname: myName!)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (alert) in
            print("취소")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(modifyAction)
        
        
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: #selector(cancel))
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)

        self.navigationController?.navigationBar.isTranslucent = false
        ////navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "이웃보기"
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -80).isActive = true
        activityIndicatorView.bringSubview(toFront: self.view)
        activityIndicatorView.startAnimating()
        
        print("start 인디케이터")
        
        DispatchQueue.main.async {
            print("start DispatchQueue")
            OperationQueue.main.addOperation() {
                print("start OperationQueue")
                
                Thread.sleep(forTimeInterval: 1.9)
                print("start forTimeInterval")
                self.activityIndicatorView.stopAnimating()
                
            }
        }
        
        self.view.addSubview(nameLabel)
        
        self.view.addSubview(birthLabel)
        self.view.addSubview(mesageLabel)
        
        self.view.addSubview(nameTextField)
        
        self.view.addSubview(birthTextField)
        self.view.addSubview(mesageTextField)
        
        self.view.addSubview(nameSeperatorView)
        
        self.view.addSubview(birthSeperatorView)
        self.view.addSubview(mesageSeperatorView)
        

        //self.view.addSubview(todayCheckBtn)
        self.view.addSubview(sendBtn)
        
          //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list_white.png"), style: .plain, target: self, action:  #selector(showUserPost))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "글모음", style: .plain, target: self, action: #selector(showUserPost))
        showMyUserData()
        setLayout()
        
    }
    //유저가쓴 일기 보기
    @objc func showUserPost(){
        print("유저가 쓴 일기 보기")
        let viewController = ShowUserPostsVC()
        viewController.userId = userUid
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //이전
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    

    
    func setLayout(){
        
        
        //라벨
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor,constant:40).isActive = true
        //nameLabel.topAnchor.constraintEqualToSystemSpacingBelow(view.topAnchor, multiplier: 2)
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 63).isActive = true
        
        //텍스트 필드
        //nameTextField.topAnchor.constraintEqualToSystemSpacingBelow(view.topAnchor, multiplier: 2)
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor,constant:40).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //구분선
        nameSeperatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant:5).isActive = true
        nameSeperatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        

        //라벨
        birthLabel.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor,constant:20).isActive = true
        birthLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        birthLabel.widthAnchor.constraint(equalToConstant: 63).isActive = true
        //텍스트 필드
        birthTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor,constant:20).isActive = true
        birthTextField.leftAnchor.constraint(equalTo: birthLabel.rightAnchor, constant: 5).isActive = true
        birthTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //구분선
        birthSeperatorView.topAnchor.constraint(equalTo: birthLabel.bottomAnchor,constant:5).isActive = true
        birthSeperatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        birthSeperatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        birthSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //라벨
        mesageLabel.topAnchor.constraint(equalTo: birthSeperatorView.bottomAnchor,constant:20).isActive = true
        mesageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        mesageLabel.widthAnchor.constraint(equalToConstant: 63).isActive = true
        //텍스트 필드
        mesageTextField.topAnchor.constraint(equalTo: birthSeperatorView.bottomAnchor,constant:20).isActive = true
        mesageTextField.leftAnchor.constraint(equalTo: mesageLabel.rightAnchor, constant: 5).isActive = true
        mesageTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //구분선
        mesageSeperatorView.topAnchor.constraint(equalTo: mesageLabel.bottomAnchor,constant:5).isActive = true
        mesageSeperatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        mesageSeperatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mesageSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //쪽지보내기
        sendBtn.topAnchor.constraint(equalTo: mesageSeperatorView.bottomAnchor,constant:70).isActive = true
        sendBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        sendBtn.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -30).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true

        
    }
    
    
    //내 페이지 정보 가져오기
    func showMyUserData(){
        var writeCount = 0
        var replyCount = 0
 
        
        let ref = Database.database().reference()
        self.nameTextField.text = self.userName!
       
        
        // -- 글 개수 가져오기
        ref.child("posts").queryOrderedByKey().observe(.value) { (snapshot) in
            
            for child in snapshot.children{
                
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                
                if let uid = childValue["uid"]{
                    
                    if(self.userUid == String(describing: uid)){
                        
                        writeCount = writeCount + 1
                        
                    }
                }
            }
            self.birthTextField.text = "\(writeCount) 개" // 내가쓴 글 개수 가져와서 넣어주기
        }
        
        //-- 댓글 개수 가져오기
        ref.child("replys").queryOrderedByKey().observe(.value) { (snapshot) in
            for child in snapshot.children{
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                for (_,val)  in childValue{
                    let uidValue =  val as? [String:Any]
                    if let uid = uidValue {
                        if let uidd = uid["uid"] {
                            
                            if(String(describing: uidd) == self.userUid){
                                
                                replyCount = replyCount + 1
                                
                            }
                        }
                    }
                }
                
                self.mesageTextField.text = "\(replyCount) 개" // 내가쓴 댓글 개수 가져와서 넣어주기
            }
        }
        

        
        ref.removeAllObservers()
    }
    
    
    
    //쪽지보내기 컨트롤
    func sendMsgController(toid:String,toname:String,fromid:String,fromname:String)
    {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let margin:CGFloat = 8.0
        let rect = CGRect(margin, margin, alertController.view.bounds.size.width - margin * 15.0, 100.0)
        let customView = UITextView(frame: rect)
        
        customView.backgroundColor = UIColor.clear
        customView.font = UIFont(name: "Helvetica", size: 15)
        alertController.view.addSubview(customView)
        
        
        
        //쪽지 내용이 없으면 !
        let somethingAction = UIAlertAction(title: "보내기", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in //
            
            if customView.text == "" {
                let alert = UIAlertController(title: "알림 ", message:"내용을 입력해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let ref = Database.database().reference()
            let msgRefKey = ref.child("messages").childByAutoId().key
            let msgRef = ref.child("messages").child(msgRefKey)
            
            //데이터 객체 만들기
            let userInfo: [String:Any] = ["toid" : toid,
                                          "toname" : toname,
                                          "fromid" : fromid,
                                          "fromname": fromname,
                                          "content" : customView.text,
                                          "date" : ServerValue.timestamp()]
            //해당 경로에 삽입
            msgRef.setValue(userInfo)
            let alert = UIAlertController(title: "알림 ", message:"\(self.userName!)님에게 쪽지를 전달했습니다.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
        
        
    }

}
