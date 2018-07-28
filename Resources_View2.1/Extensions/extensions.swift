//
//  extensions.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



class ButtonWithImage: UIButton {
    
    enum ButtonImage {
        
        case more
        case settings
        case add
        case expandMore
        
        var image: UIImage {
            switch self {
            case .more:
                return #imageLiteral(resourceName: "more").withRenderingMode(.alwaysTemplate)
            case .settings:
                return #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate)
            case .add:
                return #imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate)
            case .expandMore:
                return #imageLiteral(resourceName: "expand_more").withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    init(type: ButtonImage) {
        super.init(frame: .zero)
        setImage(type.image, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension UIButton {
    
    var title: String {
        get { return self.title }
        set { setTitle(newValue, for: .normal) }
    }
    
    var image: UIImage {
        get { return self.image }
        set { setImage(newValue.template() , for: .normal) }
    }
    
}

extension UILabel {
    
    func shrinkTextToFit() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        numberOfLines = 1
    }
    
    func addCharSpace(value: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(NSAttributedStringKey.kern,
                                      value: value,
                                      range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}


extension UIImage {
    func template() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UIImageView {
    
    func enabled() -> UIImageView {
        self.isUserInteractionEnabled = true
        return self
    }
    
}

extension UIView {
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    func setBorder(color: UIColor = UIColor.black, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}


extension UIStackView {
    
    func addArrangedSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
    
}






