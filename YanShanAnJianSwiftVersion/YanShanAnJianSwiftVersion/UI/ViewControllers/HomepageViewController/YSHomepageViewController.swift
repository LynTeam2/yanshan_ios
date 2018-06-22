//
//  YSHomepageViewController.swift
//  YanShanAnJianSwiftVersion
//
//  Created by 代健 on 2018/6/20.
//  Copyright © 2018年 jiandai. All rights reserved.
//

import UIKit

enum CollectionViewSection:Int {
    case collectionViewBannerSection = 0
    case collectionViewMenuSection   = 1
    case collectionViewClassSection  = 2
    case collectionViewNewsSection   = 3
}

private let kNumberOfSection:Int = 4

class YSHomepageViewController: YSBaseCollectionViewController,UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize.init(width: 100, height: 100)
        self.collectionView?.collectionViewLayout = flowLayout
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kNumberOfSection
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CollectionViewSection.collectionViewBannerSection.rawValue:
            return 2
        case CollectionViewSection.collectionViewMenuSection.rawValue:
            return 2
        case CollectionViewSection.collectionViewClassSection.rawValue:
            return 4
        case CollectionViewSection.collectionViewNewsSection.rawValue:
            return 4
        default:
            return 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case CollectionViewSection.collectionViewBannerSection.rawValue:
            return CGSize.init(width: collectionView.bounds.size.width, height: 195)
        case CollectionViewSection.collectionViewMenuSection.rawValue:
            return CGSize.init(width: collectionView.bounds.size.width, height: 125)
        case CollectionViewSection.collectionViewNewsSection.rawValue,
             CollectionViewSection.collectionViewClassSection.rawValue:
            return CGSize.init(width: collectionView.bounds.size.width, height: 54)
        default:
            return CGSize.zero
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        headerReusableView.backgroundColor = UIColor.blue
        return headerReusableView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
