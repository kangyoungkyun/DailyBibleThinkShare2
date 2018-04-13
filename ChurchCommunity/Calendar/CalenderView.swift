//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import Firebase
struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

protocol Dissmiss: class {
    func dissmissAndReturnValue(year:Int,month:Int,day:Int)
}




class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate,MyPostClickCalenderSendMyId {
    
    func MyPostClickCalenderSendMyId(myid: String) {
        print("calendarController에서 넘긴 아이디값을 CalenderView 에서 받았습니다. \(String(describing: myid))")
        self.myId = myid
        
        
    }
    //var cnt = 0
    //var whenIWritePost = [String]()
    //var emptySet2 : Set<String> = []
    
    var whenIWritePost = Set<String>()
    func showWhenIWritePost(){
        let ref = Database.database().reference()
        ref.child("posts").observeSingleEvent(of:.value) { (snapshot) in
            self.whenIWritePost.removeAll() //배열을 안지워 주면 계속 중복해서 쌓이게 된다.
            for child in snapshot.children{
                //let postToShow = Post() //데이터를 담을 클래스
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                
                if let date = childValue["date"], let uid = childValue["uid"] {
                    if(uid as? String == self.myId){
                        //오늘 날짜에 작성된 글 개수 파악
                        if let t = date as? TimeInterval {
                            let date = NSDate(timeIntervalSince1970: t/1000)
                            let calendar = Calendar.current //켈린더 객체 생성
                            let year = calendar.component(.year, from: date as Date)  //월
                            let month = calendar.component(.month, from: date as Date)  //월
                            let day = calendar.component(.day, from: date as Date)      //일
                            
                            //print("\(year)\(month)\(day)")
                            
                                self.whenIWritePost.insert("\(year)\(month)\(day)")
                            
                            
                        }
                        //print("언제 썻니? \(date)")
                    }
                }
            }
            
            self.myCollectionView.reloadData()
            print("대체 몇개를 쓴거니~? \(self.whenIWritePost.count)")
           
        }
        ref.removeAllObservers()
        
    }
    
    
    //나의 키
    var myId:String?
    
    var dissmissDelegate : Dissmiss?
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    //이번달
    var currentMonthIndex: Int = 0
    //올해
    var currentYear: Int = 0
    
    //보여지는 달
    var presentMonthIndex = 0
    //보여지는 년
    var presentYear = 0
    var todaysDate = 0
    
    
    
    
    //
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("여기가 진입점 입니다.")
        showWhenIWritePost()
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        initializeView()
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    
    
    
    func initializeView() {
        
        //print("컬렉션 뷰에 넘어온 나의 키 \(String(describing: self.myId))")
        
        //현재 달 가져오기
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        //현재 년 가져오기
        currentYear = Calendar.current.component(.year, from: Date())
        //오늘 날짜 가져오기
        todaysDate = Calendar.current.component(.day, from: Date())
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //윤년 처리해 주기
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        //현재 보여지는 달도 현재 달
        presentMonthIndex=currentMonthIndex
        //현재 보여지는 해도 올해
        presentYear=currentYear
        
        //레이아웃 지정 해주기
        setupViews()
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //가장 첫달의 1일이 무슨 요일인지 구한다.
    //일 :1 , 월:2, 화:3, 수:4, 목:5, 금:6, 토:7
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    //빈칸을 포함한 전체 섹션의 개수를 구한다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 컬렉션 뷰 개수
        print("컬랙션 뷰 개수-1")
        //whenIWritePost.removeAll()
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1 //칸의 전체 개수 , 비칸 까지 포함해서
    }
    
    
    let tmonth = Calendar.current.component(.month, from: Date())
    let tyear = Calendar.current.component(.year, from: Date())
    let tday = Calendar.current.component(.day, from: Date())
    
  
   
    //숫자 채우기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        cell.backgroundView = nil
        print("컬랙션 뷰 구성 - 2")
        
        //셀의 객체가 달의 첫번째 요일 - 2 보다 작으면
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            //해당 셀을 숨겨줘라
            cell.isHidden=true
        } else {
            //셀의 객체가 달의 첫번째 요일 - 2 보다 작지 않으면 날짜 day를 적어줘라
            
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            //오늘 날짜면 색첼
            if(currentYear == self.tyear && currentMonthIndex == self.tmonth && self.tday == calcDate){
                cell.backgroundColor = .green
            }
            
            //오늘 이후 날짜는 비활성화 및 회색으로 표시
            if calcDate > todaysDate && currentMonthIndex == presentMonthIndex || currentMonthIndex > presentMonthIndex || currentYear > presentYear{
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = UIColor.lightGray
            } else {
                
                //set에 넣어놓은 날짜와 비교 하기
                for i in self.whenIWritePost{
                    if("\(i)"=="\(currentYear)\(currentMonthIndex)\(calcDate)"){
                        print("같은 날짜에 적은 글이 있네요 체크 표시를 합니다 - \(i)")
                        cell.isUserInteractionEnabled=true
                        let doneView = UIImageView(image:#imageLiteral(resourceName: "done.png"))
                        cell.backgroundView = doneView
                    }else{
                        
                        print("같은 날짜에 적은 글이 없습니다. ㅠㅠ")
                        cell.isUserInteractionEnabled=true
                        cell.lbl.textColor = Style.activeCellLblColor
                    }
                }

            }
            
        }
        print("컬렉션 뷰 구성-3")
        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        //cell?.backgroundColor=Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        //lbl.textColor=UIColor.white
        print(currentMonthIndex,lbl.text!)
        //날짜 클릭, -> 델리게이트로 -> calendarController 꺼주기
        
        
        self.dissmissDelegate?.dissmissAndReturnValue(year: currentYear, month: currentMonthIndex, day: Int(lbl.text!)!)
        
    }
    
    
    //컬렉션 뷰 레이아웃 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        print("이전달 이후 달 이 눌렀씁니다.")
        print("\n")
        whenIWritePost.removeAll()
        showWhenIWritePost()
        
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        myCollectionView.reloadData()
        //whenIWritePost.removeAll()
        whenIWritePost.removeAll()
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=20
        layer.masksToBounds=true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}













