//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

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

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
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
        //return day == 7 ? 1 : day
//        print("getFirstWeekDay 시작")
//        print("currentYear - \(currentYear)")
//        print("currentMonthIndex - \(currentMonthIndex)")
//        print("day - \(day)")
//         print("getFirstWeekDay 끝 -/")
        return day
    }
    
    //빈칸을 포함한 전체 섹션의 개수를 구한다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       // print("collectionView 시작")
       // print("numOfDaysInMonth - \(numOfDaysInMonth)")
       // print("currentMonthIndex - \(currentMonthIndex)") //4월
       // print("firstWeekDayOfMonth - \(firstWeekDayOfMonth)") //1 : 첫째 날이 일요일
        //print(numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1) //30
        //print("collectionView 끝 -/")
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1 //칸의 전체 개수 , 비칸 까지 포함해서
    }
    
    
    
    let tmonth = Calendar.current.component(.month, from: Date())
    let tyear = Calendar.current.component(.year, from: Date())
    let tday = Calendar.current.component(.day, from: Date())
    
    //숫자 채우기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        
        //print("collectionView - cellForItemAt - 시작")
        //print("indexPath.item - \(indexPath.item)")
        //print("firstWeekDayOfMonth - 2 - \(firstWeekDayOfMonth - 2)") //-1
        //print("collectionView - cellForItemAt - 끝")
        
        //셀의 객체가 달의 첫번째 요일 - 2 보다 작으면
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            //해당 셀을 숨겨줘라
            cell.isHidden=true
        } else {
            //셀의 객체가 달의 첫번째 요일 - 2 보다 작지 않으면 날짜 day를 적어줘라
            
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            //print("indexPath.row - \(indexPath.row)")
            //print("calcDate - \(calcDate)")

            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            if(currentYear == self.tyear && currentMonthIndex == self.tmonth && self.tday == calcDate){
             
            cell.backgroundColor = .lightGray
            }
            
            
            print(currentMonthIndex) //보여지는 달
            print(presentMonthIndex) //현재 달
            if calcDate > todaysDate && currentMonthIndex == presentMonthIndex || currentMonthIndex > presentMonthIndex || currentYear > presentYear{
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
            }
            
        }
        
        print("오늘은 무슨 요일인가요1? - \(presentYear): \(presentMonthIndex): \(self.tday)")
        print("\n")
        print("오늘은 무슨 요일인가요?2 - \(self.tyear): \(self.tmonth): \(self.tday)")

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        //cell?.backgroundColor=Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        //lbl.textColor=UIColor.white
        print(currentMonthIndex,lbl.text!)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell=collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor=UIColor.clear
//        let lbl = cell?.subviews[1] as! UILabel
//        lbl.textColor = Style.activeCellLblColor
//    }
    
    
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
        
        //monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
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













