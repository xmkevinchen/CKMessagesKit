//
//  CKMessagesIndicatorFooterView.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/4/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

public class CKMessagesIndicatorFooterView: UICollectionReusableView, NibReusable {

    @IBOutlet weak var indicator: CKMessagesIndicatorView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        let indicator = CKMessagesIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicator)
        
        indicator.addConstraint(NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        indicator.addConstraint(NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        self.indicator = indicator
        indicator.startAnimation()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        indicator.startAnimation()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
