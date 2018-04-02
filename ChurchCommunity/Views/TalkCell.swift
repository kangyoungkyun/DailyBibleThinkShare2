//
//  TalkCell.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 13..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

import UIKit

class TalkCell: UITableViewCell {
    
    let containerView: UIView = {
      let view = UIView()
      //view.backgroundColor = .brown
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.2
      view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    //버튼
    let showOrNotButton: UIButton = {
        let starButton = UIButton(type: .system)
        //starButton.setTitle("비공개", for: UIControlState())
        starButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        starButton.tintColor = UIColor.lightGray
        starButton.translatesAutoresizingMaskIntoConstraints = false
         starButton.isHidden = true
        return starButton
    }()
    
    
    //버튼
    let seeImage: UIButton = {

        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "ic_remove_red_eye.png"), for: .normal)
         starButton.isHidden = true
        //starButton.frame = CGRect(x:0,y:0,width:15,height:15)
        starButton.tintColor = UIColor.lightGray
        starButton.translatesAutoresizingMaskIntoConstraints = false
        return starButton
    }()
    

        //버튼
        let replyImage: UIButton = {
            
            let starButton = UIButton(type: .system)
            starButton.isHidden = true
            //starButton.setImage(#imageLiteral(resourceName: "ic_comment.png"), for: .normal)
            starButton.tintColor = UIColor.lightGray
            starButton.translatesAutoresizingMaskIntoConstraints = false
            return starButton
        }()
        

            //버튼
            let likeButton: UIButton = {
                let starButton = UIButton(type: .system)
                starButton.setImage(#imageLiteral(resourceName: "ic_favorite.png"), for: .normal)
                starButton.tintColor = .red
                starButton.isHidden = true
                starButton.translatesAutoresizingMaskIntoConstraints = false
                return starButton
            }()
            
    //likes
    var likesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //uid
    var uidLabel: UILabel = {
        let label = UILabel()
        label.text = "uid"
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //pid
    var pidLabel: UILabel = {
        let label = UILabel()
        label.text = "pid"
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //이름
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
         label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 12.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    

    
    //텍스트
    var txtLabel: UILabel = {
        let label = UILabel()
        
        label.setLineSpacing(lineSpacing: 18.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NanumMyeongjo-YetHangul", size: 13.5)

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
        label.isEnabled = true
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //댓글 수
    
    var replyHitLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "15 댓글"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        containerView.addSubview(uidLabel)
        containerView.addSubview(pidLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(txtLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(hitLabel)

        
        
        containerView.addSubview(seeImage)
        containerView.addSubview(likeButton)
        containerView.addSubview(likesLabel)

        
        
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 35).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        //dateLabel.trailingAnchor.constraint(equalTo: txtLabel.trailingAnchor).isActive = true
        //dateLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        txtLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 35).isActive = true
        txtLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        txtLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        txtLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -95).isActive = true
        
        
        nameLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 35).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        
        pidLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 5).isActive = true
        pidLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 5).isActive = true
        pidLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        pidLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        uidLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 5).isActive = true
        uidLabel.leadingAnchor.constraint(equalTo: pidLabel.trailingAnchor, constant: 5).isActive = true
        uidLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        uidLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
