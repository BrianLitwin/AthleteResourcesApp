//
//  RightPaneView.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 7/26/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class ViewRightPane: UIView {
    var btnTap: (()->Void)?
    var button: RightPaneButton?
    
    enum PaneImage {
        case add
        case settings
        case more
        case expandMore
        
        var image: UIImage {
            let image: UIImage
            switch self {
            case.add: image = #imageLiteral(resourceName: "add")
            case .settings: image = #imageLiteral(resourceName: "settings")
            case .more: image = #imageLiteral(resourceName: "more")
            case .expandMore: image = #imageLiteral(resourceName: "expand_more")
            }
            return image.withRenderingMode(.alwaysTemplate)
        }
        
        var imageView: UIImageView {
            return UIImageView(image: image)
        }
    }
    
    enum Size {
        case normal
        case small
        
        func format(btn: UIButton, superview: UIView) {
            switch self {
            case .normal:
                btn.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -10).isActive = true
                btn.widthAnchor.constraint(equalTo: superview.heightAnchor, constant: -10).isActive = true
                
            case .small:
                btn.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -16).isActive = true
                btn.widthAnchor.constraint(equalTo: superview.heightAnchor, constant: -16).isActive = true
            }
        }
    }
    
    convenience init(image: PaneImage, tapAction: @escaping ()->Void ) {
        //Mark: This is meant as the default in the main collection views
        self.init(image: image,
                  backgroundColor: .clear,
                  imageTintColor: UIColor.black.withAlphaComponent(0.25),
                  borderColor: .clear,
                  tapAction: tapAction
        )
    }
    
    init(image: PaneImage,
         backgroundColor: UIColor,
         imageTintColor: UIColor,
         borderColor: UIColor,
         size: ViewRightPane.Size = .small,
         tapAction: @escaping ()->Void
        )
    {
        super.init(frame: .zero)
        
        //configure btn
        let button = RightPaneButton(color: imageTintColor)
        addSubview(button)
        button.setImage(image.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        size.format(btn: button, superview: self)
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        self.btnTap = tapAction
        self.button = button
        
        //add left border
        let border = UIView()
        addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.alpha = 0.7
        border.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5).isActive = true
        border.widthAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        border.backgroundColor = borderColor
        
        self.backgroundColor = backgroundColor
    }

    func addToRightPane(superview: UIView) {
        superview.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        widthAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
    }
    
    @objc func btnTapped() {
        print("btn tapped called")
        btnTap?()
    }
    
    public func expandHitTarget(by amount: CGFloat = -25) {
        button?.extraYHitTarget = amount
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RightPaneButton: UIButton {
    var extraYHitTarget: CGFloat = 0
    let defColor: UIColor
    
    init(color: UIColor) {
        defColor = color
        super.init(frame: .zero)
        tintColor = color
    }
    
    override var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? UIColor.black.withAlphaComponent(0.5) : defColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


