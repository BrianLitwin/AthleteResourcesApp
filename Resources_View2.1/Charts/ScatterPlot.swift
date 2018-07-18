//
//  ScatterPlot.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CorePlot



public protocol ScatterPlotDataSource {
    var data: [ScatterPlotDataItem] { get }
    var maxY: Double { get }
    var minY: Double { get }
    var maxX: Double { get }
    var minX: Double { get }
    var minDate: Date { get }
}

public protocol ScatterPlotDataItem {
    var value: Double { get }
    var date: Date { get }
}



class ScatterPlotView: UIView, CPTScatterPlotDataSource, CPTAxisDelegate {
    
    private var scatterGraph : CPTXYGraph? = nil
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()
    
    
    
    // MARK: Initialization
    var contentArray = [plotDataType]()
    var graph = CPTXYGraph(frame: .zero)
    var hostingView = CPTGraphHostingView()
    
    var graphData: [Double] = []
    
    var emptyView = emptyGraphView()
    
    func setupEmptyGraph(message: String) {
        setupAlternateView(message: message)
    }
    
    func setup(dataSource: ScatterPlotDataSource) {
        
        emptyView.removeFromSuperview()
        graphData = []
        contentArray = [plotDataType]()
        graph.removeFromSuperlayer()
        graph = CPTXYGraph(frame: .zero)
        
        addSubview(hostingView)
        addConstraintsWithFormat("H:|[v0]|", views: hostingView)
        addConstraintsWithFormat("V:|[v0]|", views: hostingView)
        hostingView.hostedGraph = graph
        
        for data in dataSource.data {
            let x = Date.daysBetween(startDate: dataSource.minDate, endDate: data.date)
            let y = data.value
            let dataPoint: plotDataType = [.X: x, .Y: y]
            contentArray.append(dataPoint)
        }
        
        
        // Create graph from theme
        //graph.apply(CPTTheme(named: .darkGradientTheme))
        
        // Paddings
        graph.paddingLeft   = 0
        graph.paddingRight  = 0
        graph.paddingTop    = 0
        graph.paddingBottom = 0
        
        graph.plotAreaFrame?.masksToBorder = true
        
        // Plot space
        
        let xMin = 0.0
        let xMax = dataSource.maxX
        let yMin = dataSource.minY
        let yMax = dataSource.maxY 
        
        
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(location: xMin.NSNumber, length: (xMax - xMin).NSNumber)
        plotSpace.yRange = CPTPlotRange(location: yMin.NSNumber, length: (yMax - yMin).NSNumber)
        plotSpace.allowsUserInteraction = false
        
        // Axes
        let axisSet = graph.axisSet as! CPTXYAxisSet
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 1
            x.orthogonalPosition    = yMin.NSNumber
            x.labelingPolicy = .fixedInterval
            
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength   = 50
            y.orthogonalPosition    = 0
            y.minorTickLength = 50
            y.labelingPolicy = .fixedInterval
            y.delegate = self
        }
        
        // Create a colored plot area
        let dataSourceLinePlot = CPTScatterPlot(frame: .zero)
        let greenLineStyle               = CPTMutableLineStyle()
        greenLineStyle.lineWidth         = 1.0
        greenLineStyle.lineColor         = CPTColor.init(cgColor: Colors.ScatterPlot.primaryColor.withAlphaComponent(0.75).cgColor)
        //greenLineStyle.dashPattern       = [5.0, 5.0]
        dataSourceLinePlot.dataLineStyle = greenLineStyle
        dataSourceLinePlot.identifier    = NSString.init(string: "Green Plot")
        dataSourceLinePlot.dataSource    = self
        
