//
//  SequenceUIHandler.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class SequenceUIHandler {
    
    enum UIAction {
        case rowBtnTap
        case rowBtnTapForRowWithSingleItem
        case rowSelected
        case headerBtnTap
        case footerBtnTap
    }
    
    public enum UIUpdate {
        case insertRow
        case editRow
        case reloadSection
        case deleteRow
        case deleteSelf
    }
    
    let collectionView: SequenceCollectionView
    
    let model: SequenceModel
    
    weak var delegate: WorkoutController?
    
    init(collectionView: SequenceCollectionView,
         model: SequenceModel,
         delegate: WorkoutController
        )
    {
        self.collectionView = collectionView
        self.model = model
        self.delegate = delegate
    }
    
    func handleUIAction(for UIAction: UIAction, at indexPath: IndexPath) {
        
        switch UIAction {
            
        case .headerBtnTap, .rowBtnTapForRowWithSingleItem, .rowBtnTap:
            createAlert(for: UIAction, at: indexPath)
            
        case .rowSelected:
            showExMetricEditor(for: indexPath, insertRow: false)
            
        case .footerBtnTap:
            showExMetricEditor(for: indexPath, insertRow: true)
        }
        
    }
    
    public func updateView(for update: UIUpdate, at indexPath: IndexPath) {
        
        model.update(with: update, at: indexPath)
        
        switch update {
            
        case .insertRow:
            collectionView.insertItems(at: [indexPath])
            
        case .editRow:
            collectionView.reloadItems(at: [indexPath])
            return
            
        case .reloadSection:
            let indexSet = NSIndexSet(index: indexPath.section) as IndexSet
            collectionView.reloadSections(indexSet)
            
        case .deleteRow:
            collectionView.deleteItems(at: [indexPath])
            
        case .deleteSelf:
            
            UIView.animate(withDuration: 0.4, animations: {
                
                [weak self] in
                guard self != nil else { return }
                self!.collectionView.removeFromSuperview()
                self!.delegate?.updateSuperview()
            })
            
        }
        
        collectionView.updateFrame()
        delegate?.updateSuperview()
        
    }
    

    func createAlert(for UIAction: UIAction, at indexPath: IndexPath) {
        
        let alert = UIAlertController()
        
        switch UIAction {
            
        case .headerBtnTap:
            
            alert.addAction(UIAlertAction(title: "Insert Section Above", style: .default) {
                [weak self] action in
                guard self != nil else { return }
                self!.delegate?.insertSequenceAlertAction(for: self!.collectionView)
            })
            
            if let masterInfoController = model.masterInfoController(for: indexPath) {
                
                alert.addAction(UIAlertAction(title: "Exercise Info", style: .default) {
                    [weak self] action in
                    self?.delegate?.segueToExerciseDetail(with: masterInfoController)
                })
                
                /*
                masterInfoController.infoControllers.forEach({
                    
                    controller in
                    
                    guard controller.displaysInAlertOptions else { return }
                    
                    alert.addAction(UIAlertAction(title: controller.alertTitle, style: .default) {
                        action in
                        
                        let keyWindowHeight = UIApplication.shared.keyWindow?.frame.height ?? 500
                        let alertController = UIAlertController()
                        
                        alertController.set(vc: controller.viewController, height: keyWindowHeight)
                        
                        if let reloadableView = controller.viewController as? ReloadableView {
                            reloadableView.loadModelOffTheMainQueueIfNeeded(spinnerFrame: controller.viewController.view.frame)
                        }
                        
                        alertController.addAction(UIAlertAction(title: "Return To Menu", style: .default) {
                            [weak self] action in
                            self?.createAlert(for: .headerBtnTap, at: indexPath)
                        })
                        
                        alertController.addDoneAction()
                        alertController.show()
                        
                    })
                })
                 */
                
                
                if let exerciseUpdateClass = masterInfoController as? UpdatesExercise {
                    addUpdateExerciseAction(exerciseUpdateClass: exerciseUpdateClass,
                                            alert: alert,
                                            indexPath: indexPath)
                }
            
            }
            
            alert.addAction(UIAlertAction(title: "Remove Section", style: .destructive) {
                [weak self] action in
                self?.updateView(for: .deleteSelf, at: indexPath)
            })
            
            
        case .rowBtnTap:
    
            alert.addAction(UIAlertAction(title: "Insert Row Above", style: .default, handler: {
                [weak self] action in
                self?.showExMetricEditor(for: indexPath, insertRow: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Remove Row", style: .destructive, handler: {
                [weak self] action in
                self?.updateView(for: .deleteRow, at: indexPath)
            }))
            
            
        case .rowBtnTapForRowWithSingleItem:
            
            alert.addAction(UIAlertAction(title: "Insert Row Above", style: .default, handler: {
                [weak self] action in
                self?.updateView(for: .insertRow, at: indexPath)
            }))
            
            alert.addAction(UIAlertAction(title: "Remove Section", style: .destructive, handler: {
                [weak self] action in
                self?.updateView(for: .deleteSelf, at: indexPath)
            }))
          
            
        default:
            break
            
        }
        
        alert.addCancelAction()
        alert.show()
    
    }
    
    
    func addUpdateExerciseAction(exerciseUpdateClass: UpdatesExercise, alert: UIAlertController, indexPath: IndexPath) {
            
            alert.addAction(UIAlertAction(title: exerciseUpdateClass.updateExerciseAlertTitle, style: .default) {
                
                [weak self] action in
                
                let tableViewController = exerciseUpdateClass.loadExerciseUpdateTableView() 
                
                //vc.reloadUIDelegate = self?.delegate
                
                tableViewController.tableView.reloadData()
                
                let navControl = UINavigationController(rootViewController: tableViewController)
                
                let userInfo = ["UINavigationController": navControl]
                
                tableViewController.updateWorkoutUIAfterSave = {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.updateUIHandler?.reloadWith(change:
                        .exerciseName(model: strongSelf.model, section: indexPath.section))
                }
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: showEditExerciseTableViewController), object: nil, userInfo: userInfo)
                
            })
        
    }
    
    
    func showExMetricEditor(for indexPath: IndexPath, insertRow: Bool) {
        
        if insertRow {
            updateView(for: .insertRow, at: indexPath)
        }
        
        let modelUpdater = model.getSequenceModelUpdater(for: indexPath)
        
        delegate?.showEditExerciseMetricView(with: modelUpdater, reloadHandler: {
            [weak self] in
            self?.updateView(for: .editRow, at: indexPath)
        })
        
    }

}


