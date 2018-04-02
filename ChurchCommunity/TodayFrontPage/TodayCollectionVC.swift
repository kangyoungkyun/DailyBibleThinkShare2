//
//  TodayCollectionVC.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 27..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class TodayCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout,CollectionViewCellDelegate {
    var logout = false
    func showAllPosts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.tabBarController
        //인디케이터 종료
        self.present(tabBarController!, animated: true, completion: nil)
    }
    
    func writeAction() {
        
        let writeView = WriteViewController()
        //글쓰기 화면을 rootView로 만들어 주기
        let navController = UINavigationController(rootViewController: writeView)
        self.present(navController, animated: true, completion: nil)
        
       /* let myUid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(myUid!).observe(.value) { (snapshot) in
            
            let childSnapshot = snapshot //자식 DataSnapshot 가져오기
            let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
            
            
            if let pass = childValue["pass"] as? String{
                if pass == "n"{
                    let alert = UIAlertController(title: "Sorry", message:"승인 후 이용가능합니다.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }else if(pass == "y"){
                    //글쓰기 화면
                    let writeView = WriteViewController()
                    //글쓰기 화면을 rootView로 만들어 주기
                    let navController = UINavigationController(rootViewController: writeView)
                    self.present(navController, animated: true, completion: nil)
                }
            }
            
        }*/
    }
    
    
//    let pages = [
//        Page(headerText: "피난처", bodyText: ""),
//        Page(headerText: "", bodyText: "주님 나를 도와주세요\n아무것도 모르고\n아무것도 못해요\n내 생명이 항상 위험하지만\n주님은 나의 피난처에요\n주님 나를 도와주세요.\n\n <도움/송현숙>"),
//        Page(headerText: "일일\n묵상", bodyText: "")
//    ]
    
    var pages = [Page]()
    
    //페이지 컨트롤러
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        pc.pageIndicatorTintColor = UIColor.white
        return pc
    }()
    
    //오른쪽으로 스크롤 했을 때 - 위치로 현재 페이지 구해주기
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //페이지 안에서 로그아웃 버튼을 눌렀을 때 한번더 로그아웃 해주기
        
         let firebaseAuth = Auth.auth().currentUser?.uid
        
        if (firebaseAuth == nil){
            print("로그아웃된것이 확인되었습니다.")
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomControls()
        //SwipingController 객체를 생성하고 최상위 뷰로 설정
        
        //배경색을 흰색
        collectionView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)

        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        //collectionView에 cell을 등록해주는 작업, 여기서는 직접 만든 cell을 넣어주었고, 아이디를 설정해 주었다.
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        //페이징기능 허용
        collectionView?.isPagingEnabled = true
        
        getSingle()
        
        setData()
        
        
    }
    var todateCheck = ""
    var todate = ""
    //현재 날짜 한글
    func getSingle(){
        var date = Date()
        let calendar = Calendar.current //켈린더 객체 생성
        let year = calendar.component(.year, from: date)    //년
        let month = calendar.component(.month, from: date)  //월
        let day = calendar.component(.day, from: date)      //일
        
        todate = "\(year)년 \(month)월 \(day)일,"
        todateCheck = "\(year)\(month)\(day)"
    }

    
    func setData(){
        
         let ref = Database.database().reference()
        print("check date ===" , todateCheck)
        ref.child("front").child(todateCheck).observe(.value) { (snapshot) in
            
            for child in snapshot.children{
               
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                var pasge = Page(headerText: "", bodyText: "")
                print("childvalue: ",childValue)
                
                if let a = childValue["a"]{
                    print("a : ", a)
                    pasge = Page(headerText: a as! String, bodyText: "")
                }else if let b = childValue["b"]{
                    pasge = Page(headerText: "" , bodyText: b as! String)
                }
            
                self.pages.insert(pasge, at: 0)
        }
            self.collectionView?.reloadData()
            
    }
        ref.removeAllObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
  
    override func viewDidLayoutSubviews() {
          self.setupBottomControls()
    }
    //스택뷰 객세 생성과 위치 설정 함수
    fileprivate func setupBottomControls() {
        
        //uistackview 객체 만들기 배열 타입으로 view 객체들이 들어간다
        let bottomControlsStackView = UIStackView(arrangedSubviews: [ pageControl])
        //오토레이아웃 설정 허용해주기
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        //객체들이 하나하나 보이게 설정
        bottomControlsStackView.distribution = .fillEqually
        //bottomControlsStackView.axis = .vertical
        
        //전체 뷰에 위에서 만든 stackView를 넣어준다.
        view.addSubview(bottomControlsStackView)
        
        //스택뷰 위치 지정해주기
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}
