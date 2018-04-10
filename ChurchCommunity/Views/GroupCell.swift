//
//  TalkCell.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 13..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//


import UIKit

class GroupCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        //view.backgroundColor = .brown
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    //이름
     let groupTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "방제목"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 22.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
    }()
    
    let groupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "방장"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 13.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let groupCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1명,묵상중"
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 11.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
       
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 11.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let groupIdLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 11.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        //선택됐을 때 no hover
        selectionStyle = .none
        addSubview(containerView)
        setLayout()
    }
    
    
    func setLayout(){
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        
        containerView.addSubview(groupTitleLabel)
        containerView.addSubview(groupNameLabel)
        containerView.addSubview(groupCountLabel)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(groupIdLabel)

        groupTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 28).isActive = true
        groupTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
  
        groupCountLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 5).isActive = true
        groupCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor ,constant: -5).isActive = true
        groupCountLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        groupCountLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        groupNameLabel.topAnchor.constraint(equalTo: groupTitleLabel.bottomAnchor,constant: 35).isActive = true
        groupNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        groupNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        

       
        passwordLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        passwordLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        
        passwordLabel.trailingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        passwordLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


