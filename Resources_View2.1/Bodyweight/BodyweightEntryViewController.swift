//
//  BodyweightEntryViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol UpdatesBodyweight: SavesDate {
    var date: Date { get }
    var bodyweightValue: Double { get }
    func setBodyweight(value: Double)
    func deleteBWEntry()
    func readyToSave() -> Bool
    func save()
}

public class BodyweightEntryViewController: UIViewController, TextFieldCollectionViewModel, SavesDate, KeyboardDelegate {
    
    //todo: resign first responder on textfield when data picker shows up
    
    let textfieldCV = TextfieldCollectionView()
    let windowManager = WindowManager()
    let datePicker = DatePickerAlertController()
    var textFieldInfos: [TextFieldCollectionViewCellInfo] = []
    var model: UpdatesBodyweight?
    var reloadBodyweightView: (()-> Void)?
    
    lazy var cancelBtn: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTap))
    }()
    
    lazy var trashBtn: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBtnTap))
    }()
    
    lazy var doneBtn: UIBarButtonItem = {
       UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneBtnTap))
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        navigationController?.setDefaultColorScheme()
        navigationItem.rightBarButtonItem = doneBtn
        navigationItem.leftBarButtonItem?.tintColor = Colors.navbarBtnTint
        navigationItem.rightBarButtonItem?.tintColor = Colors.navbarBtnTint
        title = "Bodyweight Entry"
        
        view.addSubview(textfieldCV)
        textfieldCV.model = self
        textfieldCV.frame = view.bounds
        textfieldCV.backgroundColor = UIColor.clear 
    }

    @objc func doneBtnTap() {
        if let strongModel = model {
            if strongModel.readyToSave() {
                strongModel.save()
            }
        }
        dismiss(animated: true)
        reloadBodyweightView?()
    }
    
    @objc func trashBtnTap() {
        
        let ac = UIAlertController(title: "Delete Bodyweight Entry?", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.model?.deleteBWEntry()
            strongSelf.dismiss(animated: true)
            strongSelf.reloadBodyweightView?()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func cancelBtnTap() {
        dismiss(animated: true)
    }
    
    
    public func setModel(_ model: UpdatesBodyweight, editingPreviousBW: Bool) {
        self.model = model
        navigationItem.leftBarButtonItems = editingPreviousBW ? [cancelBtn, trashBtn] : [cancelBtn]
        setupViews()
    }
    
    func setupViews() {
        guard let model = self.model else { return }
        
        textFieldInfos = [
            TextFieldCollectionViewCellInfo(image: #imageLiteral(resourceName: "schedule"),
                                            headerText: "Date",
                                            onTap: showDatePicker,
                                            textFieldText: model.date.monthDayYear),
            
            TextFieldCollectionViewCellInfo(image: #imageLiteral(resourceName: "create"),
                                            headerText: "Bodyweight",
                                            onTap: showNumericKeyboard,
                                            textFieldText: String(model.bodyweightValue)),
        ]
        textfieldCV.reloadData()
    }
    
    func showDatePicker() {
        guard let model = self.model else { return }
        datePicker.configure(with: model.date, delegate: self)
        navigationController?.present(datePicker, animated: true)
    }
    
    public func save(date: Date) {
        //convoluted
        guard let model = self.model else { return }
        model.save(date: date)
        //reloads eveything
        setupViews()
    }
    
    func showNumericKeyboard() {
        windowManager.show(.standardKeyboard(keyboardDelegate: self))
        guard let cell = textfieldCV.cellForItem(at: [0, 1]) as? TextFieldCollectionViewCell else { return }
        activeTextField = cell.textField
    }
    
    //Mark: KeyboardDelegate methods
    
    public var activeTextField: UITextField?
    
    public func editTextField(editType: KeyboardButtonType) {
        guard let tf = activeTextField else { return }
        editType.editTextField(tf)
        guard let text = tf.text else { return }
        guard let value = Double(text) else { return }
        model?.setBodyweight(value: value)
    }
    
    public func resignLastResponder() {
        activeTextField?.resignFirstResponder()
    }
    
}







