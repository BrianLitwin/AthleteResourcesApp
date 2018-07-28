//
//  FloatingDBView.swift
//  Resources2.1
//
//  Created by B_Litwin on 7/26/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class FloatingDumbellView: UIView {
    let imageView = UIImageView()
    let messageLabel = UILabel()
    let shadow = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = #imageLiteral(resourceName: "dumbell").withRenderingMode(.alwaysTemplate)
        messageLabel.text = "New Workout!"
        
        imageView.image = image
        imageView.tintColor = UIColor.black.withAlphaComponent(0.65)
        imageView.backgroundColor = .clear
        addSubview(imageView)
        
        //set emomjie's constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        shadow.fillColor = UIColor(white: 0, alpha: 0.05).cgColor
        layer.addSublayer(shadow)
        
        messageLabel.textAlignment = .center
        messageLabel.backgroundColor = .clear
        //messageLabel.font = Styles.Text.body.preferredFont
        
        //could implement this
        messageLabel.textColor = UIColor.black.withAlphaComponent(0.2)
        
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25).isActive = true
        resetAnimations()
        
        // CAAnimations will be removed from layers on background. restore when foregrounding.
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(resetAnimations),
                         name: .UIApplicationWillEnterForeground,
                         object: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat = 30
        let height: CGFloat = 12
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        shadow.path = UIBezierPath(ovalIn: rect).cgPath
        
        let bounds = self.bounds
        shadow.bounds = rect
        shadow.position = CGPoint(
            x: bounds.width/2,
            y: bounds.height/2 + 40
        )
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        resetAnimations()
    }
    
    
    // MARK: Private API
    
    @objc private func resetAnimations() {
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let duration: TimeInterval = 1
        
        let emojiBounce = CABasicAnimation(keyPath: "transform.translation.y")
        emojiBounce.toValue = -10
        emojiBounce.repeatCount = .greatestFiniteMagnitude
        emojiBounce.autoreverses = true
        emojiBounce.duration = duration
        emojiBounce.timingFunction = timingFunction
        
        imageView.layer.add(emojiBounce, forKey: "nonewnotificationscell.emoji")
        
        let shadowScale = CABasicAnimation(keyPath: "transform.scale")
        shadowScale.toValue = 0.9
        shadowScale.repeatCount = .greatestFiniteMagnitude
        shadowScale.autoreverses = true
        shadowScale.duration = duration
        shadowScale.timingFunction = timingFunction
        
        shadow.add(shadowScale, forKey: "nonewnotificationscell.shadow")
    }
}
