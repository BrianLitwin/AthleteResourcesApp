//
//  TableViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public protocol OneRepMaxTableViewModel: ReloadableModel {
    var numberOfWeeks: Int { get }
    var beginningEstOneRM: Double { get }
    var currentEstOneRM: Double { get }
    var totalImprovement: Double { get }
    var averageWeeklyImprovement: Double { get }
    var graphData: [Double] { get }
    var weeks: [OneRMWeek] { get }
}


public protocol OneRMWeek {
    var weekNumber: Int { get }
    var oneRMString: String? { get }
    var percentageChange: String? { get }
    var absoluteChange: Double? { get }
}


public class OneRMTableViewController: UITableViewController, ReloadableView {
    
    public var reloadableModel: ReloadableModel? {
        return model
    }
    
    let graphHeader = OneRMGraphHeader()
    
    let progressGraph = BarChart()
    
    let headerView = UIView()
    
    public var model: OneRepMaxTableViewModel?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultColorScheme()
        tableView.register(TableViewCellWithRightAndLeftLabel.self, forCellReuseIdentifier: TableViewCellWithRightAndLeftLabel.reuseID)
        tableView.register(OneRMWeekTableViewCell.self, forCellReuseIdentifier: OneRMWeekTableViewCell.reuseID)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 220)
        
        headerView.addSubview(graphHeader)
        headerView.addSubview(progressGraph)
        headerView.addConstraintsWithFormat("H:|[v0]|", views: graphHeader)
        headerView.addConstraintsWithFormat("H:|[v0]|", views: progressGraph)
        headerView.addConstraintsWithFormat("V:|[v0(55)]-20-[v1]-25-|", views: graphHeader, progressGraph)
        
    }

    public func reloadView() {
        
        if let model = self.model {
            if model.weeks.count > 1 {
                progressGraph.setup(model.graphData)
                tableView.reloadData()
                return
            }
        }
        
        progressGraph.setupEmtpyView()
        tableView.reloadData()
    }
    
    
    override public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.brightTurquoise()
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Summary"
        case 1: return "Weekly View"
        default: return ""
        }
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return model?.weeks.count ?? 0
        default:
            return 0
        }
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithRightAndLeftLabel.reuseID, for: indexPath) as!  TableViewCellWithRightAndLeftLabel
            
            guard let model = self.model else { return cell }
            
            cell.backgroundColor = UIColor.lighterBlack()
            cell.leftLabel.textColor = UIColor.groupedTableText()
            cell.rightLabel.textColor = UIColor.brightTurquoise()
            
            switch indexPath.row {
                
            case 0:
                cell.leftLabel.text = "Number Of Weeks"
                cell.rightLabel.text = String(model.numberOfWeeks)
                
            case 1:
                cell.leftLabel.text = "Beginning Est. 1RM"
                cell.rightLabel.text = String(model.beginningEstOneRM.rounded(toPlaces: 2))
                
            case 2:
                cell.leftLabel.text = "Current Est. 1RM"
                cell.rightLabel.text = String(model.currentEstOneRM.rounded(toPlaces: 2))
                
            case 3:
                cell.leftLabel.text = "Total Improvement"
                cell.rightLabel.text = String(model.totalImprovement.rounded(toPlaces: 2))
                
            case 4:
                cell.leftLabel.text = "Average Weekly Improvement"
                cell.rightLabel.text = String(model.averageWeeklyImprovement.rounded(toPlaces: 2))
                
            default:
                break
                
            }
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OneRMWeekTableViewCell.reuseID, for: indexPath) as! OneRMWeekTableViewCell
            
            cell.backgroundColor = UIColor.lighterBlack()
        
            guard let week = model?.weeks[indexPath.row] else { return cell }
        
            cell.titleLabel.text = "Wk " + String(week.weekNumber)
        
            cell.detailLabel.text = week.oneRMString ?? ""
            
            cell.metric1.text = week.percentageChange ?? "-"
            
            if let absoluteChange = week.absoluteChange?.rounded(toPlaces: 2) {
                
              cell.metric2.text =  String(absoluteChange)
                
            } else {
                
                cell.metric2.text = "-"
                
            }
        
            return cell
            
        }
    
    }

    
}




class OneRMWeekTableViewCell: BaseTableViewCell {
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(white: 1, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brightTurquoise()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
        return label
    }()
    
    static var reuseID = "OneRMExerciseMetricCell"
    
    var metric1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.groupedTableText()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var metric2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.brightTurquoise()
        return label
    }()
    
    override func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(metric1)
        contentView.addSubview(metric2)
        let marginGuide = contentView.layoutMarginsGuide
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20.5)
        
        detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 14.5)
        
        metric1.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        metric1.trailingAnchor.constraint(equalTo: metric2.trailingAnchor, constant: -65).isActive = true
        
        metric2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        metric2.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
    }
    
}

class OneRMGraphHeader: BaseView {
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "One Rep Max Progress"
        l.textAlignment = .center
        l.textColor = UIColor.groupedTableText()
        return l
    }()
    
    override func setupViews() {
        addSubview(label)
        addConstraintsWithFormat("H:|[v0]|", views: label)
        addConstraintsWithFormat("V:|[v0]|", views: label)
    }
}






