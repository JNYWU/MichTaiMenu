//
//  handleCSV.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import Foundation

func loadCSVData() -> [Restaurant]{
    var csvToStruct = [Restaurant]()
    
    // locate CSV file
    guard let filePath = Bundle.main.path(forResource: "Michelin", ofType: "csv") else {
        print("Error: file not found")
        return []
    }
    
    // convert file into a string
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
        
    // split the string into rows
    var rows = data.components(separatedBy: "\n")
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        
        let linesStruct = Restaurant.init(raw: csvColumns)
        csvToStruct.append(linesStruct)
    }
    
    return csvToStruct
}
