//
//  ViewController.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}


protocol MyPostClickCalenderSendMyId: class {
    func MyPostClickCalenderSendMyId(myid:String)
}


class CalendarController: UIViewController,Dissmiss {
    
    var myPostClickCalenderSendMyIdDelegate:MyPostClickCalenderSendMyId?
    
    

    //key
    var Myid: String?
    
    //메인페이지에서 달력열고 달력의 날짜를 누르면 이곳이 반응하고 데이터가 넘어온다.
    func dissmissAndReturnValue(year: Int, month: Int, day: Int) {
        //print(year,month,day)

        
        //어디서 연건지 처리해줘야 한다.
        
        let fontPage = self.navigationController?.viewControllers[0] as! TodayBibleTextVC
        fontPage.selectedYear = year
        fontPage.selectedMonth = month
        fontPage.selectedDay = day
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    var theme = MyTheme.dark
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //calenderView에 있는 dissmissDelegate에 이벤트가 발생하면 작동될 창은 나다.(내가 calenderView에 있는 프로토콜 메서드를 구현했다.!)
        calenderView.dissmissDelegate = self
        
        
        
        self.title = "묵상달력"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 13.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState())
        
        //네비게이션 바 버튼 오른쪽 아이템 글꼴 바꾸기
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 13.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState())
        
        
        //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        calenderView.myId = Myid
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        //let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        //self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("나의묵상페이지에서 넘긴 아이디값을 calendarController 에서 받았습니다. \(String(describing: self.Myid))")
        //calenderView.myId = Myid
        
        //일일묵상 페이지에서 달력 눌렀을 때 처리해주기 즉 nil 값 처리 해주기!
        if let myid = self.Myid{
            self.myPostClickCalenderSendMyIdDelegate?.MyPostClickCalenderSendMyId(myid: Myid!)
        }
        
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    lazy var calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.light)
        self.myPostClickCalenderSendMyIdDelegate = v //이게 핵심이었다!!!!!!!!!!!
        v.translatesAutoresizingMaskIntoConstraints=false
        v.myId = "bbbbbbb"
        return v
    }()
    
}

