//
//  Window Manager.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/19/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class WindowManager {
    
    public init() { }
    
    public enum Popup {
        
        case sideBar(delegate: SideBarDelegate)
        
        case exercisePicker(view: ExercisePickerTableView, showTintScreen: Bool, addSwipeDownGestureRecognizer: Bool)
        
        case editExerciseMetric(updateModel: ModelUpdater, reloadHandler: () -> Void )
        
        case standardKeyboard(keyboardDelegate: KeyboardDelegate)
        
    }
    
    var currentView: WindowAnimation? {
        didSet {
            
        }
    }

    var keyWindow: UIWindow? {
        guard let keyWindow = UIApplication.shared.keyWindow else { return nil }
        return keyWindow
    }
    
    var keyWindowWidth: CGFloat {
        return keyWindow?.frame.width ?? 0
    }
    
    var keyWindowHeight: CGFloat {
        return keyWindow?.frame.height ?? 0
    }
    
    
    public func show(_ popup: Popup) {
        
        //Mark: always call display(animation:) so that the current view is resigned, instead of calling animation.display()
        
        switch popup {
            
        case .sideBar(delegate: let delegate):
            
            sidebar.masterVC = delegate
            let width = keyWindowWidth * 0.8
            let animation = WindowAnimation.fromRight(width: width, view: sidebar )
            display(animation)
            
        case .exercisePicker(let exercisePicker, let showTintScreen, let addSwipeDownGestureRecognizer):
            
            let animation = WindowAnimation.fromBottom(height: (keyWindowHeight * 0.6),
                                                       view: exercisePicker)
            
            if exercisePicker.model.needsReload {
                exercisePicker.model.loadModel()
            } else {
                exercisePicker.model.setAllSectionsToCollapsed()
            }
            
            exercisePicker.reloadData()
            
            if exercisePicker.model.collapsedSections.isEmpty { //no exercises
                exercisePicker.tableFooterView = ExercisePickerFooter(frame: CGRect(x: 0, y: 0, width: exercisePicker.frame.width, height: 90))
            } else {
                exercisePicker.tableFooterView = nil
            }
            
            
            //seems overkill
            
            exercisePicker.resignSelf = {
                [weak self] in
                self?.resignCurrentView()
                exercisePicker.resignSelf = nil
            }
            
            //
            //FIXME  
            
            if addSwipeDownGestureRecognizer {
                let gr = UISwipeGestureRecognizer(target: self, action: #selector(resignCurrentView))
                gr.direction = .down
                exercisePicker.addGestureRecognizer(gr)
            }
            
            
            display(animation, showTintScreen: showTintScreen)
        
        case .editExerciseMetric(let model, let reloadHandler):
            
            let tableView = ExerciseMetricEditingTableView(modelUpdater: model)
            let keyboardDelegate = EditExerciseMetricTextFieldManager(textFields: tableView.textFields)
            
            editExerciseMetricKeyboard.delegate = keyboardDelegate
            editExerciseMetricKeyboard.modelUpdater = model
            
            let keyboardHeight = keyWindowHeight * 0.4
            
            let view = EditExerciseMetricView(keyboard: editExerciseMetricKeyboard,
                                              tableView: tableView,
                                              width: keyWindowWidth,
                                              keyboardHeight: keyboardHeight)
            
            let animation = WindowAnimation.fromBottom(height: view.frame.height, view: view)
            
            editExerciseMetricKeyboard.doneBtnTap = {
                [weak self] in
                self?.editExerciseMetricKeyboard.delegate?.resignLastResponder()
                reloadHandler()
                self?.resignCurrentView()
                self?.editExerciseMetricKeyboard.doneBtnTap = nil
            }
            
            display(animation)
        
        case .standardKeyboard(let keyboardDelegate):
            
            standardKeyboard.delegate = keyboardDelegate
            
            standardKeyboard.doneBtnTap = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.standardKeyboard.delegate?.resignLastResponder()
                //reloadHandler
                strongSelf.resignCurrentView()
                strongSelf.editExerciseMetricKeyboard.doneBtnTap = nil
            }
            
            let animation = WindowAnimation.fromBottom(height: 250, view: standardKeyboard)
            display(animation)
            
        }
        
    }
    
    lazy var tintScreen: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.frame = keyWindow?.frame ?? .zero 
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignCurrentView)))
        return view
    }()
    
    private func display(_ animation: WindowAnimation, showTintScreen: Bool = true) {
        resignCurrentView()
        currentView = animation
        if showTintScreen {
            animation.display(with: tintScreen)
        } else {
            animation.display()
        }
    }
    
    @objc public func resignCurrentView() {
        tintScreen.removeFromSuperview()
        currentView?.resign(tintScreen: tintScreen)
        currentView = nil
    }
    
    //private func resignCurrentView(completion: @escaping () -> Void ) {
    //    currentView?.resign(completion: completion)
    //}
    
    lazy var sidebar: SideBar = {
        return SideBar(resignSelf: {
            [weak self] in self?.resignCurrentView() } )
    }()

    lazy var standardKeyboard: KeyboardView = {
        let keyBoard = KeyboardView()
        return keyBoard
    }()
    
    lazy var editExerciseMetricKeyboard: EditExerciseMetricKeyboard = {
        return EditExerciseMetricKeyboard()
    }()
    
}
