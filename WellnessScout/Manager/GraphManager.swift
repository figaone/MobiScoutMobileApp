//
//  GraphManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/24/21.
//

import Foundation
import Charts
import CoreMotion


class GraphManager {
    
    //MARK:Used to manage the graph for the data
    
    
    //MARK: Managers
    let sensorManager = SensorManager()
    
    //MARK: Local Variables
    
    
    //MARK: Used to create the graph
    func updateGraphData(lineChartView : LineChartView, graphData : [Double], manger : CMMotionManager){
        var chartEntry = [ChartDataEntry]()
        //confirm that we have data
        if graphData.count > 0 {
        //loop thru the values
        for i in 0..<graphData.count {
            //create the value
            let value = ChartDataEntry(x: Double(i), y: graphData[i] ?? 0)
            //append the data here
            chartEntry.append(value)
        }
        //set the dataset and label it
        let lineChartData = LineChartDataSet(entries: chartEntry, label: "Heart Rate")
        //set the colors for the first graph
            lineChartData.colors = [UIColor.red]
        lineChartData.circleRadius = 0
        lineChartData.drawValuesEnabled = false
        //chart data
        let data = LineChartData()
        //add the data set
        data.addDataSet(lineChartData)
        //add the data to the view
        lineChartView.data = data
        //attributes
        lineChartView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        lineChartView.data?.setValueTextColor(NSUIColor.white)
        //remove the labels and legends
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = true
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.minOffset = 0
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawZeroLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.isUserInteractionEnabled = false
        //limit the amount of x and y labels
        lineChartView.leftAxis.labelCount = 4
        lineChartView.xAxis.labelCount = 4
        //color attributes
        lineChartView.legend.textColor = UIColor.green
        lineChartView.xAxis.labelTextColor = UIColor.green
        lineChartView.leftAxis.labelTextColor = UIColor.green
        //give the line chart view a radius on the edges
        lineChartView.layer.cornerRadius = 10
        lineChartView.layer.masksToBounds = true
        }else{
            return
        }
    }
    
    //function used to start updating the graph
    func startUpdating(lineChartView : LineChartView, graphData : [Double], manger : CMMotionManager){
        //call the function to update the graph
        updateGraphData(lineChartView: lineChartView, graphData: graphData, manger: manger)
    }
    
    //used to create a rolling graph
    func setRollingGraph(maxDataPoints: Int, graphData : [GraphData]){
        //once we have more than the min data points start removing
        if graphData.count > maxDataPoints{
            //removes the first value
            AllData.shared.graphData.removeFirst()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


