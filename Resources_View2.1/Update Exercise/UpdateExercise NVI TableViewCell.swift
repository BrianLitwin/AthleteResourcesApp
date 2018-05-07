//
//  UpdateExercise NVI TableViewCell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class UpdateExerciseNVITableViewCell: BaseTableViewCell, UITextFieldDelegate {
    
    var saveText: ((String) -> Void)?
    
    static var reuseID = "NIVcell"
    
    lazy var textfield: UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor.brightTurquoise()
        tf.delegate = self
        tf.textColor = UIColor.groupedTableText()
        return tf
    }()
    
    let icon: UIImageView = {
        let image = #imageLiteral(resourceName: "create").withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: image)
        iv.tintColor = UIColor.groupedTableText()
        return iv
    }()
    
    override func setupViews() {
        addSubview(icon)
        addSubview(textfield)
        let layoutGuide = layoutMarginsGuide
        
        //configure icon
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //configure textfield
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textfield.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textfield.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -10).isActive = true
        
        
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        saveText?(textfield.text ?? "")
        textfield.resignFirstResponder()
        return true
    }
    
    func setTextfieldPlaceholder(_ text: String) {
        textfield.attributedPlaceholder = NSAttributedString(string: text, attributes:[NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    }
    
    deinit {
        print("textfielD De-inited")
    }
    
}