        // Put an area gradient under the plot above
        //let color = Colors.ScatterPlot.primaryColor.withAlphaComponent(0.25).cgColor
        //let fColor = Colors.ScatterPlot.primaryColor.withAlphaComponent(0.01).cgColor
        let color = Colors.ScatterPlot.primaryColor.withAlphaComponent(0.55).cgColor
        let fColor = Colors.ScatterPlot.primaryColor.withAlphaComponent(0.25).cgColor
        let areaColor    = CPTColor.init(cgColor: color)
        let finalColor = CPTColor.init(cgColor: fColor)
        let areaGradient = CPTGradient(beginning: areaColor, ending: finalColor)
        areaGradient.angle = -90.0
        let areaGradientFill = CPTFill(gradient: areaGradient)
        dataSourceLinePlot.areaFill      = areaGradientFill
        
        dataSourceLinePlot.areaBaseValue = (yMin * 0.995).NSNumber
        
        // Animate in the new plot, as an example
        dataSourceLinePlot.opacity = 0.0
        graph.add(dataSourceLinePlot)

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.duration            = 1.0
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.fillMode            = kCAFillModeForwards
        fadeInAnimation.toValue             = 1.0
        dataSourceLinePlot.add(fadeInAnimation, forKey: "animateOpacity")
        
        // Add some initial data
        
        self.dataForPlot = contentArray
        
        self.scatterGraph = graph
        
    }
    
    // MARK: - Plot Data Source Methods
    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        return UInt(self.dataForPlot.count)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        let plotField = CPTScatterPlotField(rawValue: Int(field))
        
        if let num = self.dataForPlot[Int(record)][plotField!] {
            let plotID = plot.identifier as! String
            if (plotField! == .Y) && (plotID == "Green Plot") {
                return (num + 1.0) as NSNumber
            }
            else {
                return num as NSNumber
            }
        }
        else {
            return nil
        }
    }
    
    
    // MARK: - Axis Delegate Methods
    private func axis(_ axis: CPTAxis, shouldUpdateAxisLabelsAtLocations locations: NSSet!) -> Bool
    {
        return false
        if let formatter = axis.labelFormatter {
            let labelOffset = axis.labelOffset
            
            var newLabels = Set<CPTAxisLabel>()
            
            if let labelTextStyle = axis.labelTextStyle?.mutableCopy() as? CPTMutableTextStyle {
                for location in locations {
                    if let tickLocation = location as? NSNumber {
                        if tickLocation.doubleValue >= 0.0 {
                            labelTextStyle.color = .green()
                        }
                        else {
                            labelTextStyle.color = .red()
                        }
                        
                        let labelString   = formatter.string(for:tickLocation)
                        let newLabelLayer = CPTTextLayer(text: labelString, style: labelTextStyle)
                        
                        let newLabel = CPTAxisLabel(contentLayer: newLabelLayer)
                        newLabel.tickLocation = tickLocation
                        newLabel.offset       = labelOffset
                        
                        newLabels.insert(newLabel)
                    }
                }
                
                axis.axisLabels = newLabels
            }
        }
        
        return false
    }
    
    func setupAlternateView(message: String) {
        addSubview(emptyView)
        emptyView.setMessage(message)
        emptyView.frame = self.bounds
    }
    
}

class emptyGraphView: BaseView {
    
    //FIX ME: get better image
    
    let imageView: UIImageView = {
        let image = #imageLiteral(resourceName: "chart").withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: image)
        iv.tintColor = UIColor.darkGray
        return iv
    }()
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.darkGray
        l.font = UIFont.systemFont(ofSize: 11)
        l.textAlignment = .center
        return l
    }()
    
    
    override func setupViews() {
        
        addSubview(imageView)
        addSubview(label)
        
        let x = UIScreen.main.bounds.width
        imageView.frame = CGRect(x: (x - 25) / 2,
                                 y: 21,
                                 width: 25,
                                 height: 25)
        
        label.frame = CGRect(x: (x - 300) / 2,
                             y: 46,
                             width: 300,
                             height: 25)
        
        
    }
    
    func setMessage(_ message: String) {
        label.text = message
    }

}

extension Int {
    var NSNumber: NSNumber {
        return self as NSNumber
    }
}



extension Double {
    var NSNumber: NSNumber {
        return self as NSNumber
    }
}
