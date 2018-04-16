//
//  DetailTalkViewController.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 14..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

class CurvedView:UIView{
    override func draw(_ rect: CGRect) {
        let path = customPath()
        path.lineWidth = 3
        path.stroke()
    }
}
func customPath() -> UIBezierPath{
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 200))
    let endPoint = CGPoint(x: 400, y: 200)
    let randomYshift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 100, y: 100 - randomYshift)
    let cp2 = CGPoint(x: 200, y: 300 + randomYshift)
    
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    return path
}

import UIKit
import Firebase
class DetailTalkViewController: UIViewController,ChildViewControllerDelegate {
    
    
    func childViewControllerResponse(text: String) {
         print("넘어온 데이터는")
        print(text)
    }
    
    
    //var replys = [Reply]()
    let cellId = "cellId"
    
    let uiScrollView : UIScrollView={
        let scv = UIScrollView()
        scv.translatesAutoresizingMaskIntoConstraints = false
        scv.isScrollEnabled = true
        scv.showsHorizontalScrollIndicator = false
        scv.showsVerticalScrollIndicator = false
        scv.contentInset = UIEdgeInsets()
        
        scv.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        return scv
    }()
    
    //넘어온 데이터
    var onePost : Post?{
        didSet{
            nameLabel.text = onePost?.name
            txtLabel.text = onePost?.text
            txtLabel.textAlignment = .center
            txtLabel.setLineSpacing(lineSpacing: 7)
            if let hit = onePost?.hit{
                hitLabel.text = "\(hit) 번 읽음"
            }
            
            dateLabel.text = onePost?.date
            pidLabel.text = onePost?.pid
            
            if let replyNum = onePost?.reply{
                replyHitLabel.text = "\(replyNum) 개 댓글"
                //replyLine.text = "  \(replyNum)  댓글"
            }
            
            if let blessNum = onePost?.blessCount{
                likesLabel.text = "좋아요 \(blessNum)"
            }else{
                likesLabel.text = "좋아요 0"
            }
            
            
            uidLabel.text = onePost?.uid
            showOrNotButton.setTitle(onePost?.show, for: UIControlState())
            likeButton.setImage(#imageLiteral(resourceName: "ic_favorite.png"), for: .normal)
        }
    }
    
    //버튼
    let seeImage: UIButton = {
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "ic_remove_red_eye.png"), for: .normal)
        
