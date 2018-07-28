//
//  BodyweightViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

//TODO: Setup empty layout
//toggling doesn't work exactly right 

public class BodyweightViewController: DefaultTableViewController, ReloadableView {
    lazy var graphView = ScatterPlotView()
    public var model: BodyweightTableViewModel?
    let tableHeader = UIView()
    let graphHeader = HeaderForBodyweightTable()
    let emptyGraphHeader = UIView()
    var userIsInPopoverView = false
    
    public var reloadableModel: ReloadableModel? {
        return model 
    }
    
    lazy var bodyweightEntryVC: BodyweightEntryViewController = {
       return BodyweightEntryViewController()
    }()
    
    lazy var popupNavController: UINavigationController = {
        return UINavigationController(rootViewController: bodyweightEntryVC)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bodyweightEntryVC.reloadBodyweightView = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadModelOffTheMainQueueIfNeeded(spinnerFrame: strongSelf.view.frame)
        }
        
        tableView.register(BodyweightTVCell.self, forCellReuseIdentifier: BodyweightTVCell.reuseID)
        tableView.register(TableViewCellWithRightAndLeftLabel.self, forCellReuseIdentifier: TableViewCellWithRightAndLeftLabel.reuseID)
        tableView.tableHeaderView = tableHeader
        tableHeader.backgroundColor = .white
        tableHeader.addSubview(graphHeader)
        tableHeader.addSubview(graphView)
        
        //for some reason there is extra space above the graph..
        tableHeader.frame = CGRect(x: view.frame.minX, y: -30, width: view.frame.width, height: 140)
        graphHeader.frame = CGRect(x: tableHeader.frame.minX, y: tableHeader.frame.minY, width: view.frame.width, height: 65)
        graphView.frame = CGRect(x: tableHeader.frame.minX, y: 40, width: view.frame.width, height: 100)
        setupGraph()
        view.backgroundColor = UIColor.white
        
        
        //add divider to tableHeader
        let divider = UIView()
        view.addSubview(divider)
        divider.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        divider.frame = CGRect(x: 0,
                               y: 175, //this is a touchy value
                               width: view.frame.width,
                               height: 1/UIScreen.main.scale)
    }
    
    func setupGraph() {
        
        guard let model = self.model else {
            setupEmptyGraphView()
            return
        }
        
        guard let currentBodyweight = model.bodyweightEntries.first else {
            setupEmptyGraphView()
            return
        }
        
        guard let graphDataSource = model.graphDataSource else {
            setupEmptyGraphView()
            return
        }
        
        graphHeader.isHidden = false
        graphView.setup(dataSource: graphDataSource)
        graphHeader.setup(bodyweight: currentBodyweight.bodyweight, margin: currentBodyweight.marginFromPrev)
    }
    
    func setupEmptyGraphView() {
        graphView.setupEmptyGraph(message: "Bodyweight Chart Displays After Two Entries")
        graphHeader.isHidden = true
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGraph()
        let plusImage = #imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate)
        let leftBarBtn = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addBtnTap))
        self.navigationController?.navigationItem.leftBarButtonItem = leftBarBtn
        leftBarBtn.tintColor = Colors.BodyweightVC.addBtn
    }
    
    @objc func addBtnTap() {
        guard let newBodyweightModel = model?.newBodyweightModel() else { return }
        bodyweightEntryVC.setModel(newBodyweightModel, editingPreviousBW: false)
        show(popupNavController, sender: self)
        showPopover()
    }
    
    func showUpdateBodyweightView(for indexPath: IndexPath) {
        guard let previousBodyweightModelModel = model?.updatesBodyweightModel(for: indexPath.row) else { return }
        bodyweightEntryVC.setModel(previousBodyweightModelModel, editingPreviousBW: true)
        showPopover()
    }
    
    func showPopover() {
        userIsInPopoverView = true
        show(popupNavController, sender: self)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if userIsInPopoverView {
            userIsInPopoverView = false
        } else {
            self.navigationController?.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Change Over Time"
        case 1: return "History"
        default: return ""
        }
    }
    
    override   public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return model?.bodyweightEntries.count ?? 0
        default: return 0
        }
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dataModel = model else { return UITableViewCell() }
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithRightAndLeftLabel.reuseID, for: indexPath) as! TableViewCellWithRightAndLeftLabel
            setCellBackground(cell)
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none

            switch indexPath.row {
            case 0:
                cell.leftLabel.text = "Change From Seven Days Ago"
                cell.rightLabel.text = dataModel.changeFrom(daysAgo: 7).withDeltaSymbol
                return cell
                
            case 1:
                cell.leftLabel.text = "Change From Thirty Days Ago"
                cell.rightLabel.text = dataModel.changeFrom(daysAgo: 30).withDeltaSymbol
                return cell
                
            case 2:
                cell.leftLabel.text = "Min Bodyweight"
                let minBodyweight = dataModel.minBW?.bodyweight ?? 0.00
                cell.rightLabel.text = String(minBodyweight)
                return cell
                
            case 3:
                cell.leftLabel.text = "Max Bodyweight"
                let maxBodyweight = dataModel.maxBW?.bodyweight ?? 0.00
                cell.rightLabel.text = String(maxBodyweight)
                return cell
                
            default: break
                
            }
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BodyweightTVCell.reuseID, for: indexPath) as! BodyweightTVCell
            setCellBackground(cell)
            cell.isUserInteractionEnabled = true
            cell.selectionStyle = .gray
            
            let item = dataModel.bodyweightEntries[indexPath.row]
            
            cell.bodyweight.text = String(item.bodyweight)
            cell.wChange.text = item.marginFromPrev.withDeltaSymbol
            cell.date.text = item.date.monthDay
            
            return cell
            
        default: break
            
            
        }
        
        return UITableViewCell()
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showUpdateBodyweightView(for: indexPath)
    }
}
