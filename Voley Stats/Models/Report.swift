//
//  Report.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 26/2/24.
//

import Foundation
import SwiftUI

enum ReportSections: String, CaseIterable{
    case pointLog = "point.log"
    case attackDetail = "attack.detail"
    case serveDetail = "serve.detail"
    case receiveDetail = "receive.detail"
    case matchCompare = "match.compare"
    case errorTree = "error.tree"
    case hiddenCount = "hidden.count"
    case setDetail = "sets.detail"
}

class Report: PDF{
    var sections:[ReportSections]=[]
    
    init(team: Team, match: Match, sections: [ReportSections]=[]) {
        super.init()
        self.sections = sections
        self.matchReport(team: team, match: match)
    }
    init(team: Team, matches: [Match], sections: [ReportSections]=[]) {
        super.init()
        self.sections = sections
        self.multiMatchReport(team: team, matches: matches)
    }
    
    func sections(sections: [ReportSections]){
        self.sections = sections
    }
    
    func matchReport(team: Team, match: Match) -> Report{
        //215, 217, 216
        
        self.title = "\(team.name)-\(match.opponent)"
        
        var x = 27
        var y = header(info: "match.report".trad())
        let result = match.result()
        addText(x: x, y: y+10, text: team.name.uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        addText(x: Int(self.pageWidth/2+100), y: y+10, text: "\(result.0)", font: self.fonts["title"]!, color:UIColor.black)
        y+=40
        addText(x: x, y: y+10, text: match.opponent.uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        addText(x: Int(self.pageWidth/2+100), y: y+10, text: "\(result.1)", font: self.fonts["title"]!, color:UIColor.black)
        y-=40
        y += 10
        x=Int(self.pageWidth/2)+140
        //summary section
        addShape(x: x-10, y: y-5, width: ("result".trad().count + 3)*10, height: 17+(match.n_sets)*17, shape: "rect", color: UIColor.black, fill: false)
        addText(x: x, y: y, text: "Set", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        addText(x: x, y: y, text: "result".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=15
        match.sets().forEach{set in
            x=Int(self.pageWidth/2)+140
            addText(x: x, y: y, text: "\(set.number)", font: self.fonts["body"]!, color:UIColor.black)
            x+=40
            addText(x: x, y: y, text: "\(set.score_us)-\(set.score_them)", font: self.fonts["body"]!, color:UIColor.black)
            y+=15
        }
        y+=20
        //players section
        var yPlay = y
        x=250
        addText(x: x+12, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=100
        addText(x: x+5, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=85
        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=80
        addText(x: x+15, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=22
        x=27
        addText(x: x, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=160
        addText(x: x, y: y, text: "gp".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=35
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=22
        x=27
        var stats = match.stats()
//        if !self.sections.contains(.digCount){
//            stats = stats.filter{s in return !actionsByType["dig"]!.contains(s.action)}
//        }
        var players = 2
        team.players().forEach{player in
            let ps = stats.filter{s in return s.player == player.id}
            let serves = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}
            if ps.count > 0 || serves.count > 0{
                players += 1
                addText(x: x, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black)
                addText(x: x+20, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black)
                x+=160
                //G-P
                var gp = 0
                if self.sections.contains(.hiddenCount){
                    gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
                }else{
                    let g = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
                    let p = ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
                    print(g, p)
                    gp = g.count - p.count
                }
                addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                //serves
                
                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                // serve errors
                x+=30
                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                // aces
                x+=30
                let aces = serves.filter{s in return s.action==8}.count
                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=40
                // receive
                let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=25
                // receive error
                let Rerr = rcv.filter{s in return s.action==22}.count
                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=30
                // receive mark
                let op = rcv.filter{s in return s.action==1}.count
                let s1 = rcv.filter{s in return s.action==2}.count
                let s2 = rcv.filter{s in return s.action==3}.count
                let s3 = rcv.filter{s in return s.action==4}.count
                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                // attack
                let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=25
                // Attack errors
                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=30
                // kills
                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=35
                // blocks
                let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
                let blkPts = ps.filter{s in return s.action==13}.count
                let bErr = ps.filter{s in return s.action==20}.count
                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=20
                addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=20
                addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x = 27
                y+=20
            }
        }
        y+=10
        let h = (players * 20) + 5
        x=250
        addShape(x: x-75, y: yPlay, width: 50, height: h, shape: "rect", color: UIColor.black, fill: false)
        addShape(x: x-75, y: yPlay, width: 145, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=100
        addShape(x: x-30, y: yPlay, width: 105, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=100
        addShape(x: x-25, y: yPlay, width: 85, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=60
        addShape(x: x, y: yPlay, width: 75, height: h, shape: "rect", color: UIColor.black, fill: false)
        yPlay+=22
        x=27
        addShape(x: x-10, y: yPlay-5, width: 568, height: h-17, shape: "rect", color: UIColor.black, fill: false)
        x+=50
        var receiveDetail:[BarElement]=[]
        var serveDetail:[BarElement]=[]
        var attackDetail:[BarElement]=[]
        match.sets().forEach{set in
            players += 1
            let ps = stats.filter{s in return s.set == set.id && s.player != 0}
            addText(x: x, y: y, text: "\("totals".trad()) set \(set.number)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=110
            var gp = 0
            if self.sections.contains(.hiddenCount){
                gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
            }else{
                gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
            }
            addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=45
            //serves
            
            let serves = stats.filter{s in return s.set == set.id && s.stage == 0 && s.to != 0}
            addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            // serve errors
            x+=30
            let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
            addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            // aces
            x+=30
            let aces = serves.filter{s in return s.action==8}.count
            addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=40
            // receive
            let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
            addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=25
            // receive error
            let Rerr = rcv.filter{s in return s.action==22}.count
            addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=30
            // receive mark
            let op = rcv.filter{s in return s.action==1}.count
            let s1 = rcv.filter{s in return s.action==2}.count
            let s2 = rcv.filter{s in return s.action==3}.count
            let s3 = rcv.filter{s in return s.action==4}.count
            let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
            addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=45
            // attack
            let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
            addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=25
            // Attack errors
            let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}
            addText(x: x, y: y, text: Aerr.isEmpty ? "." : "\(Aerr.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=30
            // kills
            let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
            addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=35
            // blocks
            let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
            let blkPts = ps.filter{s in return s.action==13}.count
            let bErr = ps.filter{s in return s.action==20}.count
            addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=20
            addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=20
            addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            y+=20
            x=77
            
            if !ps.isEmpty {
                receiveDetail.append(BarElement(value: rcv.count, color: .gray, group: "Set \(set.number)", label: "total".trad()))
                receiveDetail.append(BarElement(value: Rerr, color: .red, group: "Set \(set.number)", label: "error".trad()))
                receiveDetail.append(BarElement(value: s1, color: .orange, group: "Set \(set.number)", label: "-"))
                receiveDetail.append(BarElement(value: s2, color: .yellow, group: "Set \(set.number)", label: "+"))
                receiveDetail.append(BarElement(value: s3, color: .green, group: "Set \(set.number)", label: "#"))
                
                attackDetail.append(BarElement(value: atk.count, color: .gray, group: "Set \(set.number)", label: "total".trad()))
                attackDetail.append(BarElement(value: Aerr.filter{$0.detail == "Net"}.count, color: .red, group: "Set \(set.number)", label: "net".trad()))
                attackDetail.append(BarElement(value: Aerr.filter{$0.detail == "Out"}.count, color: .orange, group: "Set \(set.number)", label: "out".trad()))
                attackDetail.append(BarElement(value: Aerr.filter{$0.detail == "Blocked"}.count, color: .yellow, group: "Set \(set.number)", label: "blocked".trad()))
                attackDetail.append(BarElement(value: kills, color: .green, group: "Set \(set.number)", label: "kills".trad()))
                
                serveDetail.append(BarElement(value: serves.count, color: .gray, group: "Set \(set.number)", label: "total".trad()))
                serveDetail.append(BarElement(value: Serr, color: .red, group: "Set \(set.number)", label: "error".trad()))
                serveDetail.append(BarElement(value: serves.filter{s in return [40,41].contains(s.action) && s.server != 0}.count, color: .orange, group: "Set \(set.number)", label: "-".trad()))
                serveDetail.append(BarElement(value: serves.filter{s in return s.action==39 && s.server != 0}.count, color: .yellow, group: "Set \(set.number)", label: "+".trad()))
                serveDetail.append(BarElement(value: aces, color: .green, group: "Set \(set.number)", label: "ace".trad()))
            }
        }
        addText(x: x, y: y, text: "\("match".trad()) \("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=110
        let ps = stats.filter{s in return s.player != 0}
        var gp = 0
        if self.sections.contains(.hiddenCount){
            gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
        }else{
            gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
        }
        addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        
        //serves
        let serves = stats.filter{s in return s.stage == 0 && s.to != 0}
        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        // serve errors
        x+=30
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        // aces
        x+=30
        let aces = serves.filter{s in return s.action==8}.count
        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        // receive
        let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        // receive error
        let Rerr = rcv.filter{s in return s.action==22}.count
        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        
        // receive mark
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        // attack
        let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        // Attack errors
        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
        addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=35
        // blocks
        let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
        let blkPts = ps.filter{s in return s.action==13}.count
        let bErr = ps.filter{s in return s.action==20}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x=27
        y+=45
        if self.sections.contains(ReportSections.errorTree){
            let (errx, erry) = self.errorTree(match: match, startX: x, startY: y)
            if self.sections.contains(ReportSections.matchCompare){
                x = errx + 40
            } else {
                y = erry + 40
            }
        }
        if self.sections.contains(ReportSections.matchCompare){
            (_, y) = self.matchCompare(match: match, startX: x, startY: y)
            y += 40
        }
        
        if self.sections.contains(.setDetail){
            match.sets().forEach{set in
                if set.first_serve != 0{
                    self.newPage()
                    self.setReport(team: team, set: set)
                }
            }
//            self.newPage()
//            x=17
//            y = self.header(info: "match.report".trad()) + 5
            y = 20000
        }
        
        if self.sections.contains(ReportSections.pointLog){
            self.pointLog(match: match)
            y = 20000
//            self.newPage()
//            x=17
//            y = self.header(info: "match.report".trad()) + 5
        }
        
        if self.sections.contains(ReportSections.receiveDetail){
            if y + 250 > Int(self.pageHeight){
                self.newPage()
                
                y = self.header(info: "match.report".trad()) + 5
            }
            x=50
            (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "receive.detail".trad(), data: receiveDetail)
            y+=40
        }
        if self.sections.contains(ReportSections.serveDetail){
            if y + 250 > Int(self.pageHeight){
                self.newPage()
                
                y = self.header(info: "match.report".trad()) + 5
            }
            x=50
            (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "serve.detail".trad(), data: serveDetail)
            y+=40
        }
        if self.sections.contains(ReportSections.attackDetail){
            if y + 250 > Int(self.pageHeight){
                self.newPage()
                
                y = self.header(info: "match.report".trad()) + 5
            }
            x=50
            (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "attack.detail".trad(), data: attackDetail)
            y+=40
        }
        if false {
            //stats section
            x=27
            y+=45
            //84, 199, 93
            //        let atts = stats.filter{s in return actionsByType["attack"]?.contains(s.action) ?? false && s.player != 0}.count
            
            //        let kills = stats.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
            var p = (Float(kills)/Float(atk.count))*100
            addText(x: x, y: y, text: "kill.percentage".trad(), font: self.fonts["heading"]!, color:UIColor.black)
            addShape(x: x, y: y+25, width: 200, height: 60, shape: "rect", color: self.colors["green"]!.withAlphaComponent(0.5), fill: true)
            addShape(x: x, y: y+25, width: atk.count == 0 ? 0 : Int((Float(200)*p)/100), height: 60, shape: "rect", color: self.colors["green"]!.withAlphaComponent(0.5), fill: true)
            addText(x: x+30, y: y+40, text: "\(atk.count == 0 ? "0" : String(format: "%.2f",p))%", font: self.fonts["title"]!, color: UIColor.white)
            
            y+=100
            //214, 146, 58
            let stat = stats.filter{s in return actionsByType["receive"]?.contains(s.action) ?? false && s.player != 0}
            
            let recv = stat.count
            //        let s1 = stat.filter{s in return s.action==2}.count
            //        let s2 = stat.filter{s in return s.action==3}.count
            //        let s3 = stat.filter{s in return s.action==4}.count
            p = Float(op/2 + s1 + 2*s2 + 3*s3)/Float(recv)
            addText(x: x, y: y, text: "receive.rating".trad(), font: self.fonts["heading"]!, color:UIColor.black)
            addShape(x: x, y: y+25, width: 200, height: 60, shape: "rect", color: colors["orange"]!.withAlphaComponent(0.5), fill: true)
            addShape(x: x, y: y+25, width: recv == 0 ? 0 : Int((Float(200)*p)/3), height: 60, shape: "rect", color: colors["orange"]!.withAlphaComponent(0.5), fill: true)
            addText(x: x+30, y: y+40, text: "\(recv == 0 ? "0" : String(format: "%.2f",p))/3", font: self.fonts["title"]!, color: UIColor.white)
            y-=75
            x+=220
            //247, 201, 74
            let serveErr = stats.filter{s in return [15, 32].contains(s.action) && s.player != 0}
            addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: self.colors["yellow"]!, fill: true)
            addText(x: x+60, y: y+10, text: "\(serveErr.count)", font: self.fonts["title"]!, color: UIColor.white)
            addText(x: x+45, y: y+35, text: "serve.errors".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
            x+=170
            //197, 114, 212
            let theirErr = stats.filter{s in return s.player == 0 && s.to == 1}.count
            addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: self.colors["pink"]!, fill: true)
            addText(x: x+60, y: y+10, text: "\(theirErr)", font: self.fonts["title"]!, color: UIColor.white)
            addText(x: x+45, y: y+35, text: "their.errors".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
            y+=100
            x-=170
            var total = stats.filter{s in return s.server != 0 && s.stage == 0 && s.to != 0}.count
            var srvWon = stats.filter{s in return s.server != 0 && s.to == 1 && s.stage == 0  && s.player != 0}.count
            addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: UIColor.gray, fill: true)
            addText(x: x+50, y: y+10, text: "\(srvWon == 0 ? "0" : String(format: "%.2f", Float(total)/Float(srvWon)))", font: self.fonts["title"]!, color: UIColor.white)
            addText(x: x+30, y: y+35, text: "serves.per.point".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
            x+=170
            total = stats.filter{s in return s.stage == 1 && s.server == 0 && s.to != 0}.count
            let rcvWon = stats.filter{s in return s.server == 0 && s.to == 1 && s.stage == 1}.count
            addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: UIColor.gray, fill: true)
            addText(x: x+50, y: y+10, text: "\(String(format: "%.2f",rcvWon == 0 ? 0 : Float(total)/Float(rcvWon)))", font: self.fonts["title"]!, color: UIColor.white)
            addText(x: x+30, y: y+35, text: "receives.per.point".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
            //info rcv & Q
            //errors, blocked, kills and atts after + or #
            //errors, blocked, kills and atts after -
            //errors, blocked, kills and atts after dig
            //match bests
            y+=70
            x=250
            if players < 13 {
                addText(x: x, y: y, text: "match.bests".trad(), font: self.fonts["heading"]!, color:UIColor.black)
                y+=30
                x=27
                let mid = Int(self.pageWidth/4)
                let bests = match.getBests()
                //186, 148, 22
                addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
                addText(x: x+10, y: y+10, text: "block".trad(), font: self.fonts["title2"]!, color: colors["gold"]!)
                addText(x: x+20, y: y+40, text: "\(bests["block"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
                x+=mid-10
                addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
                addText(x: x+15, y: y+10, text: "serve".trad(), font: self.fonts["title2"]!, color: colors["gold"]!)
                addText(x: x+20, y: y+40, text: "\(bests["serve"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
                x+=mid-10
                addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
                addText(x: x+10, y: y+10, text: "receive".trad(), font: self.fonts["title2"]!, color: colors["gold"]!)
                addText(x: x+20, y: y+40, text: "\(bests["receive"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
                x+=mid-10
                addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
                addText(x: x+25, y: y+10, text: "attack".trad(), font: self.fonts["title2"]!, color: self.colors["gold"]!)
                addText(x: x+20, y: y+40, text: "\(bests["attack"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
                y+=70
                x=27
                addShape(x: x, y: y, width: Int(self.pageWidth-55), height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
                addText(x: x+250, y: y+10, text: "MVP", font: self.fonts["title2"]!, color: self.colors["gold"]!)
                addText(x: x+225, y: y+40, text: "\(bests["mvp"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
            }
        }
        return self
    }
    
    func multiMatchReport(team: Team, matches: [Match]) -> Report{
        //215, 217, 216
        
        self.title = "\(team.name)_multimatch_\(Date().timeIntervalSince1970)"
        
        var x = 27
        var y = header(info: "multi.match.report".trad())
        addText(x: x, y: y+10, text: " \("report".trad()): \(team.name)".uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        y+=45
        let opps = matches.map{$0.opponent}.joined(separator: " - ")
        if (opps.count * 7) < Int(self.pageWidth - 50){
            addText(x: x, y: y, text: opps, font: self.fonts["body"]!, color:UIColor.black)
        }
        y+=30
        //players section
        var yPlay = y
        x=250
        addText(x: x+12, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=100
        addText(x: x+10, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=100
        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=75
        y+=22
        x=27
        addText(x: x, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=160
        addText(x: x, y: y, text: "G-P", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "err", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        addText(x: x, y: y, text: "err", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        addText(x: x, y: y, text: "err", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        addText(x: x, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=22
        x=27
        let stats = matches.flatMap{$0.stats()}
        var players = 2
        team.players().forEach{player in
            let ps = stats.filter{s in return s.player == player.id}
            let serves = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}
            if ps.count > 0 || serves.count > 0{
                players += 1
                addText(x: x, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black)
                addText(x: x+20, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black)
                x+=160
                //G-P
                let gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
                addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                //serves
                
                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                // serve errors
                x+=30
                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                // aces
                x+=30
                let aces = serves.filter{s in return s.action==8}.count
                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                // receive
                let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=25
                // receive error
                let Rerr = rcv.filter{s in return s.action==22}.count
                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=30
                // receive mark
                let op = rcv.filter{s in return s.action==1}.count
                let s1 = rcv.filter{s in return s.action==2}.count
                let s2 = rcv.filter{s in return s.action==3}.count
                let s3 = rcv.filter{s in return s.action==4}.count
                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                // attack
                let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=25
                // Attack errors
                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=30
                // kills
                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=40
                // blocks
                let blocks = ps.filter{s in return s.action==13}.count
                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x = 27
                y+=20
            }
        }
        y+=10
        let h = (players * 20) + 5
        x=250
        addShape(x: x-75, y: yPlay, width: 50, height: h, shape: "rect", color: UIColor.black, fill: false)
        addShape(x: x-75, y: yPlay, width: 155, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=100
        addShape(x: x-20, y: yPlay, width: 100, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=100
        addShape(x: x-20, y: yPlay, width: 95, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=75
        addShape(x: x, y: yPlay, width: 60, height: h, shape: "rect", color: UIColor.black, fill: false)
        yPlay+=22
        x=27
        addShape(x: x-10, y: yPlay-5, width: 568, height: h-17, shape: "rect", color: UIColor.black, fill: false)
        x+=50
        addText(x: x, y: y, text: "totals".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=110
        let ps = stats.filter{s in return s.player != 0}
        let gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
        addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        
        //serves
        let serves = stats.filter{s in return s.stage == 0 && s.to != 0}
        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        // serve errors
        x+=30
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        // aces
        x+=30
        let aces = serves.filter{s in return s.action==8}.count
        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        // receive
        let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        // receive error
        let Rerr = rcv.filter{s in return s.action==22}.count
        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        // receive mark
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        // attack
        let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        // Attack errors
        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
        addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        // blocks
        let blocks = ps.filter{s in return s.action==13}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        //stats section
        x=27
        y+=45
        //84, 199, 93
//        let atts = stats.filter{s in return actionsByType["attack"]?.contains(s.action) ?? false && s.player != 0}.count
        
//        let kills = stats.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
//        var p = (Float(kills)/Float(atk.count))*100
//        addText(x: x, y: y, text: "kill.percentage".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
//        addShape(x: x, y: y+25, width: 200, height: 60, shape: "rect", color: self.colors["green"]!.withAlphaComponent(0.5), fill: true)
//        addShape(x: x, y: y+25, width: atk.count == 0 ? 0 : Int((Float(200)*p)/100), height: 60, shape: "rect", color: self.colors["green"]!.withAlphaComponent(0.5), fill: true)
//        addText(x: x+30, y: y+40, text: "\(atk.count == 0 ? "0" : String(format: "%.2f",p))%", font: self.fonts["title"]!, color: UIColor.white)
//
//        y+=100
//        //214, 146, 58
//        let stat = stats.filter{s in return actionsByType["receive"]?.contains(s.action) ?? false && s.player != 0}
//
//        let recv = stat.count
////        let s1 = stat.filter{s in return s.action==2}.count
////        let s2 = stat.filter{s in return s.action==3}.count
////        let s3 = stat.filter{s in return s.action==4}.count
//        p = Float(op/2 + s1 + 2*s2 + 3*s3)/Float(recv)
//        addText(x: x, y: y, text: "receive.rating".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
//        addShape(x: x, y: y+25, width: 200, height: 60, shape: "rect", color: colors["orange"]!.withAlphaComponent(0.5), fill: true)
//        addShape(x: x, y: y+25, width: recv == 0 ? 0 : Int((Float(200)*p)/3), height: 60, shape: "rect", color: colors["orange"]!.withAlphaComponent(0.5), fill: true)
//        addText(x: x+30, y: y+40, text: "\(recv == 0 ? "0" : String(format: "%.2f",p))/3", font: self.fonts["title"]!, color: UIColor.white)
//        y-=75
//        x+=220
//        //247, 201, 74
//        let serveErr = stats.filter{s in return [15, 32].contains(s.action) && s.player != 0}
//        addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: self.colors["yellow"]!, fill: true)
//        addText(x: x+60, y: y+10, text: "\(serveErr.count)", font: self.fonts["title"]!, color: UIColor.white)
//        addText(x: x+45, y: y+35, text: "serve.errors".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
//        x+=170
//        //197, 114, 212
//        let theirErr = stats.filter{s in return s.player == 0 && s.to == 1}.count
//        addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: self.colors["pink"]!, fill: true)
//        addText(x: x+60, y: y+10, text: "\(theirErr)", font: self.fonts["title"]!, color: UIColor.white)
//        addText(x: x+45, y: y+35, text: "their.errors".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
//        y+=100
//        x-=170
//        var total = stats.filter{s in return s.server != 0 && s.stage == 0 && s.to != 0}.count
//        var srvWon = stats.filter{s in return s.server != 0 && s.to == 1 && s.stage == 0  && s.player != 0}.count
//        addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: UIColor.gray, fill: true)
//        addText(x: x+50, y: y+10, text: "\(srvWon == 0 ? "0" : String(format: "%.2f", Float(total)/Float(srvWon)))", font: self.fonts["title"]!, color: UIColor.white)
//        addText(x: x+30, y: y+35, text: "serves.per.point".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
//        x+=170
//        total = stats.filter{s in return s.stage == 1 && s.server == 0 && s.to != 0}.count
//        let rcvWon = stats.filter{s in return s.server == 0 && s.to == 1 && s.stage == 1}.count
//        addShape(x: x, y: y, width: 150, height: 60, shape: "rect", color: UIColor.gray, fill: true)
//        addText(x: x+50, y: y+10, text: "\(String(format: "%.2f",rcvWon == 0 ? 0 : Float(total)/Float(rcvWon)))", font: self.fonts["title"]!, color: UIColor.white)
//        addText(x: x+30, y: y+35, text: "receives.per.point".trad(), font: self.fonts["bodyBold"]!, color: UIColor.white)
//        //info rcv & Q
//        //errors, blocked, kills and atts after + or #
//        //errors, blocked, kills and atts after -
//        //errors, blocked, kills and atts after dig
//        //match bests
//        y+=70
//        x=250
//        if players < 13 {
//            addText(x: x, y: y, text: "match.bests".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
//            y+=30
//            x=27
//            let mid = Int(self.pageWidth/4)
//            let bests = Match.getBests(matches: matches)
//            //186, 148, 22
//            addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
//            addText(x: x+10, y: y+10, text: "block".trad().capitalized, font: self.fonts["title2"]!, color: colors["gold"]!)
//            addText(x: x+20, y: y+40, text: "\(bests["block"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
//            x+=mid-10
//            addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
//            addText(x: x+15, y: y+10, text: "serve".trad().capitalized, font: self.fonts["title2"]!, color: colors["gold"]!)
//            addText(x: x+20, y: y+40, text: "\(bests["serve"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
//            x+=mid-10
//            addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
//            addText(x: x+10, y: y+10, text: "receive".trad().capitalized, font: self.fonts["title2"]!, color: colors["gold"]!)
//            addText(x: x+20, y: y+40, text: "\(bests["receive"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
//            x+=mid-10
//            addShape(x: x, y: y, width: mid-21, height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
//            addText(x: x+25, y: y+10, text: "attack".trad().capitalized, font: self.fonts["title2"]!, color: self.colors["gold"]!)
//            addText(x: x+20, y: y+40, text: "\(bests["attack"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
//            y+=70
//            x=27
//            addShape(x: x, y: y, width: Int(self.pageWidth-55), height: 60, shape: "rect", color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8), fill: true)
//            addText(x: x+250, y: y+10, text: "MVP", font: self.fonts["title2"]!, color: self.colors["gold"]!)
//            addText(x: x+225, y: y+40, text: "\(bests["mvp"]!?.name ?? "--")", font: self.fonts["body"]!, color: self.colors["gold"]!)
//        }
        return self
    }
    
    func setReport(team:Team, set: Set) -> Report{
        //215, 217, 216
        var x = 27
        var y = header(info: "match.report".trad())
        addText(x: x, y: y+10, text: "Set \(set.number)", font: PDFonts.title2, color:UIColor.black)
        y+=40
        //players section
        var yPlay = y
        x=250
        addText(x: x+12, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=100
        addText(x: x+5, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=85
        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=80
        addText(x: x+15, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=22
        x=27
        addText(x: x, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=160
        addText(x: x, y: y, text: "gp".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=35
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=22
        x=27
        var stats = set.stats()
//        if !self.sections.contains(.digCount){
//            stats = stats.filter{s in return !actionsByType["dig"]!.contains(s.action)}
//        }
        var players = 2
        team.players().forEach{player in
            let ps = stats.filter{s in return s.player == player.id}
            let serves = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}
            if ps.count > 0 || serves.count > 0{
                players += 1
                addText(x: x, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black)
                addText(x: x+20, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black)
                x+=160
                //G-P
                var gp = 0
                if self.sections.contains(.hiddenCount){
                    gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
                }else{
                    let g = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
                    let p = ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
                    print(g, p)
                    gp = g.count - p.count
                }
                addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                //serves
                
                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                // serve errors
                x+=30
                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                // aces
                x+=30
                let aces = serves.filter{s in return s.action==8}.count
                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=40
                // receive
                let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=25
                // receive error
                let Rerr = rcv.filter{s in return s.action==22}.count
                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=30
                // receive mark
                let op = rcv.filter{s in return s.action==1}.count
                let s1 = rcv.filter{s in return s.action==2}.count
                let s2 = rcv.filter{s in return s.action==3}.count
                let s3 = rcv.filter{s in return s.action==4}.count
                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=45
                // attack
                let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=25
                // Attack errors
                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=30
                // kills
                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=35
                // blocks
                let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
                let blkPts = ps.filter{s in return s.action==13}.count
                let bErr = ps.filter{s in return s.action==20}.count
                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=20
                addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=20
                addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x = 27
                y+=20
            }
        }
        y+=10
        let h = (players * 20) + 5
        x=250
        addShape(x: x-75, y: yPlay, width: 50, height: h, shape: "rect", color: UIColor.black, fill: false)
        addShape(x: x-75, y: yPlay, width: 145, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=100
        addShape(x: x-30, y: yPlay, width: 105, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=100
        addShape(x: x-25, y: yPlay, width: 85, height: h, shape: "rect", color: UIColor.black, fill: false)
        x+=60
        addShape(x: x, y: yPlay, width: 75, height: h, shape: "rect", color: UIColor.black, fill: false)
        yPlay+=22
        x=27
        addShape(x: x-10, y: yPlay-5, width: 568, height: h-17, shape: "rect", color: UIColor.black, fill: false)
        x+=50
        
        addText(x: x, y: y, text: "\("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=110
        let ps = stats.filter{s in return s.player != 0}
        var gp = 0
        if self.sections.contains(.hiddenCount){
            gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
        }else{
            gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
        }
        addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        
        //serves
        let serves = stats.filter{s in return s.stage == 0 && s.to != 0}
        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        // serve errors
        x+=30
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        // aces
        x+=30
        let aces = serves.filter{s in return s.action==8}.count
        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        // receive
        let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        // receive error
        let Rerr = rcv.filter{s in return s.action==22}.count
        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        
        // receive mark
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=45
        // attack
        let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=25
        // Attack errors
        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
        addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=35
        // blocks
        let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
        let blkPts = ps.filter{s in return s.action==13}.count
        let bErr = ps.filter{s in return s.action==20}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=20
        addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)

        return self
    }
}