        starButton.tintColor = UIColor.lightGray
        starButton.isHidden = true
        starButton.translatesAutoresizingMaskIntoConstraints = false
        return starButton
    }()
    
    
    //버튼
    let replyImage: UIButton = {
        let starButton = UIButton(type: .system)
        starButton.isHidden = true
        // starButton.setImage(#imageLiteral(resourceName: "ic_comment.png"), for: .normal)
        starButton.tintColor = UIColor.lightGray
        starButton.translatesAutoresizingMaskIntoConstraints = false
        return starButton
    }()
    
    //버튼
    lazy var likeButton: UIButton = {
        let starButton = UIButton(type: .system)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.tintColor = UIColor.lightGray
        starButton.setImage(#imageLiteral(resourceName: "ic_favorite.png"), for: UIControlState())
        starButton.imageView?.contentMode = .scaleToFill
        starButton.imageEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        starButton.addTarget(self, action: #selector(touchBlessBtn), for: .touchUpInside)
        return starButton
    }()
    
    func likeBtnClicked(){
        let image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
        self.likeButton.setImage(image, for: .normal)
        self.likeButton.tintColor = UIColor.lightGray
        
    }
    var blessCheck = true
    var blessId:String?
    //축복해요 클릭되었을 때
    @objc func touchBlessBtn(){
        print("좋아요 버튼 클릭0 \(blessCheck)")
        let currentUid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        //이미 좋아요를 눌렀다. 그래서 false 가 되어있는 상태
        if(blessCheck == false && blessId == nil ){
            
            let alert = UIAlertController(title: "", message: "좋아요를 취소하시겠습니까?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
                //print("좋아요 버튼 클릭1 \(self.blessCheck)")
                ref.child("bless").child(self.pidLabel.text!).observeSingleEvent(of:.value) { (snapshot) in
                    for child in snapshot.children{
                        let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                        let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                        let childKey = childSnapshot.key
                        if let checkUid = childValue["uid"]{
                            if(checkUid as? String == currentUid){
                                
                               // print("좋아요 누를 수 없어요. 이미 좋아요를 눌렀었어요 , 그래서 좋아요가 취소되었어요.")
                                ref.child("bless").child(self.pidLabel.text!).child(childKey).removeValue()
                                ref.child("bless").child(self.pidLabel.text!).observeSingleEvent(of:.value, with: { (snapshot) in
                                    self.likesLabel.text = "좋아요 \(snapshot.childrenCount)"
                                })
                                self.likeBtnClicked()
                                //ref.removeAllObservers()
                            }else{
                               // print("내아이디가 아닌 것")
                                //ref.removeAllObservers()
                                
                            }
                        }
                    }
                    self.blessCheck = true
                   // print("좋아요 버튼 클릭2 \(self.blessCheck)")
                }
                
                ref.removeAllObservers()
                self.blessId = currentUid
            }
            let cancel = UIAlertAction(title: "닫기", style: .cancel) { (cancel) in
                //code
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            
            present(
                alert,
                animated: true,
                completion: nil)
            
        }else{
            
            var timer: Timer?
            let str = "Timer"
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMethod), userInfo: str, repeats: false)
            
        }
    }
    
    @objc func updateMethod(){
       // print("좋아요 버튼 클릭3 \(self.blessCheck)")
        let ref = Database.database().reference()
        let blessRef = ref.child("bless").child(self.pidLabel.text!)
        let blessKey = ref.child("bless").childByAutoId().key
        //데이터 객체 만들기
        let blessInfo: [String:Any] = [ "uid" : Auth.auth().currentUser?.uid ?? ""]
        blessRef.child(blessKey).setValue(blessInfo)
        
        let image = UIImage(named: "heart1")?.withRenderingMode(.alwaysTemplate)
        self.likeButton.setImage(image, for: .normal)
        self.likeButton.tintColor = UIColor.red
        
        //print("좋아요를 안눌러서 좋아요가 눌러져서 빨간색 하트가 됐어요")
        (0...10).forEach { (_) in
            self.generateAnimatedView()
        }
        
        self.blessCheck = false
        self.blessId = nil
        //print("좋아요 버튼 클릭4 \(self.blessCheck)")
        
        ref.child("bless").child(self.pidLabel.text!).observeSingleEvent(of:.value, with: { (snapshot) in
            self.likesLabel.text = "좋아요 \(snapshot.childrenCount)"
        })
        ref.removeAllObservers()
    }
    
    
    //버튼
    let showOrNotButton: UIButton = {
        let starButton = UIButton(type: .system)
        starButton.setTitle("비공개", for: UIControlState())
        starButton.titleLabel?.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 8.5)!
        starButton.tintColor = UIColor.lightGray
        starButton.translatesAutoresizingMaskIntoConstraints = false
        return starButton
    }()
    
    
    //likes
    var likesLabel: UILabel = {
        let label = UILabel()
        //label.isHidden = true
        label.text = "0"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 8.5)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //uid
    var uidLabel: UILabel = {
        let label = UILabel()
        //label.text = "pid"
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //pid
    var pidLabel: UILabel = {
        let label = UILabel()
        //label.text = "pid"
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //이름
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        
        label.text = "이름"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectName))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    //글에서 이름이 클릭되었을 때
    @objc func handleSelectName(){
        
        let myid = Auth.auth().currentUser?.uid
        if(uidLabel.text == myid!){
            let viewController = MyPostVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let viewController = ShowUserPost()
            viewController.userId = uidLabel.text
            viewController.userName = nameLabel.text
            let navController = UINavigationController(rootViewController: viewController)
            //self.navigationController?.pushViewController(navController, animated: true)
            self.present(navController, animated: true, completion: nil)
        }
        
    }
    
    
    //텍스트
    var txtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 13.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    //날짜
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간전"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 14.5)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //조회수
    var hitLabel: UILabel = {
        let label = UILabel()
        label.text = "6번 읽음"
        label.isHidden = true
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //댓글 수
    var replyHitLabel: UILabel = {
        let label = UILabel()
        label.text = "15 댓글"
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // =============================================== 좋아요 애니메이션  ===========================================
    
    func generateAnimatedView(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "heart.png"))
        let dimension = 20 + drand48() * 10
        imageView.frame = CGRect(x:0,y:0,width:dimension, height:dimension)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        imageView.layer.add(animation, forKey: nil)
        view.addSubview(imageView)
    }
    
    //수정완료하고 돌아올때 마다 바로 반영 하기
    override func viewWillAppear(_ animated: Bool) {
        let ref = Database.database().reference()
        ref.child("posts").child(pidLabel.text!).observeSingleEvent(of: .value) { (snpat) in

            let childSnapshot = snpat //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                self.txtLabel.text = childValue["text"] as? String
        }
        ref.removeAllObservers()
    }
    
    // =====================      진입점        =================================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.navigationItem.title = "\(String(describing: nameLabel.text!))의 시"
        
        //취소 바 버튼
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goTalkViewController))
        //로그인 한 유저의. id와 지금 쓴글의 사람의 uid와 같으면 오른쪽 설정바 보이게
        if(Auth.auth().currentUser?.uid == uidLabel.text){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action:  #selector(goSettingAlertAction))
        }
        
        txtLabel.textAlignment = .center
        
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        
        //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        
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
        
        //likeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 20);
        
        hideKeyboard()
        setLayout()
        checkBlessBtn()
        
    }
    
    
    //축복해요 체크 버튼
    func checkBlessBtn(){
        
        let currentUid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("bless").child(pidLabel.text!).observe(.value) { (snapshot) in
            for child in snapshot.children{
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                let childKey = childSnapshot.key
                if let checkUid = childValue["uid"]{
                    if(checkUid as? String == currentUid){
                        //print("이미 좋아요를 눌렀네요?")
                        //print("childKey - \(childKey)")
                        let image = UIImage(named: "heart1")?.withRenderingMode(.alwaysTemplate)
                        self.likeButton.setImage(image, for: .normal)
                        self.likeButton.tintColor = UIColor.red
                        self.blessCheck = false //좋아요 눌러진 상태면 false
                        
                    }else{
                       // print("좋아요 눌러볼래요?")
                        let image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
                        self.likeButton.setImage(image, for: .normal)
                        self.likeButton.tintColor = UIColor.lightGray
                        self.blessCheck = true
                        
                    }
                }
                
            }
        }
        ref.removeAllObservers()
        //print("들어올때 축복 체크버튼 확인 - \(self.blessCheck)")
    }
    
    
    //수다방으로 가기
    @objc func goTalkViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    //레이아웃 조정
    func  setLayout(){
        
        view.addSubview(uiScrollView)
        uiScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        uiScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        uiScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        uiScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        let myView = UIView()
        myView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        uiScrollView.addSubview(myView)
        myView.topAnchor.constraint(equalTo: uiScrollView.topAnchor).isActive = true
        myView.leadingAnchor.constraint(equalTo: uiScrollView.leadingAnchor).isActive = true
        myView.trailingAnchor.constraint(equalTo: uiScrollView.trailingAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: uiScrollView.bottomAnchor).isActive = true
        myView.widthAnchor.constraint(equalTo: uiScrollView.widthAnchor).isActive = true
        //myView.heightAnchor.constraint(equalToConstant: 2000).isActive = true
        
        
        myView.addSubview(dateLabel)
        
        dateLabel.topAnchor.constraint(equalTo: myView.topAnchor,constant: 120).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        
        
        myView.addSubview(txtLabel)
        txtLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 45).isActive = true
        txtLabel.leadingAnchor.constraint(equalTo: myView.leadingAnchor,constant: 5).isActive = true
        txtLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor,constant: -5).isActive = true
        //txtLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        //txtLabel.heightAnchor.constraint(equalTo: myView.heightAnchor).isActive = true
        
        myView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 45).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        //nameLabel.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -45).isActive = true
        
        
        myView.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //likeButton.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant:-45).isActive = true
        
        
        myView.addSubview(likesLabel)
        likesLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8).isActive = true
        likesLabel.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        //likesLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        //likesLabel.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant:-50).isActive = true
        likesLabel.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant:-90).isActive = true
        
        //myView.addSubview(showOrNotButton)
        //showOrNotButton.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 20).isActive = true
        //showOrNotButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        //showOrNotButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        //showOrNotButton.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant:-80).isActive = true
        
        
        
        
        /*
         // seeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
         //seeImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
         // seeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
         //seeImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-100).isActive = true
         
         //hitLabel.leadingAnchor.constraint(equalTo: seeImage.trailingAnchor, constant: 5).isActive = true
         //hitLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
         // hitLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
         //hitLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
         
         pidLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 15).isActive = true
         pidLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 5).isActive = true
         pidLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
         pidLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
         
         uidLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 15).isActive = true
         uidLabel.leadingAnchor.constraint(equalTo: pidLabel.trailingAnchor, constant: 5).isActive = true
         uidLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
         uidLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
         
         */
    }
    
    //글공개
    func showAction(pid:String){
        //print("글나누기\(pid)")
        let showing = ["show" : "y"]
        //여기가 문제
        let ref = Database.database().reference()
        ref.child("posts").child(pid).updateChildValues(showing)
        let alert = UIAlertController(title: "", message:"글을 공개했습니다.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //글비공개
    func noShowAction(pid:String){
        //print("글비공개\(pid)")
        //fb db 연결 후 posts 테이블에 key가 pid인 데이터의 hit 개수 변경해주기
        let showing = ["show" : "n"]
        //여기가 문제
        let ref = Database.database().reference()
        ref.child("posts").child(pid).updateChildValues(showing)
        let alert = UIAlertController(title: "", message:"글을 비공개했습니다.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //글 설정 네비게이션 바 버튼 아이템을 눌렀을 때
    @objc func goSettingAlertAction(){
        //print(" 글 설정 얼러트 창 뛰우기")
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .alert)
        
        let showAction = UIAlertAction(title: "공개", style: .default) { (alert) in
            //print("글나누기")
            self.showAction(pid:self.pidLabel.text!)
            
        }
        
        let noShowAction = UIAlertAction(title: "비공개", style: .default) { (alert) in
            //print("글비공개")
            self.noShowAction(pid:self.pidLabel.text!)
        }
        
        
        let modifyAction = UIAlertAction(title: "수정", style: .default) { (alert) in
            //print("글 수정")
            
            //self.settingAlertAction(txt: self.txtLabel.text!, pid: self.pidLabel.text!)
            let viewController = ModifyVC()
            
            viewController.textFiedlView.text = self.txtLabel.text!
            viewController.pid = self.pidLabel.text
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (alert) in
            
            let xss = self.replyHitLabel.text?.characters.split(separator:" ").map{ String($0) }
            let replyNum = Int(xss![0])!
            //댓글이 없을 때만 본인의 글을 지울 수 있다.
            if(replyNum == 0){
                let ref = Database.database().reference()
                ref.child("posts").child(self.pidLabel.text!).removeValue()
                let alert = UIAlertController(title: "", message:"삭제되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                } )
                
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                let alert = UIAlertController(title: "", message:"댓글이 있는 글은 삭제할 수 없습니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (alert) in
            //print("취소")
        }
        
        alertController.addAction(modifyAction)
        alertController.addAction(deleteAction)
        alertController.addAction(showAction)
        alertController.addAction(noShowAction)
        alertController.addAction(cancelAction)
        
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    
    
    var modifyText:String?
    //상세 글 수정 alert controller 창
    var modifyMainText:String?
    func settingAlertAction(txt:String, pid:String)
    {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let margin:CGFloat = 8.0
        let rect = CGRect(margin, margin, alertController.view.bounds.size.width - margin * 15.0, 100.0)
        let customView = UITextView(frame: rect)
        
        customView.backgroundColor = UIColor.clear
        customView.font = UIFont(name: "Helvetica", size: 15)
        customView.text = txt
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "수정", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in //print("something")
            self.modifyText = customView.text
            
            let ref = Database.database().reference()
            ref.child("posts").child(pid).updateChildValues(["text":self.modifyText ?? "",
                                                             "date":ServerValue.timestamp()])
            let alert = UIAlertController(title: "알림 ", message:"수정되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            } )
            
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
        
    }
    
}
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

