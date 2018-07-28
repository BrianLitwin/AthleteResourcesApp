//
//  BodyweightTableViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

//TODO: click on bodyweight entry pops up bodyweight editing view
//TODO: Bodyweight chart position screws up after adding new bodyweight

public protocol BodyweightTableViewModel: ReloadableModel {
    var graphDataSource: ScatterPlotDataSource? { get }
    var bodyweightEntries: [BodyweightEntryData] { get }
    var minBW: BodyweightEntryData? { get }
    var maxBW: BodyweightEntryData? { get }
    func changeFrom(daysAgo: Int) -> Double
    func updatesBodyweightModel(for bodyweightIndex: Int) -> UpdatesBodyweight
    func newBodyweightModel() -> UpdatesBodyweight
}

public protocol BodyweightEntryData {
    var bodyweight: Double { get }
    var date: Date { get }
    var marginFromPrev: Double { get }
}


class HeaderForBodyweightTable: BaseView {
    
    var leftHandView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.BodyweightVC.headerTabBG
        view.layer.cornerRadius = 4
        return view
    }()
    
    var rightHandView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.BodyweightVC.headerTabBG
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    var leftHandLabel: UILabel = {
        let l = UILabel()
        l.textColor = Colors.BodyweightVC.headerTabSubtitle
        l.font = UIFont.systemFont(ofSize: 12.5)
        l.text = "Current"
        return l
    }()
    
    var rightHandLabel: UILabel = {
        let l = UILabel()
        l.textColor = Colors.BodyweightVC.headerTabSubtitle
        l.font = UIFont.systemFont(ofSize: 12.5)
        l.text = "Change"
        return l
    }()
    
    
    var currentBodyWeight: UILabel = {
        let l = UILabel()
        l.textColor = Colors.BodyweightVC.headerTabTitle
        l.font = UIFont.systemFont(ofSize: 28.5)
        return l
    }()
    
    
    var marginFromPrevious: UILabel = {
        let l = UILabel()
        l.textColor = Colors.BodyweightVC.headerTabTitle
        l.font = UIFont.systemFont(ofSize: 28.5)
        return l
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.clear
        
        addSubview(leftHandView)
        addSubview(rightHandView)
        
        leftHandView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        leftHandView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftHandView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        leftHandView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        leftHandView.addSubview(leftHandLabel)
        leftHandView.addSubview(currentBodyWeight)
        
        currentBodyWeight.translatesAutoresizingMaskIntoConstraints = false
        currentBodyWeight.topAnchor.constraint(equalTo: leftHandView.topAnchor, constant: 5).isActive = true
        currentBodyWeight.heightAnchor.constraint(equalToConstant: 29).isActive = true
        currentBodyWeight.centerXAnchor.constraint(equalTo: leftHandView.centerXAnchor).isActive = true
        
        leftHandLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHandLabel.topAnchor.constraint(equalTo: currentBodyWeight.bottomAnchor, constant: 0.5).isActive = true
        leftHandLabel.heightAnchor.constraint(equalToConstant: 14.5).isActive = true
        leftHandLabel.leadingAnchor.constraint(equalTo: currentBodyWeight.leadingAnchor).isActive = true
        
        rightHandView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        rightHandView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rightHandView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        rightHandView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        
        rightHandView.addSubview(marginFromPrevious)
        rightHandView.addSubview(rightHandLabel)
        
        marginFromPrevious.translatesAutoresizingMaskIntoConstraints = false
        marginFromPrevious.topAnchor.constraint(equalTo: rightHandView.topAnchor, constant: 5).isActive = true
        marginFromPrevious.heightAnchor.constraint(equalToConstant: 29).isActive = true
        marginFromPrevious.centerXAnchor.constraint(equalTo: rightHandView.centerXAnchor).isActive = true
        
        rightHandLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHandLabel.topAnchor.constraint(equalTo: marginFromPrevious.bottomAnchor, constant: 0.5).isActive = true
        rightHandLabel.heightAnchor.constraint(equalToConstant: 14.5).isActive = true
        rightHandLabel.trailingAnchor.constraint(equalTo: marginFromPrevious.trailingAnchor).isActive = true
        
    }
    
    func setup(bodyweight: Double, margin: Double) {
        currentBodyWeight.text = String(bodyweight)
        marginFromPrevious.text = margin.withDeltaSymbol
    }
    
}

