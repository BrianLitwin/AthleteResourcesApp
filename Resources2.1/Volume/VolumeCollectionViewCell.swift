//
//  VolumeCollectionViewCell.swift
//  Resources2.1
//
//  Created by B_Litwin on 8/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import IGListKit



class VolumeMetricCollectionViewCell: UICollectionViewCell, ListBindable {
    static var reuseID = "volumeMetricCell"
    let leftLabel = UILabel()
    var labels = [UILabel]()
    var count: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.numberOfLines = 2
        
        backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? VolumeSectionViewModel else { return }
        if count == nil {
            let valueCount = viewModel.values.count
            count = valueCount
            
            for _ in 0..<valueCount {
                let label = UILabel()
                labels.append(label)
            }
            
            formatColumns(with: [leftLabel] + labels, count: valueCount, superview: contentView)
        }
        
        leftLabel.text = viewModel.title
        
        for (index, label) in labels.enumerated() {
            label.text = viewModel.values[index].displayString()
        }
    }
}


private func formatColumns(with labels: [UILabel], count: Int, superview: UIView) {
    let columnWidth = superview.frame.width / CGFloat(count + 1)
    
    for index in 0..<labels.count {
        let label = labels[index]
        label.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(label)
        
        label.widthAnchor.constraint(equalToConstant: columnWidth).isActive = true
        label.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        
        if index == 0 {
            label.textAlignment = .left
            label.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        } else {
            label.textAlignment = .center
            label.leadingAnchor.constraint(equalTo: labels[index - 1].trailingAnchor).isActive = true
        }
    }
}

