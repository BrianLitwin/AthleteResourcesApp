//
//  TextFieldCVCell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class TextFieldCollectionViewCell: BaseCollectionViewCell, UITextFieldDelegate {
    
    var onTap: (()->Void)?
    
    static var reuseID = "Cell"

    var label: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.white
        return iv
    }()
    
    
    var textField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.white
        //tf.backgroundColor = UIColor.lighterBlack()
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.cornerRadius = 2
        tf.layer.borderWidth = 1
        //tf.tintColor = UIColor.brightTurquoise()
        return tf
    }()
    
    func setup(with textLabelIcon: UIImage?, headerText: String?, textFieldText: String?) {
        
        if let tfIcon = textLabelIcon {
            icon.image = tfIcon.withRenderingMode(.alwaysTemplate)
        }
        
        if let text = headerText {
            label.text = text
        }
        
        if let tfText = textFieldText {
            textField.text = tfText
        }
        
        textField.delegate = self
        textField.inputView = UIView()
        
        addSubview(label)
        addSubview(textField)
        addSubview(icon)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: textField)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: label)
        addConstraintsWithFormat("V:|[v0]-8-[v1(35)]|", views: label, textField)

        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: textField.rightAnchor, constant: -5).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        textField.addGestureRecognizer(gr)
        self.addGestureRecognizer(gr)
        
    }
    
    @objc func cellTapped() {
        onTap?()
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                textField.becomeFirstResponder()
                //textField.layer.borderColor = UIColor.brightTurquoise().cgColor
            } else {
                
                textField.layer.borderColor = UIColor.darkGray.cgColor
                textField.resignFirstResponder()
                
            }
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        onTap?()
        
        //textField.layer.borderColor = UIColor.brightTurquoise().cgColor
        //modelDelegate.setSelectedTextFieldIndex(index: index)
        //collectionViewDelegate.selectCell()
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.darkGray.cgColor
        
        //if let string = textField.text {
            //modelDelegate.saveValue(string, index: index)
        //}
        
    }
    
}







