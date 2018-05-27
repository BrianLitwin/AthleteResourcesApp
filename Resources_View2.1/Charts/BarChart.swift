//
//  BarChart.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

import CorePlot

//todolist: if you change a workout date and segue back to workout history, date won't be updated

class BarChart : UIView, CPTBarPlotDataSource {
    
    private var barGraph : CPTXYGraph? = nil
    var hostingView = CPTGraphHostingView()
    
    // margins in lbs over previous 1RM
    var graphData: [Double] = []
    
    var emptyView = emptyGraphView()
    
    func setupEmtpyView() {
        addSubview(emptyView)
        emptyView.setMessage("Chart Displays After First Week Of Training")
        emptyView.frame = self.bounds
    }
    
    // MARK: Initialization
    func setup(_ data: [Double])
    {
        
        //note sure why removing from superview doens't work
        emptyView.removeFromSuperview()
        
        self.graphData = data.reversed()
        
        //remove the first entry becuase it will always be zero (start on wk 2 and replace it with 0 because the graph seems to not show the first entry well (bug)
        self.graphData[0] = 0.0
        // Create graph from theme
        var tickerLocations: [Int] = []
        var tickerHeadings: [String] = []
        
        for i in 1..<graphData.count {
            tickerLocations.append(i)
            tickerHeadings.append("Wk \(i + 1)")
        }
        
        let newGraph = CPTXYGraph(frame: .zero)
        
        let xMin = 0.0
        let xMax = Double(graphData.count)
        
        let yMin = graphData.min(by: { $0 < $1 })!
        let maxYValue = graphData.max(by: { $0 < $1 })!
        let yMax = max(maxYValue, 10.0)
        
        
        guard let plotSpace = newGraph.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(location: xMin.NSNumber, length: (xMax - xMin).NSNumber)
        plotSpace.yRange = CPTPlotRange(location: yMin.NSNumber, length: (yMax - yMin).NSNumber)
        plotSpace.allowsUserInteraction = false
        
        addSubview(hostingView)
        addConstraintsWithFormat("H:|[v0]|", views: hostingView)
        addConstraintsWithFormat("V:|[v0]|", views: hostingView)
        hostingView.hostedGraph = newGraph
        
        if let frameLayer = newGraph.plotAreaFrame {
            // Border
            frameLayer.borderLineStyle = nil
            frameLayer.cornerRadius    = 0.0
            frameLayer.masksToBorder   = false
            
            // Paddings
            newGraph.paddingLeft   = 0.0
            newGraph.paddingRight  = 0.0
            newGraph.paddingTop    = 0.0
            newGraph.paddingBottom = 0.0
            
        }
        
        // Graph title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        newGraph.titleDisplacement        = CGPoint(x: 0.0, y:-20.0)
        newGraph.titlePlotAreaFrameAnchor = .top
        
        
        let axisSet = newGraph.axisSet as! CPTXYAxisSet
        
        if let x = axisSet.xAxis {
            x.axisLineStyle       = nil
            x.majorTickLineStyle  = nil
            x.minorTickLineStyle  = nil
            x.majorIntervalLength = 5.0
            x.orthogonalPosition  = 0.0
            
            // Custom labels
            x.labelRotation  = CGFloat(M_PI_4)
            x.labelingPolicy = .none
            
            let labelColor = CPTColor(cgColor: UIColor.white.cgColor)
            let textStyle = CPTMutableTextStyle()
            textStyle.color = labelColor
            
            let xAxisLineStyle = CPTMutableLineStyle()
            let px = 1 / UIScreen.main.scale
            xAxisLineStyle.lineWidth     = px
            xAxisLineStyle.lineColor = CPTColor(cgColor: UIColor.clear.cgColor)
            
            x.axisLineStyle = xAxisLineStyle
            
            let customTickLocations = tickerLocations
            let xAxisLabels         = tickerHeadings
            
            var labelLocation = 0
            var customLabels = Set<CPTAxisLabel>()
            for tickLocation in customTickLocations {
                
                labelLocation += 1
                
                let margin = graphData[labelLocation]
                let cushion: Double = 1.60
                var yPosition = margin > 0.00 ? (margin + cushion).NSNumber : cushion.NSNumber
                let xPosition = labelLocation.NSNumber
                let marginAnnotation = CPTPlotSpaceAnnotation(plotSpace: plotSpace, anchorPlotPoint: [xPosition, yPosition])
                let style = CPTMutableTextStyle()
                style.fontSize = 12.0
                style.fontName = "Helvetica"
                style.color = CPTColor(cgColor: UIColor.white.cgColor)
                let rounded = margin.rounded(toPlaces: 2).withDeltaSymbol
                let textLayer = CPTTextLayer(text: rounded, style: style)
                marginAnnotation.contentLayer = textLayer
                
                if let plotSpace = newGraph.plotAreaFrame {
                    plotSpace.addAnnotation(marginAnnotation)
                }
                
                if yMin < 0.00 {
                    
                    yPosition = (yMin * 1.5).NSNumber
                    let xAxisLabel = CPTPlotSpaceAnnotation(plotSpace: plotSpace, anchorPlotPoint: [xPosition, yPosition])
                    let style2 = CPTMutableTextStyle()
                    style2.fontSize = 12.0
                    style2.fontName = "Helvetica"
                    style2.color = CPTColor(cgColor: UIColor.white.cgColor)
                    let text = xAxisLabels[labelLocation - 1]
                    let textLayer2 = CPTTextLayer(text: text, style: style)
                    xAxisLabel.contentLayer = textLayer2
                    
                    if let plotSpace = newGraph.plotAreaFrame {
                        plotSpace.addAnnotation(xAxisLabel)
                    }
                    
                } else {
                    
                    let newLabel = CPTAxisLabel(text:xAxisLabels[labelLocation - 1], textStyle:textStyle )
                    newLabel.tickLocation = NSNumber.init(value: tickLocation)
                    newLabel.offset       = x.labelOffset + x.majorTickLength
                    customLabels.insert(newLabel)
                    
                }
                
                
            }
            
            x.axisLabels = customLabels
        }
        
        if let y = axisSet.yAxis {
            y.axisLineStyle       = nil
            y.majorTickLineStyle  = nil
            y.minorTickLineStyle  = nil
            y.orthogonalPosition  = 0.0
            y.labelFormatter = nil
        }
        
        // First bar plot
        
        let baseColor = Colors.BarChart.barTint
        let color = baseColor.withAlphaComponent(0.5).cgColor
        let fColor = baseColor.withAlphaComponent(0.15).cgColor
        let areaColor    = CPTColor.init(cgColor: color)
        let finalColor = CPTColor.init(cgColor: fColor)
        let areaGradient = CPTGradient(beginning: areaColor, ending: finalColor)
        areaGradient.angle = -90.0
        let areaGradientFill = CPTFill(gradient: areaGradient)
        
        let barPlot1        = CPTBarPlot.tubularBarPlot(with: areaColor, horizontalBars: false)
        barPlot1.fill = areaGradientFill
        barPlot1.baseValue  = 0
        barPlot1.lineStyle = nil
        barPlot1.dataSource = self
        newGraph.add(barPlot1, to:plotSpace)
        
        self.barGraph = newGraph
        
    }
    
    // MARK: - Plot Data Source Methods
    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        return UInt(graphData.count)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        
        switch CPTBarPlotField(rawValue: Int(field))! {
        case .barLocation:
            return record as NSNumber
            
        case .barTip:
            return graphData[Int(record)]
            
        default:
            return nil
        }
    }
}

