//
//  Header and Footer.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ScrollViewHeader: UIView, ReloadsWorkoutHeader, LayoutGuide {
    
    var infoDelegate: WorkoutHeaderInfo?   //using struct

    lazy var settingsButton = ButtonWithImage(type: .settings)
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.groupedTableText()
        return label
    }()
    
    public func setup(info: WorkoutHeaderInfo) {
        infoDelegate = info
        setupHeaderInfo()
        configureSettingsButton()
    }
        
    public func setupHeaderInfo() {
        
        guard let info = infoDelegate else { return }
        
        if let date = info.date {
            dateLabel.text = date.weekdayMonthDay
            centerInContainer(dateLabel)
        }
        
        //if let bodyweight = info.bodyweight {
            
        //}
        
        //if let notes = info.notes {
            
        //}
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lighterBlack()
        layer.cornerRadius = 3
    }
    
    @objc func btnTap() {
        infoDelegate?.showEditOptions()
    }
    
    func configureSettingsButton() {
        addSubview(settingsButton)
        settingsButton.tintColor = UIColor.brightTurquoise()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        settingsButton.addTarget(self, action: #selector(btnTap), for: .touchDown)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ScrollViewFooter: UIView, LayoutGuide  {
    
    var btnTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let button = UIButton()
        button.setTitle("Add Exercise", for: .normal)
        button.setTitleColor(UIColor.groupedTableText(), for: .normal)
        button.addTarget(self, action: #selector(btnTapped), for: .touchDown)
        centerInContainer(button)
        button.cornerRadius = 4
        backgroundColor = UIColor.lighterBlack()
        layer.cornerRadius = 3 
    }
    
    @objc func btnTapped() {
        btnTap?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("footer deinited")
    }
    
}





