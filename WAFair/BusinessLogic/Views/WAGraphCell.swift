//
//  WAGraphCell.swift
//  WAFair
//
//  Created by Shudhanshu on 27/06/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import UIKit

class WAGraphCell: UICollectionViewCell {
    
    private let numberOfItems = 8
    @IBOutlet var graphView : ScrollableGraphView!
    @IBOutlet weak var segementControl : UISegmentedControl!
    
    var xAxisData = [Int]()
    var firstYAxisData = [Double]()
    var secondYAxisData = [Double]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.graphView.dataSource = self
        self.cellBackgroundGradient()
    }
    
    func cellUpdate(objects : [WeatherData]){
        self.setUpGraph(segementControl.selectedSegmentIndex, objects: objects)
    }
    
    func setUpGraph(_ index : Int , objects : [WeatherData]){
        switch index {
        case 0:
            let datas = WAUtility.sharedInstance.getFirstSegmentData(objects: objects)
            xAxisData = datas.X
            firstYAxisData = datas.YFirst
            secondYAxisData = datas.YSecond
            repeat{ xAxisData.append(0)}while xAxisData.count < numberOfItems
            repeat{ firstYAxisData.append(0.0)}while firstYAxisData.count < numberOfItems
            repeat{ secondYAxisData.append(0.0)}while secondYAxisData.count < numberOfItems
            setUpTempertaureGraph()
        case 1:
            let datas = WAUtility.sharedInstance.getSecondSegmentData(objects: objects)
            xAxisData = datas.X
            firstYAxisData = datas.YFirst
            repeat{ xAxisData.append(0)}while xAxisData.count < numberOfItems
            repeat{ firstYAxisData.append(0.0)}while firstYAxisData.count < numberOfItems
            setUpWindView()
        default:
            let datas = WAUtility.sharedInstance.getSecondSegmentData(objects: objects)
            xAxisData = datas.X
            firstYAxisData = datas.YFirst
            repeat{ xAxisData.append(0)}while xAxisData.count < numberOfItems
            repeat{ firstYAxisData.append(0.0)}while firstYAxisData.count < numberOfItems
            setUpHumidityView()
        }
        graphView.reload()
    }
}

extension WAGraphCell : ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch segementControl.selectedSegmentIndex{
        case 0:
            switch(plot.identifier) {
            case "one":
                return firstYAxisData[pointIndex]
            case "two":
                return secondYAxisData[pointIndex]
            default:
                return 0
            }
        case 1:
            switch(plot.identifier) {
            case "darkLine":
                return firstYAxisData[pointIndex]
            case "darkLineDot":
                return firstYAxisData[pointIndex]
            default:
                return 0
            }
        case 2:
            switch(plot.identifier) {
            case "Humidity":
                return firstYAxisData[pointIndex]
            case "HumidityDot":
                return firstYAxisData[pointIndex]
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(xAxisData[pointIndex])"
    }
    
    func numberOfPoints() -> Int {
        return numberOfItems
    }
    
    func setUpTempertaureGraph(){
        let blueLinePlot = LinePlot(identifier: "one")
        blueLinePlot.lineWidth = 3
        blueLinePlot.lineColor = UIColor(hex: "#16aafc") ?? .blue
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        blueLinePlot.shouldFill = false
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = (UIColor(hex: "#16aafc") ?? .blue).withAlphaComponent(0.5)
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let orangeLinePlot = LinePlot(identifier: "two")
        orangeLinePlot.lineWidth = 5
        orangeLinePlot.lineColor = UIColor.red
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        orangeLinePlot.shouldFill = false
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = UIColor.red.withAlphaComponent(0.5)
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.dataPointSpacing = 50

        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
    }
    
    func setUpWindView(){
        let linePlot = LinePlot(identifier: "darkLine")
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor(hex: "#777777") ?? .green
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor(hex: "#555555") ?? .lightGray
        linePlot.fillGradientEndColor = UIColor(hex: "#444444") ?? .lightGray

        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let dotPlot = DotPlot(identifier: "darkLineDot")
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.green

        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)


        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true

        graphView.dataPointSpacing = 50
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
    }
    
    func setUpHumidityView(){
        let linePlot = LinePlot(identifier: "Humidity")
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor(hex: "#777777") ?? .yellow
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor(hex: "#555555") ?? .lightGray
        linePlot.fillGradientEndColor = UIColor(hex: "#444444") ?? .lightGray

        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let dotPlot = DotPlot(identifier: "HumidityDot")
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.yellow

        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)

        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true

        graphView.dataPointSpacing = 50
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
    }
    
}
