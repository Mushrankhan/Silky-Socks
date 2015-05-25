//
//  SJCollectionViewDelegate.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/16/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol SJCollectionViewDelegate: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressCameraButton button:UIButton)
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressTextButton button:UIButton)
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressColorWheelButton button:UIButton)
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressGridButton button:UIButton)
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressSmileyButton button:UIButton)

}