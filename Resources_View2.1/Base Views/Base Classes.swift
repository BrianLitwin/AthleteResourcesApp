//
//  Base Classes.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, LayoutGuide {
    
    var headerText: String =  "" {
        didSet {
            headerLabel.text = headerText
        }
    }
    
    var headerLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                itemSelected()
            } else {
                itemDeselected()
            }
        }
    }
    
    func itemSelected() {
        
    }
    
    func itemDeselected() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension UINavigationController {
    
    func setDefaultColorScheme() {
        
        navigationBar.tintColor = UIColor.groupedTableText()
        navigationBar.barTintColor = UIColor.lighterBlack()
        navigationBar.isTranslucent = false
        
    }
    
}



open class BaseView: UIView, LayoutGuide {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BaseCollectionReusableView: UICollectionReusableView, LayoutGuide {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView, LayoutGuide {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}













