//
//  Header and Footer.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

//Todo: don't need to pass in anything but date here

public class ScrollViewHeader: UIView, ReloadsWorkoutHeader, LayoutGuide {
    
    var infoDelegate: WorkoutHeaderInfo?   //using struct
    lazy var settingsButton = ButtonWithImage(type: .settings)
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.CurrentWorkout.dateLabel
        return label
    }()
    
    public func setup(info: WorkoutHeaderInfo) {
        infoDelegate = info
        setupHeaderInfo()
        //configureSettingsButton()
    }
        
    public func setupHeaderInfo() {
        
        guard let info = infoDelegate else { return }
        
        if let date = info.date {
            dateLabel.text = date.weekdayMonthDay
        }
        
        //if let bodyweight = info.bodyweight {
            
        //}
        
        //if let notes = info.notes {
            
        //}
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.CurrentWorkout.workoutHeaderBg
        layer.cornerRadius = 3
        
        //configure right pane
        let rightIconPane = ViewRightPane(image: .expandMore,
                                          backgroundColor: Colors.CurrentWorkout.addExerciseBg,
                                          imageTintColor: .white,
                                          borderColor: .white,
                                          tapAction: { [weak self] in self?.btnTap() }
        )
        rightIconPane.addToRightPane(superview: self)
        
        //configure date label
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: rightIconPane.leadingAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dateLabel.textAlignment = .center
    }
    
    @objc func btnTap() {
        infoDelegate?.showEditOptions()
    }
    
    func configureSettingsButton() {
        addSubview(settingsButton)
        settingsButton.tintColor = Colors.CurrentWorkout.editDateIcon
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
        
        //add image in right corner
        
        let rightIconPane = ViewRightPane(image: .add,
                                          backgroundColor: Colors.CurrentWorkout.addExerciseBg,
                                          imageTintColor: .white,
                                          borderColor: .white,
                                          tapAction: { [weak self] in self?.btnTapped() }
        )
        rightIconPane.addToRightPane(superview: self)
        
        
        //add label
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnTapped)))
        let label = UILabel()
        label.text = "Add Exercise"
        label.textAlignment = .center
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: rightIconPane.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true 
        label.textColor = .white
        
        //adding an extra gesture recognizer so that you can tap anywhere and pull up the add exercise list
        let gr2 = UITapGestureRecognizer(target: self, action: #selector(btnTapped))
        addGestureRecognizer(gr2)
        backgroundColor = Colors.CurrentWorkout.addExerciseBg
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


