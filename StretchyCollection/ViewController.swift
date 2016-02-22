//
//  ViewController.swift
//  StretchyCollection
//
//  Created by Ryan Poolos on 1/19/16.
//  Copyright © 2016 Frozen Fire Studios, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Stretchy Header"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(collectionView)
        
        let views = ["collectionView": collectionView]
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionLayout.itemSize = CGSize(width: size.width - (padding * 2.0), height: 64.0)
    }
    
    //==========================================================================
    // MARK: - UICollectionViewDataSource
    //==========================================================================
    
    private let cellIdentifier = "UniqueCellIdentifier"
    private let headerIdentifier = "UniqueHeaderIdentifier"
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! StretchyHeaderView
        view.imageView.image = UIImage(named: "Photo")
        return view
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    let padding: CGFloat = 8.0
    
    lazy var collectionLayout: StretchyCollectionViewLayout = { [unowned self] in
        let layout = StretchyCollectionViewLayout()
        layout.itemSpacing = self.padding
        layout.itemSize = CGSize(width: self.view.bounds.width - (self.padding * 2.0), height: 64.0)
        layout.sectionInset = UIEdgeInsets(top: self.padding, left: self.padding, bottom: 32.0, right: self.padding)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.lightGrayColor()
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        collectionView.registerClass(StretchyHeaderView.self, forSupplementaryViewOfKind: StretchyCollectionHeaderKind, withReuseIdentifier: self.headerIdentifier)
        
        return collectionView
    }()
}

