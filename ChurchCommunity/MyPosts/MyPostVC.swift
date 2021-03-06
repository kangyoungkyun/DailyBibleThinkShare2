//
//  NoticeAHVC.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 23..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//


import UIKit
import Firebase
class MyPostVC: UITableViewController,UISearchBarDelegate {
    

    

    /*   let searchController : UISearchController = {
     let uisearchController = UISearchController(searchResultsController: nil)
     uisearchController.searchBar.placeholder = "검색"
     //uisearchController.searchBar.barTintColor = UIColor.white
     uisearchController.searchBar.backgroundColor =  UIColor(red:0.13, green:0.30, blue:0.53, alpha:1.0)
     
     return uisearchController
     }()*/
    
    //검색버튼 눌렀을 때
    /* func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     searchPosts.removeAll()
     //print("서치바 \(String(describing: searchController.searchBar.text!))")
     searchPosts = posts.filter({ (post) -> Bool in
     guard let text = searchController.searchBar.text else{return false}
     return post.text.contains(text)
     })
     self.tableView.reloadData()
     
     }*/
    
    var posts = [Post]()
    var searchPosts = [Post]()
    let cellId = "cellId"
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    //테이블 뷰 당기면 리프레쉬
    lazy var freshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor(red:0.59, green:0.28, blue:0.27, alpha:1.0)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        freshControl.endRefreshing()
    }
    
    
    
    //글쓰기 플로팅 버튼
    lazy var writeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.8
        button.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 90 , width: 45, height: 45)
        button.layer.cornerRadius = button.frame.width/2
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.setBackgroundImage(#imageLiteral(resourceName: "pencil.png"), for: UIControlState())
        button.addTarget(self, action: #selector(writeActionFlotingButton), for: .touchUpInside)
        return button
    }()
    //플로팅 액션 버튼
    @objc func writeActionFlotingButton(){
        //print("바탕화면에서 글쓰기 버튼 클릭!")
        let writeView = WriteViewController()
        //글쓰기 화면을 rootView로 만들어 주기
        let navController = UINavigationController(rootViewController: writeView)
        self.present(navController, animated: true, completion: nil)
    }
    
    //필명 라벨
    var nameLable: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 21.5)
        label.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //소개글 라벨
    lazy var introLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 14.5)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectName))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        //라벨 줄 간격
        let attributedString = NSMutableAttributedString(string: "")
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2.5 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        label.attributedText = attributedString;
        
        return label
    }()
    
    @objc func handleSelectName(){
        
        let alert = UIAlertController(title: "", message: "좋아하는 말씀 또는 문장 작성", preferredStyle: .alert)
        alert.addTextField { (myTextField) in
            
            myTextField.textColor = UIColor.lightGray
            myTextField.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 11.5)
        
            
        }
        
        let ok = UIAlertAction(title: "작성", style: .default) { (ok) in
            let txt = alert.textFields?[0].text
            let key = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(key!).updateChildValues(["stateMsg" : txt ?? ""])
        }
        
        let cancel = UIAlertAction(title: "닫기", style: .cancel) { (cancel) in
            //code
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)

        
    }
    
    
    //글 개수 / 공개개수
    var countLable: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerView : UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        return header
    }()
    
    
    
    
    //테이블 뷰 셀에서 이름이 클릭되었을 때
    func userClickCell(uid: String) {
        //let viewController = ShowPageViewController()
        //viewController.userUid = uid
        //navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //탭바 스크롤 하면 숨기기
    /*
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            changeTabBar(hidden: true, animated: true)
        }
        else{
            changeTabBar(hidden: false, animated: true)
        }
    }
    func changeTabBar(hidden:Bool, animated: Bool){
        print("changeTabbar")
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
    }*/
    
    //진입점
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:220)
        tableView.tableHeaderView = headerView
        
        tableView.addSubview(freshControl)
        
        setHeaderViewLayout()
        
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)

        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -60).isActive = true
        activityIndicatorView.bringSubview(toFront: self.view)
        activityIndicatorView.startAnimating()
        tableView.separatorStyle = .none
        
        DispatchQueue.main.async {
            
            OperationQueue.main.addOperation() {
                
                self.tableView.separatorStyle = .none
                Thread.sleep(forTimeInterval: 1.7)
                
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
        
        showPost()
        
        searchPosts.removeAll()
        //searchController.searchBar.delegate = self
        
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)

        tableView.backgroundView?.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)


        self.navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.prefersLargeTitles = false
        //navigationItem.searchController = searchController
        
        
      // self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "글쓰기", style: .plain, target: self, action:  #selector(writeAction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add.png"), style: .plain, target: self, action:  #selector(writeAction))
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_date_range.png"), style: .plain, target: self, action:  #selector(dateRage))
        
        
        
        //네비게이션 바 버튼 아이템 글꼴 바꾸기
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "NanumMyeongjo-YetHangul", size: 15.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState())
        
        
        tableView.register(MyPostCell.self, forCellReuseIdentifier: cellId)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.addSubview(writeButton)
    }
    
    
    @objc func dateRage(){
       // print("나의 페이지에서 열어라 캘린더 얼러트 창")
        let myId = Auth.auth().currentUser?.uid
        let vc = CalendarController()
        vc.Myid = myId
        navigationController?.pushViewController(vc, animated: true)

    }
    
    //글쓰기 플로팅 버튼 함수
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  off = self.tableView.contentOffset.y
        writeButton.frame = CGRect(x: view.frame.width - 60, y: off + (view.frame.height - 135), width: writeButton.frame.size.width, height: writeButton.frame.size.height)
    }
    //동적 테이블 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //동적 테이블 높이
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //mypage보기
    @objc func myAction(){
       // let viewController = ShowPageViewController()
        //self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    //글쓰기
    @objc func writeAction(){
        let myUid = Auth.auth().currentUser?.uid
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
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
    
        if posts.count > 0 {
        
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: self.tableView.bounds.size.width,
                          height: self.tableView.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        noDataLabel.text = "오늘하루 말씀을 묵상하는 가운데\n떠오르는 생각을 기록해보세요."
        noDataLabel.numberOfLines = 2
        noDataLabel.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 13.5)
        noDataLabel.textColor = UIColor.lightGray
        noDataLabel.textAlignment = NSTextAlignment.center
        self.tableView.backgroundView = noDataLabel
        self.tableView.separatorStyle = .none
        
        return 0
        
    }
    
    
    //행 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* if(searchController.isActive && searchController.searchBar.text != ""){
         return searchPosts.count
         }*/
        return posts.count
    }
    
    //테이블 뷰 셀의 구성 및 데이터 할당 부분
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MyPostCell
        //cell?.delegate = self
        
        //버튼에 밑줄
      //  var attrs = [
        //    NSAttributedStringKey.underlineStyle : 1]
       // var attributedString = NSMutableAttributedString(string:"")
       // let buttonTitleStr = NSMutableAttributedString(string:"\(posts[indexPath.row].show!)", attributes:attrs)
       // attributedString.append(buttonTitleStr)
        //cell?.show.setAttributedTitle(attributedString, for: .normal)

        
        cell?.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        cell?.containerView.backgroundColor = .white
        
        cell?.txtLabel.text = posts[indexPath.row].text
        cell?.txtLabel.setLineSpacing(lineSpacing: 7)
        cell?.txtLabel.textAlignment = .center
        cell?.hitLabel.text = "\(posts[indexPath.row].hit!) 번 읽음"
        cell?.dateLabel.text = posts[indexPath.row].date
        cell?.nameLabel.text = posts[indexPath.row].name
        cell?.pidLabel.text = posts[indexPath.row].pid
        cell?.replyHitLabel.text = "\(posts[indexPath.row].reply!) 개 댓글"
        cell?.uidLabel.text = posts[indexPath.row].uid
        cell?.show.setTitle(posts[indexPath.row].show, for: UIControlState())
        cell?.likesLabel.text = posts[indexPath.row].blessCount
        if(posts[indexPath.row].blessCount == nil){
            cell?.likesLabel.text = "0"
        }else{
            cell?.likesLabel.text = "\(posts[indexPath.row].blessCount!)"
        }
        
        /*if(searchController.isActive && searchController.searchBar.text != ""){
         cell?.dateLabel.text = searchPosts[indexPath.row].date
         cell?.nameLabel.text = searchPosts[indexPath.row].name
         cell?.replyHitLabel.text = "\(searchPosts[indexPath.row].reply!) 개 댓글"
         cell?.pidLabel.text = searchPosts[indexPath.row].pid
         cell?.hitLabel.text = "\(searchPosts[indexPath.row].hit!) 번 읽음"
         cell?.txtLabel.text = searchPosts[indexPath.row].text
         cell?.uidLabel.text = searchPosts[indexPath.row].uid
         cell?.showOrNotButton.setTitle(searchPosts[indexPath.row].show, for: UIControlState())
         if(searchPosts[indexPath.row].blessCount == nil){
         cell?.likesLabel.text = "0 명"
         }else{
         cell?.likesLabel.text = "\(searchPosts[indexPath.row].blessCount!) 명"
         }
         
         }else{
         cell?.txtLabel.text = posts[indexPath.row].text
         cell?.hitLabel.text = "\(posts[indexPath.row].hit!) 번 읽음"
         cell?.dateLabel.text = posts[indexPath.row].date
         cell?.nameLabel.text = posts[indexPath.row].name
         cell?.pidLabel.text = posts[indexPath.row].pid
         cell?.replyHitLabel.text = "\(posts[indexPath.row].reply!) 개 댓글"
         cell?.uidLabel.text = posts[indexPath.row].uid
         cell?.showOrNotButton.setTitle(posts[indexPath.row].show, for: UIControlState())
         if(posts[indexPath.row].blessCount == nil){
         cell?.likesLabel.text = "0 명"
         }else{
         cell?.likesLabel.text = "\(posts[indexPath.row].blessCount!) 명"
         }
         
         }*/
        return cell!
    }
    
    var indexPath1: IndexPath?
    //셀을 클릭했을 때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("셀 클릭")
        
        //선택한 셀 정보 가져오기
        let cell = tableView.cellForRow(at: indexPath) as? MyPostCell
        indexPath1 = tableView.indexPath(for: cell!)
        //값 할당
        let name = cell?.nameLabel.text
        let text = cell?.txtLabel.text
        let hit = cell?.hitLabel.text
        let date = cell?.dateLabel.text
        let pid = cell?.pidLabel.text
        let replyHitLabel = cell?.replyHitLabel.text
        let uid = cell?.uidLabel.text
        let show = cell?.show.titleLabel?.text
        let blessCount = cell?.likesLabel.text
        //조회수 문자를 배열로 변경
        let xs = hit!.characters.split(separator:" ").map{ String($0) }
        let hitNum = Int(xs[0])! + 1
        
        //fb db 연결 후 posts 테이블에 key가 pid인 데이터의 hit 개수 변경해주기
        let hiting = ["hit" : hitNum]
        //여기가 문제
        let ref = Database.database().reference()
        ref.child("posts").child(pid!).updateChildValues(hiting)
        
        let xss = replyHitLabel!.characters.split(separator:" ").map{ String($0) }
        let replyNum = Int(xss[0])!
        
        let onePost = Post()
        onePost.name = name
        onePost.text = text
        onePost.hit = String(hitNum)
        onePost.date = date
        onePost.pid = pid
        onePost.reply = String(replyNum)
        onePost.uid = uid
        onePost.show = show
        onePost.blessCount = blessCount
        //디테일 페이지로 이동
        let detailTalkViewController = DetailTalkViewController()
        detailTalkViewController.onePost = onePost
        //글쓰기 화면을 rootView로 만들어 주기
        navigationController?.pushViewController(detailTalkViewController, animated: true)
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        if let aRow = indexPath1 {
    //             self.tableView.selectRow(at: aRow, animated: true, scrollPosition: .top)
    //        }
    //    }

    
    var selectedYear:Int?
    var selectedMonth:Int?
    var selectedDay:Int?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let aRow = indexPath1 {
            self.tableView.selectRow(at: aRow, animated: true, scrollPosition: .top)
        }
        
        if let year = self.selectedYear, let month = self.selectedMonth, let day = self.selectedDay{
           
            //print("오케 날짜 클릭하고 나의묵상 페이지 viewwill 에 왔어 \(year) \(month) \(day)")
            selectedPost(y: "\(year)", m: "\(month)", d: "\(day)")

        }
        
        selectedDay = nil
        selectedYear = nil
        selectedMonth = nil
        //self.tableView.reloadData()
    }
    //달력에서 선택된 날짜의 글 가져오기
    func selectedPost(y:String,m:String,d:String){
        var allCount = 0
        var showPostCount = 0
        let myId = Auth.auth().currentUser?.uid
        let myName = Auth.auth().currentUser?.displayName
        self.nameLable.text = "\(myName!)의 묵상"
        //print("start showPost")
        let ref = Database.database().reference()
        
        //user db에서 한줄 글 불러오기
        ref.child("users").child(myId!).observe(.value) { (snapt) in
            let childValue = snapt.value as! [String:Any] //자식의 value 값 가져오기
            if let myStateMsg = childValue["stateMsg"] as? String{
                self.introLable.text = myStateMsg
            }else{
                self.introLable.text = "좋아하는 말씀 또는 문장"
            }
            
        }
        ref.child("posts").queryOrdered(byChild: "date").observe(.value) { (snapshot) in
            self.posts.removeAll() //배열을 안지워 주면 계속 중복해서 쌓이게 된다.
            for child in snapshot.children{
                
                let postToShow = Post() //데이터를 담을 클래스
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                
                if let name = childValue["name"],  let date = childValue["date"], let hit = childValue["hit"], let pid = childValue["pid"], let uid = childValue["uid"], let text = childValue["text"], let reply = childValue["reply"], let show = childValue["show"]{
                    
                    //오늘 날짜에 작성된 글 개수 파악
                    let t = date as? TimeInterval
                    let todate = NSDate(timeIntervalSince1970: t!/1000)
                    let calendar = Calendar.current //켈린더 객체 생성
                    let year = calendar.component(.year, from: todate as Date)    //년
                    let month = calendar.component(.month, from: todate as Date)  //월
                    let day = calendar.component(.day, from: todate as Date)      //일
                    
                    
                    if(myId == String(describing: uid) && "\(year)\(month)\(day)" == "\(y)\(m)\(d)"){
                        ref.child("bless").observe(.value, with: { (snapshot) in
                            for (childs ) in snapshot.children{
                                let childSnapshot = childs as! DataSnapshot
                                let key = childSnapshot.key
                                let val = childSnapshot.value as! [String:Any]
                                //let val = childSnapshot.value(forKeyPath: key!)
                                //print(pid,key,val.count)
                                if (key == pid as? String) {
                                    postToShow.blessCount = "\(val.count)"
                                    //print("all Cnt 안\(allCount)")
                                }
                            }
                            self.tableView.reloadData()
                            
                        })
                        //firebase에서 가져온 날짜 데이터를 ios 맞게 변환
                        if let t = date as? TimeInterval {
                            let date = NSDate(timeIntervalSince1970: t/1000)
                            // print("---------------------\(NSDate(timeIntervalSince1970: t/1000))")
                            let dayTimePeriodFormatter = DateFormatter()
                            dayTimePeriodFormatter.dateFormat = "M월 d일 hh시"
                            let dateString = dayTimePeriodFormatter.string(from: date as Date)
                            postToShow.date = dateString
                        }
                        postToShow.name = name as! String
                        postToShow.hit = String(describing: hit)
                        postToShow.pid = pid as! String
                        postToShow.text = text as! String
                        postToShow.uid = uid as! String
                        postToShow.reply = String(describing: reply)
                        if(show as? String == "y"){
                            postToShow.show = "공개"
                            showPostCount = showPostCount + 1
                        }else{
                            postToShow.show = "비공개"
                        }
                        
                        allCount = allCount + 1
                        //print("all Cnt 밖\(allCount)")
                        self.posts.insert(postToShow, at: 0) //
                    }else{
                                //묵상날짜가 없으면 일단 여기..
                    }
                }
            }
            self.countLable.text = "총 \(allCount)편 / \(showPostCount)편 공개"
           // print("all Cnt 밖\(allCount)")
            
            if allCount == 0 {
                //self.posts.removeAll()
                self.tableView.reloadData()
            }
            
            allCount = 0
            showPostCount = 0

        }
        //tableView.reloadData()
        ref.removeAllObservers()
        
    }
    
    
    
    //포스트 조회 함수
    func showPost(){
        var allCount = 0
        var showPostCount = 0
        let myId = Auth.auth().currentUser?.uid
        let myName = Auth.auth().currentUser?.displayName
        self.nameLable.text = "\(myName!)의 묵상"
        //print("start showPost")
        let ref = Database.database().reference()
        
        //user db에서 한줄 글 불러오기
        
        ref.child("users").child(myId!).observe(.value) { (snapt) in
            let childValue = snapt.value as! [String:Any] //자식의 value 값 가져오기
            if let myStateMsg = childValue["stateMsg"] as? String{
                self.introLable.text = myStateMsg
            }else{
                self.introLable.text = "좋아하는 말씀 또는 문장"
            }
            
        }
        ref.child("posts").queryOrdered(byChild: "date").observe(.value) { (snapshot) in
            self.posts.removeAll() //배열을 안지워 주면 계속 중복해서 쌓이게 된다.
            for child in snapshot.children{
                
                let postToShow = Post() //데이터를 담을 클래스
                let childSnapshot = child as! DataSnapshot //자식 DataSnapshot 가져오기
                let childValue = childSnapshot.value as! [String:Any] //자식의 value 값 가져오기
                
                if let name = childValue["name"],  let date = childValue["date"], let hit = childValue["hit"], let pid = childValue["pid"], let uid = childValue["uid"], let text = childValue["text"], let reply = childValue["reply"], let show = childValue["show"]{
                    
                    if(myId == String(describing: uid)){
                        ref.child("bless").observe(.value, with: { (snapshot) in
                            
                            for (childs ) in snapshot.children{
                                
                                let childSnapshot = childs as! DataSnapshot
                                let key = childSnapshot.key
                                let val = childSnapshot.value as! [String:Any]
                                //let val = childSnapshot.value(forKeyPath: key!)
                                //print(pid,key,val.count)
                                if (key == pid as? String) {
                                    
                                   // print(pid,key,val.count)
                                    postToShow.blessCount = "\(val.count)"
                                    
                                }
                            }
                            self.tableView.reloadData()
                        })
                        //firebase에서 가져온 날짜 데이터를 ios 맞게 변환
                        if let t = date as? TimeInterval {
                            let date = NSDate(timeIntervalSince1970: t/1000)
                            // print("---------------------\(NSDate(timeIntervalSince1970: t/1000))")
                            let dayTimePeriodFormatter = DateFormatter()
                            dayTimePeriodFormatter.dateFormat = "M월 d일 hh시"
                            let dateString = dayTimePeriodFormatter.string(from: date as Date)
                            postToShow.date = dateString
                        }
                        postToShow.name = name as! String
                        postToShow.hit = String(describing: hit)
                        postToShow.pid = pid as! String
                        postToShow.text = text as! String
                        postToShow.uid = uid as! String
                        postToShow.reply = String(describing: reply)
                        if(show as? String == "y"){
                            postToShow.show = "공개"
                            showPostCount = showPostCount + 1
                        }else{
                            postToShow.show = "비공개"
                        }
                        allCount = allCount + 1
                        self.posts.insert(postToShow, at: 0) //
                    }
                }
            }
            self.countLable.text = "총 \(allCount)편 / \(showPostCount)편 공개"
            allCount = 0
            showPostCount = 0
        }
        ref.removeAllObservers()
        
    }
    
    //헤더뷰 레이아웃
    func setHeaderViewLayout(){
        headerView.addSubview(nameLable)
        nameLable.topAnchor.constraint(equalTo: headerView.topAnchor,constant:40).isActive = true
        nameLable.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant:15).isActive = true
        //todayPostsCountLable.widthAnchor.constraint(equalTo : headerView.widthAnchor).isActive = true
        //todayPostsCountLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        headerView.addSubview(introLable)
        introLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor,constant:10).isActive = true
        introLable.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant:15).isActive = true
        //introLable.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant:-35).isActive = true
        //introLable.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant:-35).isActive = true
        
        headerView.addSubview(countLable)
        countLable.topAnchor.constraint(equalTo: introLable.bottomAnchor,constant:35).isActive = true
        countLable.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant:-15).isActive = true
        //countLable.heightAnchor.constraint(equalToConstant: 15).isActive = true
        countLable.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant:-5).isActive = true
        
    }
}
