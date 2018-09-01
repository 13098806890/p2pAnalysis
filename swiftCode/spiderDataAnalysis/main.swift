//
//  main.swift
//  spiderDataAnalysis
//
//  Created by doxie on 8/30/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

let username = "Teemo"
let manager = FileManager.default
let filePathBase: String = "//Users/"+username+"/Desktop/p2pCode/p2pData/"


func writeData(date: String) {
    var debets = NSMutableArray()
    let filePath:String = filePathBase + date + "/"
    let dataFilePath:String = filePath + "all_"+date+".plist"
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

func debets(date: String) -> NSArray? {
    let filePath:String = filePathBase + date + "/"
    let dataFilePath:String = filePath + "all_"+date+".plist"
    return NSArray(contentsOfFile: dataFilePath)
}


func find(infos: [String], date: String) {
    var money: Double = 0
    if let array = debets(date: date) {
        for info in array {
            if let dicInfo: [String: String] = info as? [String: String] {
                if let number = dicInfo["formatRemainInvestAmt"] {
                    if infos.contains(dicInfo["productName"]!) {
                        let result = dicInfo["productName"]! + "   金额:" + dicInfo["formatRemainInvestAmt"]! + "   页数:" + dicInfo["page"]!
                        print(result)
                    }
                    money += Double(number)!
                }
            }
        }
    }
    print(money)
}

func findCorrect(infos: [String: String], date: String) {
    var money: Double = 0
    if let array = debets(date: date) {
        for info in array {
            if let dicInfo: [String: String] = info as? [String: String] {
                if let number = dicInfo["formatRemainInvestAmt"] {
                    if infos.keys.contains(dicInfo["productName"]!) {
                        if let new: Double = Double(dicInfo["formatRemainInvestAmt"]!), let old: Double = Double(infos[dicInfo["productName"]!]!) {
                            if (new - old) / old < 0.01 && (new - old) / old > -0.01{
                                let result = dicInfo["productName"]! + "   金额:" + dicInfo["formatRemainInvestAmt"]! + "   页数:" + dicInfo["page"]!
                                print(result)
                            }
                        }
                    }
                    money += Double(number)!
                }
            }
        }
    }
    print(money)
}

func compare(old: String, new: String) {
    let yestday = debets(date: old)
    var yestdat_ids: Set<String> = Set<String>()
    var yestdayMoney: Double = 0
    for debet in yestday! {
        if let debet = debet as? [String: String], let id = debet["debtId"], let number = debet["formatRemainInvestAmt"] {
            yestdat_ids.insert(id)
            yestdayMoney += Double(number)!
        }
        
    }
    let today = debets(date: new)
    var today_ids: Set<String> = Set<String>()
    var todayMoney: Double = 0
    for debet in today! {
        if let debet = debet as? [String: String], let id = debet["debtId"],let number = debet["formatRemainInvestAmt"] {
            today_ids.insert(id)
            todayMoney += Double(number)!
        }
        
    }
    
    let new: Set<String> = today_ids.subtracting(yestdat_ids)
    
    var money: Double = 0
    for debet in today! {
        if let debet = debet as? [String: String],let id = debet["debtId"] {
            if new.contains(id) {
                if let number = debet["formatRemainInvestAmt"] {
                    money += Double(number)!
                }
            }
        }
    }
    
    let new2 = today_ids.intersection(yestdat_ids)
    var money2: Double = 0
    for debet in yestday! {
        if let debet = debet as? [String: String],let id = debet["debtId"] {
            if new2.contains(id) {
                if let number = debet["formatRemainInvestAmt"] {
                    money2 += Double(number)!
                }
            }
        }
    }
    var money3: Double = 0
    for debet in today! {
        if let debet = debet as? [String: String],let id = debet["debtId"] {
            if new2.contains(id) {
                if let number = debet["formatRemainInvestAmt"] {
                    money3 += Double(number)!
                }
            }
        }
    }
    
    print(yestdayMoney)
    print(todayMoney)
    print(money)
    print(money2)
    print(money3)
}

let infoss = ["个融宝-BZSH2018050703"]
//let xdzinfoss = ["抵押宝-BWXI170601032","抵押宝-AQDA170522021","车融宝-ZY-17122013","车融宝-ZY-17122005","企融宝-1801241857","企融宝-1802070389","企融宝-1711252508","中小微企融宝-BWXI180319012"]

//
//let correctInfos = ["抵押宝-BWXI170601032": "6271.8","抵押宝-AQDA170522021": "5644.88","车融宝-ZY-17122013": "2518.38","车融宝-ZY-17122005": "6651.01","企融宝-1710252517":"60.76", "车融宝-ZY-17120128": "68.82","企融宝-1801241857": "1004.59","企融宝-1802070389": "10693.3", "企融宝-1711252508":"705.99","中小微企融宝-BWXI180319012": "11835.97"]
let xdzcorrect = ["抵押宝-BWXI170601032": "6271.8","抵押宝-AQDA170522021": "5644.88","车融宝-ZY-17122013": "2518.38","车融宝-ZY-17122005": "6651.01","企融宝-1710252517":"60.76", "车融宝-ZY-17120128": "68.82","企融宝-1801241857": "1004.59","企融宝-1802070389": "10693.3", "企融宝-1711252508":"705.99","中小微企融宝-BWXI180319012": "11835.97"]

//findCorrect(infos: xdzcorrect, date: "9.1")

findCorrect(infos: xdzcorrect, date: "9.1")

