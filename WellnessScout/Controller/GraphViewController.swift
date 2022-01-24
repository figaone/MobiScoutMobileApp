//
//  GraphViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/24/21.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    
    
    //MARK: Singelton Instance use this to refrence all data
    let allData = AllData.shared
    //line chart
    @IBOutlet weak var lineChartView: LineChartView!
    //MARK: Managers
    let sensorManager = SensorManager()
    let graphManager = GraphManager()
    
    
    //fires when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    //fires when the view appears
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        //create the timer here to update the graph
        AllData.shared.graphTimer = Timer.scheduledTimer( timeInterval: 0.1, target: self, selector: #selector(updateGraph), userInfo: nil, repeats: true)
    }
    
    //fires when the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        //stop the timer
        AllData.shared.graphTimer.invalidate()
    }
    
    //used to update the graph
    @objc func updateGraph(){
        //update the graph and get the new data here
        sensorManager.saveGraphData(motionManager: AllData.shared.motionManager)
        //set the graph as a rolling graph
        graphManager.setRollingGraph(maxDataPoints: 300, graphData: AllData.shared.graphData)
        //make sure that we have data
        if AllData.shared.graphData.count > 0 {
            //update the view here
            updateGraphData()
        }
    }
    
    //fires when the reset button is pressed
    @IBAction func resetButtonPressed(_ sender: Any) {
        //remove all the old data from the graph and restart
        AllData.shared.graphData.removeAll()
        //update the graph
        updateGraph()
    }
    
    //called to update the graph
    func updateGraphData(){
        //entrys for the chart
        var chartEntry = [ChartDataEntry]()
        //var secondEntry = [ChartDataEntry]()
        //var thirdEntry = [ChartDataEntry]()
        //loop thru the values
        for i in 0..<AllData.shared.graphData.count {
            //create the value
            let value = ChartDataEntry(x: Double(i), y: AllData.shared.graphData[i].accelerometerZ)
            _ = ChartDataEntry(x: Double(i), y: AllData.shared.graphData[i].accelerometerX)
            _ = ChartDataEntry(x: Double(i), y: AllData.shared.graphData[i].accelerometerY)
            //append the data
            chartEntry.append(value)
            //secondEntry.append(value2)
            //thirdEntry.append(value3)
        }
        //set the dataset and label it
        let lineChartData = LineChartDataSet(entries: chartEntry, label: "Acceleration Z")
        //let lineChartData2 = LineChartDataSet(entries: secondEntry, label: "Acceleration X")
        //let lineChartData3 = LineChartDataSet(entries: thirdEntry, label: "Acceleration Y")
        //set the colors for the first graph
        lineChartData.colors = [UIColor.green]
        lineChartData.circleRadius = 0
        lineChartData.drawValuesEnabled = false
        /*
         //set the colors for the second graph
         lineChartData2.colors = [UIColor.blue]
         lineChartData2.circleRadius = 1
         lineChartData2.drawValuesEnabled = false
         //set the colors for the third graph
         lineChartData3.colors = [UIColor.red]
         lineChartData3.circleRadius = 1
         lineChartData3.drawValuesEnabled = false
         //chart data
         */
        let data = LineChartData()
        //add the data set
        data.addDataSet(lineChartData)
        //data.addDataSet(lineChartData2)
        //data.addDataSet(lineChartData3)
        
        //add the data to the view
        lineChartView.data = data
        //attributes for the view
        lineChartView.backgroundColor = UIColor.black
        lineChartView.data?.setValueTextColor(NSUIColor.white)
        lineChartView.legend.textColor = UIColor.green
        lineChartView.xAxis.labelTextColor = UIColor.green
        lineChartView.leftAxis.labelTextColor = UIColor.green
        //remove user interacction
        lineChartView.isUserInteractionEnabled = false
    }
    
    
}


