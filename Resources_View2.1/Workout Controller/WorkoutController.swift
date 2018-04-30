//
//  WorkoutController.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol WorkoutController: class {

    var windowManager: WindowManager { get }
    
    var scrollView: ScrollView { get }
    
    var exercisePicker: ExercisePickerTableView { get }
    
    var updateUIHandler: ReloadsWorkoutUI? { get }
    
    func insertSequence(withSelection: IndexPath, at sectionNumber: Int)
    
    func segueToExerciseDetail(with exerciseInfo: MasterInfoController)
    
}

extension WorkoutController {
    
    func showEditExerciseMetricView(with updateModel: ModelUpdater,
                                    reloadHandler: @escaping () -> Void )
    {
        windowManager.show(.editExerciseMetric(updateModel: updateModel,
                                               reloadHandler: reloadHandler))
        
    }
    
    func configureScrollViewFooterButton() {
        scrollView.footer.btnTap = {
            [weak self] in
            guard let lastViewIndex = self?.scrollView.contentView.subviews.count else { return }
            self?.showExercisePicker(for: lastViewIndex)
        }
    }
    
    func updateSuperview() {
        scrollView.updateFrames()
    }
    
    func insertSequenceAlertAction(for subview: UIView) {
        guard let viewIndex = scrollView.contentView.subviews.index(of: subview) else { return }
        showExercisePicker(for: viewIndex)
    }
    
    public func addSequenceToView(at section: Int, with model: SequenceModel) {
        
        let sequenceCollectionView = SequenceCollectionView(model: model,
                                                            workoutController: self)
            
        scrollView.insertView(sequenceCollectionView, at: section)
        sequenceCollectionView.updateFrame()
        scrollView.updateFrames()
        
    }

    func insertSequenceAlertAction(at sequenceNumber: Int) -> UIAlertAction {
        
        return UIAlertAction(title: "Insert Sequence Above", style: .default, handler: { [weak self] action in
            
            self?.showExercisePicker(for: sequenceNumber)
            
        })
        
    }

    
    public func showExercisePicker(for sequenceNumber: Int) {
        
        let insertHandlder: (IndexPath) -> Void
            = {
            [weak self] indexPath  in
            self?.insertSequence(withSelection: indexPath, at: sequenceNumber)
        }
        
        exercisePicker.insertHandler = insertHandlder
        
        windowManager.show(.exercisePicker(view: exercisePicker,
                                           showTintScreen: true,
                                           addSwipeDownGestureRecognizer: true))
        
    }

}











