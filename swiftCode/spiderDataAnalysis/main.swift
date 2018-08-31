//
//  main.swift
//  spiderDataAnalysis
//
//  Created by doxie on 8/30/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation


var debets = NSMutableArray()

let manager = FileManager.default
let filePathBase: String = "//Users/xie/Desktop/p2pCode/p2pData/"
let date: String = "8.30"
let filePath:String = filePathBase + date + "/"
let dataFilePath:String = filePath + "all_"+date+".plist"

func writeData() {
    do {
        let files = try manager.contentsOfDirectory(atPath: filePath)
        for file in files  {
            if file.hasPrefix(".") {
                continue
            }
            let content = manager.contents(atPath: filePath+file)
            let str = String(data: content!, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            let strArray = str?.components(separatedBy: CharacterSet.init(charactersIn: "{")).filter({ (str) -> Bool in
                return str != ""
            })
            for i in 0..<strArray!.count {
                let infoArray = strArray![i].components(separatedBy: CharacterSet.init(charactersIn: ":,")).filter({ (str) -> Bool in
                    return str != ""
                })
                var debet = [String: String]()
                for j in 0..<infoArray.count where j % 2 == 0 {
                    let key = infoArray[j].replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\"", with: "")
                    let value = infoArray[j+1].replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\"", with: "")
                    debet[key] = value
                }
                debet["page"] = file.replacingOccurrences(of: ".txt", with: "")
                debets.add(debet)
            }
        }


        debets.write(toFile: dataFilePath, atomically: true)
    } catch {
        print("error")
    }
}

func readData() {
    var money: Double = 0
    let exist = manager.fileExists(atPath: dataFilePath)
    if let array = NSArray(contentsOfFile: dataFilePath) {
        for info in array {
            if let dicInfo: [String: String] = info as? [String: String] {
                if let number = dicInfo["formatRemainInvestAmt"] {
                    find(dicInfo, infos: infoss)
//                    findCorrect(dicInfo, infos: correctInfos)
                    money += Double(number)!
                }

            }
        }
    }
    print(money)

}

func find(_ info: [String: String], infos: [String]) {
    if infos.contains(info["productName"]!) {
        let result = info["productName"]! + "   金额:" + info["formatRemainInvestAmt"]! + "   页数:" + info["page"]!
        print(result)
    }

}

func findCorrect(_ info: [String: String], infos: [String: String]) {
    if infos.keys.contains(info["productName"]!) {
        if info["formatRemainInvestAmt"] == infos[info["productName"]!] {
            let result = info["productName"]! + "   金额:" + info["formatRemainInvestAmt"]! + "   页数:" + info["page"]!
            print(result)
        }

    }
}

let infoss = ["抵押宝-BWXI170601032","抵押宝-AQDA170522021","车融宝-ZY-17122013"]
//let xdzinfoss = ["抵押宝-BWXI170601032","抵押宝-AQDA170522021","车融宝-ZY-17122013","车融宝-ZY-17122005","企融宝-1801241857","企融宝-1802070389","企融宝-1711252508","中小微企融宝-BWXI180319012"]

//
//let correctInfos = ["抵押宝-BWXI170601032": "6271.8","抵押宝-AQDA170522021": "5644.88","车融宝-ZY-17122013": "2518.38","车融宝-ZY-17122005": "6651.01","企融宝-1710252517":"60.76", "车融宝-ZY-17120128": "68.82","企融宝-1801241857": "1004.59","企融宝-1802070389": "10693.3", "企融宝-1711252508":"705.99","中小微企融宝-BWXI180319012": "11835.97"]
//let xdzcorrect = ["抵押宝-BWXI170601032": "6271.8","抵押宝-AQDA170522021": "5644.88","车融宝-ZY-17122013": "2518.38","车融宝-ZY-17122005": "6651.01","企融宝-1710252517":"60.76", "车融宝-ZY-17120128": "68.82","企融宝-1801241857": "1004.59","企融宝-1802070389": "10693.3", "企融宝-1711252508":"705.99","中小微企融宝-BWXI180319012": "11835.97"]


readData()




