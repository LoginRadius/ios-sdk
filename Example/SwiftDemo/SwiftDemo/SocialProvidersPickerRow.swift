//
//  SocialProvidersPickerRow.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import UIKit
import Eureka


public final class SocialProvidersPickerCell : Cell<String>, CellType, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView : UICollectionView

    public var socialProviders : [SocialProvider] = []
    {
        didSet {
            collectionView.reloadData()
        }
    }

    private var dynamicConstraints = [NSLayoutConstraint]()
    private var notificationObserver : NSObjectProtocol?

    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 84, height: 84)
        layout.footerReferenceSize = CGSize(width: 0.0, height: 0.0)
        layout.headerReferenceSize = CGSize(width: 0.0, height: 0.0)
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SocialProviderIconCell.self, forCellWithReuseIdentifier: "SocialProviderIconCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let notificationObserver = notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
    }
    
    public override func update() {
        super.update()
    }
    
    public override func setup() {
        super.setup()

        selectionStyle = .none
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = backgroundColor
        contentView.addSubview(collectionView)
        
        setNeedsUpdateConstraints()
        
        notificationObserver = NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification,
                                                                      object: nil,
                                                                      queue: nil,
                                                                      using: { [weak self] (note) in
                                                                        self?.setNeedsUpdateConstraints()
        })
    }
    
    public override func updateConstraints(){
        customConstraints()
        super.updateConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = contentView.frame
        frame.origin.x = -15
        frame.size.width += 30
        contentView.frame = frame
    }
    
    public func customConstraints() {
        let views : [String: AnyObject] = ["collectionView": collectionView]

        contentView.removeConstraints(dynamicConstraints)

        dynamicConstraints = []
        dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView(84)]|", options: [], metrics: nil, views: views))
        dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[collectionView]-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(dynamicConstraints)
    }

    public func indexPath(forSocialProvider name : String?) -> IndexPath? {
        if let name = name {
            var row = 0
            for p in socialProviders {
                if(p.name == name)
                {
                    return IndexPath(row: row, section: 0)
                }
                row += 1
            }
        }
        
        return nil
    }

    
    //  UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let spName = socialProviders[indexPath.row].name
        baseRow.baseValue = spName
        baseRow.didSelect()
    }

    //  UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return socialProviders.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialProviderIconCell", for: indexPath) as! SocialProviderIconCell

        cell.imageView.image = socialProviders[indexPath.row].icon
        return cell
    }
}

// MARK: SocialProvidersPickerRow

open class _SocialProvidersPickerRow: Row<SocialProvidersPickerCell> {

    override open func updateCell() {
        cell.height = { return CGFloat(85) }
    }
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public final class SocialProvidersPickerRow: _SocialProvidersPickerRow, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
