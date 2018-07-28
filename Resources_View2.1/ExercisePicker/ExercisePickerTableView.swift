//
//  Alerts.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

protocol ExercisePicker {
    var insertHandler: ((IndexPath) -> Void)? { get set }
}

public class ExercisePickerTableView: TableWithDropDownHeaders, ExercisePicker, Resignable {
    
    public typealias modelType = TableWithDropDownHeaders.modelType
    public var insertHandler: ((IndexPath) -> Void)?
    @objc public var resignSelf: (() -> Void)?

    public init(model: modelType) {
        //Mark: initialize the dropDownTableView
        super.init(model: model)
        register(ExerciseCell.self, forCellReuseIdentifier: ExerciseCell.reuseID)
        register(ExercisePickerHeader.self,
                 forHeaderFooterViewReuseIdentifier: ExercisePickerHeader.reuseID)
        
        //configure table header
        let tableHeader = TableHeader(frame: CGRect(x: 0, y: 0, width: frame.width, height: 44))
        tableHeaderView = tableHeader
        tableHeader.dismiss = { [weak self] in self?.resignSelf?() }
    }

    @objc func swipeDown() {
        resignSelf?()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        insertHandler?(indexPath)
        resignSelf?()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {

    }
} 


private class TableHeader: BaseView {
    var dismiss: (()->Void)?
    
    private lazy var gr = {
        return UITapGestureRecognizer(target: self, action: #selector(self.tapped))
    }()
    
    let dismissLabel = UILabel()
    
    override func setupViews() {
        super.setupViews()
        
        //configure label
        let label = dismissLabel
        addSubview(label)
        label.text = "DISMISS"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.textColor = Colors.ExercisePicker.dismiss
        label.addCharSpace(value: 0.5)
        
        //configure icon
        let image = #imageLiteral(resourceName: "arrow-thin-down").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true

        //configure gesture recognizer
        addGestureRecognizer(gr)
    }
    
    //could do this with hit target too 
    @objc func tapped() {
        let validXCoord = frame.width - dismissLabel.frame.width - 60
        let location = gr.location(in: self)
        if validXCoord < location.x {
            dismiss?()
        }
    }
}




