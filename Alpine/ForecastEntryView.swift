//
//  ForecastEntryView.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

class ForecastEntryView: UIView {
    
    // MARK: Properties
    
    private var imageView: UIImageView!
    private var textLabel: UILabel!
    private var detailsLabel: UILabel!
    
    // MARK: Initializers
    
    init(icon: String, text: String, temperature: Int, chance: Int, color: UIColor) {
        super.init(frame: CGRectZero)
        
        tintColor = color
        
        imageView = UIImageView(image: UIImage(named: icon)?.imageWithRenderingMode(.AlwaysTemplate))
        imageView.tintColor = tintColor
        addSubview(imageView)
        
        textLabel = UILabel()
        textLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightMedium)
        textLabel.text = text
        textLabel.textColor = tintColor
        addSubview(textLabel)
        
        detailsLabel = UILabel()
        detailsLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightMedium)
        detailsLabel.text = "\(temperature)º | \(chance)%"
        detailsLabel.textColor = tintColor
        addSubview(detailsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.sizeToFit()
        detailsLabel.sizeToFit()
        
        imageView.frame = CGRectMake(14, 6, bounds.height - 12, bounds.height - 12)
        
        textLabel.frame = CGRectMake(imageView.frame.origin.x + imageView.bounds.width + 8, (bounds.height - textLabel.bounds.height) / 2, textLabel.bounds.width, textLabel.bounds.height)
        
        detailsLabel.frame = CGRectMake(bounds.width - detailsLabel.bounds.width - 4, (bounds.height - detailsLabel.bounds.height) / 2, detailsLabel.bounds.width, detailsLabel.bounds.height)
    }
}
