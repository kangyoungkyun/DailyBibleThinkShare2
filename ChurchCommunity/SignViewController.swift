//
//  SignViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 12..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//
import UIKit
import Firebase
class SignViewController: UIViewController {
    
//    let mainTitle : UILabel = {
//        let title =  UILabel()
//        title.text = "행복한 우리동네 가입"
//        title.textColor = UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)
//
//        title.font = UIFont.boldSystemFont(ofSize: 18)
//        title.translatesAutoresizingMaskIntoConstraints = false
//        return title
//    }()
//
    let imageView: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 32.0)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth=true
        lable.text = "일일\n묵상"
        lable.numberOfLines = 2
        lable.minimumScaleFactor=0.5;
        return lable
    }()
    
    //이름 필드
    let nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "필명"
        name.autocorrectionType = .no
        name.autocapitalizationType = .none
        name.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 16.5)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        return name
    }()
    
    //이름 구분선 만들기
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //이메일 필드
    let emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "이메일"
        email.translatesAutoresizingMaskIntoConstraints = false
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        email.keyboardType = .emailAddress
        email.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 16.5)
        return email
    }()
    
    
    //이메일 구분선 만들기
    let emailSeperatorView: UIView = {
        let view = UIView()
       view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //패스워드 필드
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "비밀번호"
        password.isSecureTextEntry = true
        password.font =  UIFont(name: "NanumMyeongjo-YetHangul", size: 16.5)
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    //비밀번호 구분선 만들기
    let passwordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //버튼
    let signButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        button.setTitle("시작하기", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: UIControlState())
        button.titleLabel?.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 16.5)
        button.layer.cornerRadius = 10; // this value vary as per your desire
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signAction), for: .touchUpInside)
        return button
    }()
    
    //가입 로직 처리 함수
    @objc func signAction(){
        
        guard nameTextField.text != "", emailTextField.text != "", passwordTextField.text != "" else{return}
        //인디케이터 시작
        AppDelegate.instance().showActivityIndicator()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                //print("error: \(error.localizedDescription)")
                //가입 폼 유효성 검사
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        let alert = UIAlertController(title: "알림 ", message:"이메일 형식을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "알림 ", message:"이미 존재하는 이메일입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .weakPassword :
                        let alert = UIAlertController(title: "알림 ", message:"보안에 취약한 비밀번호입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "알림 ", message:"다시 시도해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                //인디케이터 종료
                AppDelegate.instance().dissmissActivityIndicator()
                return
            }
            
            
            //파이어 베이스 쪽에 이름도 넣어주기
            if let user = user{
                let ChangeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                ChangeRequest.displayName = self.nameTextField.text!
                ChangeRequest.commitChanges(completion: nil)
                
                
                //데이터 베이스 참조 함수
                var ref: DatabaseReference!
                ref = Database.database().reference()
                //부모키 user를 만들고 그 밑에 각자의 아이디로 또 자식을 만든다.
                let usersReference = ref.child("users").child(user.uid)
                
                //데이터 객체 만들기
                let userInfo: [String:Any] = ["uid" : user.uid,
                                              "name" : self.nameTextField.text ?? "주민1",
                                              "pass" : "y"]
                //해당 경로에 삽입
                usersReference.setValue(userInfo)
                
                
                //가입할때 도토리 개수 디폴트 값으로 넣어주기
                let dotoriRef = ref.child("dotori").child(user.uid)
                let dotoriInfo: [String:Any] = ["total" : 0,
                                                "name" : self.nameTextField.text ?? "주민1",
                                                "uid" : user.uid]
                
                dotoriRef.setValue(dotoriInfo)
                
                
                
                ref.removeAllObservers()
                
                print("가입성공")
                
                //tabbarController 가져오기
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //let tabBarController = appDelegate.tabBarController
                //인디케이터 종료
                AppDelegate.instance().dissmissActivityIndicator()
                //self.present(tabBarController!, animated: true, completion: nil)
                
                let layout = UICollectionViewFlowLayout()
                //가로로 스크롤되게 설정
                layout.scrollDirection = .horizontal
                //SwipingController 객체를 생성하고 최상위 뷰로 설정
                let viewcontroller = TodayCollectionVC(collectionViewLayout: layout)
                self.present(viewcontroller, animated: true, completion: nil)
            }
        }
    }
    
    //뒤로가기 버튼
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    //뒤로가기 함수
    @objc func cancelAction(){
        print("뒤로가기  버튼이 눌렀습니다.")
        self.dismiss(animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //바탕화면 누르면 키보드 숨기기
        hideKeyboard()
        self.view.backgroundColor = UIColor.white
        //view.addSubview(mainTitle)
        view.addSubview(imageView)
        view.addSubview(nameTextField)
        view.addSubview(nameSeperatorView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailSeperatorView)
        view.addSubview(passwordSeperatorView)
        view.addSubview(signButton)
        view.addSubview(cancelButton)
        
        //제약조건 레이아웃 설정
        setLayout()
        //로그인 상태 체크
        sessionCheck()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bac2.jpg")!)
    }
    
    //로그인 상태 체크
    func sessionCheck(){
        if Auth.auth().currentUser?.uid == nil {
            do {
                try Auth.auth().signOut()
            } catch let logoutError {
                print(logoutError)
            }
        }else{
            //유저아이디가 있으면 0.1 초 뒤에 appDelegate에 있는 tabBarController 참조 가져오기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { //0.1초 뒤
                // Your code with delay
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let tabBarController = appDelegate.tabBarController
                self.present(tabBarController!, animated: true, completion: nil)
            }
        }
    }
    //레이아웃 셋팅
    func setLayout(){
        

        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor, constant: 30).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor, constant: 30).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: emailSeperatorView.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: emailSeperatorView.trailingAnchor).isActive = true
        
        passwordSeperatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeperatorView.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        passwordSeperatorView.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        passwordSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        signButton.topAnchor.constraint(equalTo: passwordSeperatorView.bottomAnchor, constant:30).isActive = true
        signButton.leadingAnchor.constraint(equalTo: passwordSeperatorView.leadingAnchor).isActive = true
        signButton.widthAnchor.constraint(equalTo: passwordSeperatorView.widthAnchor).isActive = true
        signButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: signButton.bottomAnchor, constant:30).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: signButton.leadingAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: signButton.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
}
