//
//  UpdateExercise TableViewCells.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class UpdateExerciseMetricTableViewCell: BaseTableViewCell {
    
    static var reuseID = "metricCell"
    
    weak var delegate: UpdateExerciseModelSection? {
        didSet {
            
            guard let sectionModel = delegate else { return }
            setupMetricSwitch()
            setupSegmentedControl(with: sectionModel.unitOptions.map({$0.symbol}))
            label.text = sectionModel.metricName
            setupAllViews()
            
        }
    }
    
    var segmentedControl: UISegmentedControl?
    
    var metricSwitch: UISwitch?
    
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func setupAllViews() {
        
        //configure label
        addSubview(label)
        centerLeft(label)
        
        //configure switch
        guard let mSwitch = metricSwitch else { return }
        addSubview(mSwitch)
        centerRight(mSwitch)
        
        //configure segmentedControl
        guard let segmControl = segmentedControl else { return }
        addSubview(segmControl)
        segmControl.translatesAutoresizingMaskIntoConstraints = false
        segmControl.trailingAnchor.constraint(equalTo: mSwitch.leadingAnchor, constant: -15).isActive = true
        segmControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        let width = CGFloat(segmentedControl!.numberOfSegments * 55) 
        segmControl.widthAnchor.constraint(equalToConstant: width).isActive = true
        
    }
    
    func setupSegmentedControl(with items: [String]) {
        guard items.count > 1 else { return } //don't display segmented control for reps and sets
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl?.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
        setSegmentedControlSelectedIndex()
    }
    
    func setupMetricSwitch() {
        metricSwitch = UISwitch()
        metricSwitch?.tintColor = UIColor.brightTurquoise()
        metricSwitch?.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        metricSwitch?.isOn = delegate?.selectedUnitIndex != nil
    }
    
    func setSegmentedControlSelectedIndex() {
        
        guard metricSwitch?.isOn == true else {
            segmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
            return
        }
        
        if let selectedIndex = delegate?.selectedUnitIndex {
            segmentedControl?.selectedSegmentIndex = selectedIndex
        }
        
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        delegate?.metricIs(active: sender.isOn)
        setSegmentedControlSelectedIndex()
    }
    
    @objc func segmentedControlTapped(_ sender: UISegmentedControl) {
        delegate?.unitSelectionChanged(to: sender.selectedSegmentIndex)
    }
    
    
}
