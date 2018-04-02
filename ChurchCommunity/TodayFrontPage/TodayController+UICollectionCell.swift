//
//  TodayController+UICollectionCell.swift
//  ChurchCommunity
//
//  Created by MacBookPro on 2018. 3. 27..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
extension TodayCollectionVC{

    //컬렉션 뷰의 셀 사이사이마다 간격설정 원래는 디폴드 값으로 10이 지정되어 있음
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //컬렉션 뷰의 cell 개수 지정.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    

    
    //컬렉션 뷰의 cell을 구성하는 함수
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //위에서 등록해준 커스텀 셀을 가져와서 리턴해줌
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        
        cell.delegate = self
        
        if(indexPath.item == 0){
            let page = pages[0]
            cell.itemCheck = 0
            cell.page = page
            cell.dateLable.text = todate + "주제"
             cell.pageLable.text = "1/3 page"
        }else if(indexPath.item == 1){
             let page = pages[1]
             cell.itemCheck = 1
            cell.page = page
            cell.dateLable.text = todate + "묵상"
           cell.pageLable.text = "2/3 page"
        }else if(indexPath.item == 2){
             let page = pages[2]
             cell.itemCheck = 2
            cell.page = page
            cell.dateLable.text = ""
            cell.pageLable.text = "3/3 page"
        }
        
        return cell
    }
    //커스텀 셀의 크기를 view에 꽉차게 해주었다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
