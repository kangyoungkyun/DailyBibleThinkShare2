//
//  GroupPost.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 4. 10..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

class GroupPost: UITableViewController {
    
    var groupInfo: GroupInfo?{
        didSet{
            print(groupInfo?.groupid,groupInfo?.groupname)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        //넘어온 그룹키를 비교해서
        //그룹키에 해당하는 글들 다가져옴
    }


}
