//
//  CKMessagesCollectionViewLayout.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesCollectionViewLayout: UICollectionViewFlowLayout {

    
    // MARK: - Override
    override public class var layoutAttributesClass: Swift.AnyClass {
        return CKMessagesCollectionViewLayoutAttributes.self
    }
    
    override public class var invalidationContextClass: Swift.AnyClass {
        return CKMessagesCollectionViewLayoutInvalidationContext.self
    }
    
    override init() {
        super.init()
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override public func prepare() {
        super.prepare()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributesForElements = super.layoutAttributesForElements(in: rect) as? [CKMessagesCollectionViewLayoutAttributes] {
            
            attributesForElements.forEach { attributes in
                
                if attributes.representedElementCategory == .cell {
                    configure(attributes: attributes)
                }
                
            }
            
            return attributesForElements
            
        } else {
            return nil
        }
        
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? CKMessagesCollectionViewLayoutAttributes {
            if attributes.representedElementCategory == .cell {
                configure(attributes: attributes)
            }
            
            return attributes
        } else {
            return nil
        }
    }
    
    // MARK:- Public
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: 50)
    }
    
    
    
    // MARK:- Private
    private func configure() {
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        minimumLineSpacing = 5
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveApplicationMemoryWarningNotification(_:)),
                                               name: Notification.Name.UIApplicationDidReceiveMemoryWarning,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDeviceOrientationDidChangeNotification(_:)),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        
    }
    
    @objc private func didReceiveApplicationMemoryWarningNotification(_ notification: Notification) {
        
    }
    
    @objc private func didReceiveDeviceOrientationDidChangeNotification(_ notification: Notification) {
        invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
    }
    
    private func configure(attributes: CKMessagesCollectionViewLayoutAttributes) {
        
    }
    
    private var itemWidth: CGFloat {
        guard collectionView != nil else {
            return 0
        }
        
        return collectionView!.frame.width
            - collectionView!.contentInset.left - collectionView!.contentInset.right
            - sectionInset.left - sectionInset.right
    }
    
}
