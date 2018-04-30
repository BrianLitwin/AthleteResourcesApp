//
//  EMOM.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/8/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


//add button being enabled doesn't work
/*

class EMOMCollectionView: BaseCollectionView,  CalculateCollectionViewFrame {
    
    let container: EM_Containers
    
    init(container: EM_Containers) {
        self.container = container
        super.init()
        registerCell(DefaultWorkoutCell.self)
        registerHeader(SectionHeader.self)
        registerFooter(EMOMFooter.self)
        reloadData()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! DefaultWorkoutCell
        cell.headerText = displayString
        cell.backgroundColor = UIColor.red
        cell.headerLabel.textColor = UIColor.yellow
        cell.centerLeft(cell.headerLabel)
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension EMOMCollectionView {
    
    //MARK: Setup Header and Footer
    //
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath as IndexPath) as! SectionHeader
            
            //headerView.sectionAlert = self
            return headerView
            
            
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerID, for: indexPath as IndexPath) as! EMOMFooter
            
            //footerView.appendRow = self
            return footerView
            
            
        default:
            
            //assert(false, "Unexpected element kind")
            let cell = UICollectionViewCell()
            return cell
            
        }
        
    }
    
}


class EMOMFooter: BaseCVReusableView {
    
    var addSameWeight: (() -> Void)?
    var addNewWeight: (() -> Void)?
    
    var addSameWeightBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var addNewWeightBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    override func setupViews() {
        
        pinToEdges(horizontalStackView, withMargin: 8)
        horizontalStackView.addArrangedSubviews(addSameWeightBtn, addNewWeightBtn)
        addSameWeightBtn.addTarget(self, action: #selector(btnTap(sender:)), for: .touchDown)
        addSameWeightBtn.addTarget(self, action: #selector(btnTap(sender:)), for: .touchDown)
    }
    
    @objc func btnTap(sender: UIButton) {
        
        if sender == addSameWeightBtn {
            addSameWeight?()
        }
        
        if sender == addNewWeightBtn {
            addNewWeight?()
        }
        
    }
    
}






class EMOMBuilderTableView: UITableViewController {
    
    class PendingSequenceInfo {
        
        var exercise: Exercises?    = nil
        var startingWeight: Double? = nil
        var startingReps: Double?    = nil
        var presetRounds: Int       = 1
        
        var readyToCreateNewSequence: Bool {
            return (exercise != nil) && (startingWeight != nil) && (startingReps != nil)
        }
        
    }
    
    var pendingSequenceInfo = PendingSequenceInfo()
    
    let windowManager: WindowManager
    
    lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(AddButtonTap ) )
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPopover ) )
    }()
    
    init(style: UITableViewStyle, windowManager: WindowManager, addToWorkout: @escaping (PendingSequenceInfo) -> Void ) {
        
        self.windowManager = windowManager
        self.addToWorkout = addToWorkout
        
        super.init(style: .grouped)
        
        title = "Setup EMOM"
        tableView.register(EMOMCell.self, forCellReuseIdentifier: EMOMCell.reuseId)
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func viewDidLoad() {
        addButton.isEnabled = false
    }
    
    let addToWorkout: (PendingSequenceInfo) -> Void
    
    @objc func AddButtonTap() {
        addToWorkout(pendingSequenceInfo)
        windowManager.resignCurrentView()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelPopover() {
        
        navigationController?.dismiss(animated: true)
        windowManager.resignCurrentView()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 5
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EMOMCell.reuseId) as! EMOMCell
        
        switch indexPath.row {
            
        case 0:
            cell.cellTap = showExercisePicker(for: cell)
            cell.textLabel?.text = "Choose Exercise"
            
        case 1:
            cell.textLabel?.text = "Starting Weight: "
            cell.cellTap = displayOrSetKeyboardDelegate(for: cell)
            cell.saveValue = saveValue(textField: cell.textField,
                                       saveFunc: { [weak self] value in self?.pendingSequenceInfo.startingWeight = value })
            
        case 2:
            cell.textLabel?.text = "Starting Reps: "
            cell.cellTap = displayOrSetKeyboardDelegate(for: cell)
            cell.saveValue = saveValue(textField: cell.textField,
                                       saveFunc: { [weak self] value in self?.pendingSequenceInfo.startingReps = value })
            
        case 3:
            cell.textLabel?.text = "Preset Rounds: "
            cell.textField.text = "1"
            cell.cellTap = displayOrSetKeyboardDelegate(for: cell)
            cell.saveValue = saveValue(textField: cell.textField,
                                       saveFunc: { [weak self] value in self?.pendingSequenceInfo.presetRounds = Int(value) })
            
        default: break
            
        }
        
        return cell
        
    }
    
    func showExercisePicker(for cell: UITableViewCell) -> () -> Void {
        
        func show() {
        
            func exerciseSelected(exercise: Exercises) {
                cell.textLabel?.text = exercise.name ?? ""
                cell.detailTextLabel?.text = exercise.variation ?? ""
                pendingSequenceInfo.exercise = exercise
                addButton.isEnabled = pendingSequenceInfo.readyToCreateNewSequence
            }
            
           windowManager.show(.exercisePicker( handler: exerciseSelected ))
            
        }
            
        return show
    }
    
    func displayOrSetKeyboardDelegate(for cell: EMOMCell) -> () -> Void {
        
        func presentPicker() {
            windowManager.show(.defaultKeyboard(cell) )
        }
        
        return presentPicker
    }
    
    func saveValue(textField: UITextField, saveFunc: @escaping (Double) -> Void ) -> () -> Void {
        
        func save() {
            
            guard let text = textField.text else { return }
            guard let value = Double(text) else { return }
            saveFunc(value)
            
            addButton.isEnabled = pendingSequenceInfo.readyToCreateNewSequence
            
        }
        
        return save
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EMOMCell: SubtitleTableViewCell, InputDelegate, UITextFieldDelegate, LayoutGuide {
    
    var cellTap:      ( () -> Void )?
    var saveValue:    ( () -> Void )?
    var textField = UITextField()
    
    static let reuseId = "ChooseExerciseCell"
    
    override func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecognizer)))
        textField.delegate = self
        textField.setBorder()
        centerRight(textField)
        textField.widthConstraint = 75
    }
    
    @objc func tapRecognizer() {
        textField.becomeFirstResponder()
        cellTap?()
    }
    
    func editTextField(editType: KeyboardButtonType) {
        editType.editTextField(textField)
        saveValue?()
    }
    
    func resignLastResponder() {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cellTap?()
        return true
    }
    
    
}


/*







 */*/
