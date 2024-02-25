import PDFKit

struct Colors{
    static let green = UIColor(red: 0.33, green: 0.78, blue: 0.36, alpha: 1)
    static let orange = UIColor(red: 0.84, green: 0.57, blue: 0.23, alpha: 1)
    static let pink = UIColor(red: 0.77, green: 0.45, blue: 0.83, alpha: 1)
    static let yellow = UIColor(red: 0.97, green: 0.79, blue: 0.29, alpha: 1)
    static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let gray = UIColor(red: 0.84, green: 0.85, blue: 0.85, alpha: 1)
    static let gold = UIColor(red: 0.73, green: 0.58, blue: 0.09, alpha: 1)
    static let blue = UIColor(red: 0.29, green: 0.62, blue: 0.93, alpha: 1)
    static let red = UIColor(red: 0.69, green: 0.1, blue: 0.1, alpha: 1)
}

struct PDFonts{
    static let title = UIFont(name: "Futura-bold", size:  26.0) ?? UIFont.boldSystemFont(ofSize: 26)
    static let body = UIFont.systemFont(ofSize: 12)
    static let bodyBold = UIFont.boldSystemFont(ofSize: 12)
    static let headingBold = UIFont(name: "Futura-bold", size:  12) ?? UIFont.boldSystemFont(ofSize: 12)
    static let heading = UIFont(name: "Futura-medium", size:  18) ?? UIFont.boldSystemFont(ofSize: 12)
    static let caption = UIFont.systemFont(ofSize: 9)
    static let title2 = UIFont(name: "Futura-bold", size:  22) ?? UIFont.boldSystemFont(ofSize: 22)
    static let title3 = UIFont(name: "Futura-bold", size:  18) ?? UIFont.boldSystemFont(ofSize: 18)
}

class PDF {
    var pdf: UIGraphicsPDFRenderer
    var title: String = "Output"
    var elements: [PDFElement] = []
    let pageWidth = 595.2
    let pageHeight = 841.8
    let page:CGRect
    let fonts: Dictionary<String,UIFont> = [
        "title": UIFont(name: "Futura-bold", size:  26.0) ?? UIFont.boldSystemFont(ofSize: 26),
        "body":UIFont.systemFont(ofSize: 12),
        "bodyBold":UIFont.boldSystemFont(ofSize: 12),
        "headingBold":UIFont(name: "Futura-bold", size:  12) ?? UIFont.boldSystemFont(ofSize: 12),
        "heading":UIFont(name: "Futura-medium", size:  18) ?? UIFont.boldSystemFont(ofSize: 12),
        "caption":UIFont.systemFont(ofSize: 9),
        "title2": UIFont(name: "Futura-bold", size:  22) ?? UIFont.boldSystemFont(ofSize: 22),
        "title3": UIFont(name: "Futura-bold", size:  18) ?? UIFont.boldSystemFont(ofSize: 18),
    ]
    let colors: Dictionary<String,UIColor>=[
        "green": UIColor(red: 0.33, green: 0.78, blue: 0.36, alpha: 1),
        "orange": UIColor(red: 0.84, green: 0.57, blue: 0.23, alpha: 1),
        "pink": UIColor(red: 0.77, green: 0.45, blue: 0.83, alpha: 1),
        "yellow": UIColor(red: 0.97, green: 0.79, blue: 0.29, alpha: 1),
        "black": UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        "white": UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        "gray": UIColor(red: 0.84, green: 0.85, blue: 0.85, alpha: 1),
        "gold": UIColor(red: 0.73, green: 0.58, blue: 0.09, alpha: 1),
        "blue": UIColor(red: 0.29, green: 0.62, blue: 0.93, alpha: 1),
        "red": UIColor(red: 0.69, green: 0.1, blue: 0.1, alpha: 1),
    ]
    init() {
        let pdfMetaData = [
            kCGPDFContextCreator: "Voley stats",
            kCGPDFContextAuthor: "Voley stats"
          ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        self.page=pageRect
          // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        self.pdf = renderer
    }
    
    func header(info: String) -> Int{
        var y = 15
        addImage(x: 37, y: y, width: 100, height: 70, image: UIImage(named: "imagotipo")!)
        y += 10
        addText(x: Int(self.pageWidth)-(info.count*7+27), y: y, text: info, font: self.fonts["body"]!, color:UIColor.black)
        y+=25
        addShape(x: 27, y: y, width: Int(self.pageWidth-54), height: 1, shape: "rect", color: UIColor.black, fill: true)
        y+=5
        return y
    }
    
    func lastMonthReport(team: Team, startDate: Date, endDate: Date) -> PDF{
        self.title = "\(team.name)_report_\(Date().timeIntervalSince1970)"
        let stats = team.fullStats(startDate: startDate, endDate: endDate)
        var x = 27
        var y = header(info: "team.report".trad())
        
//        y+=10
        addText(x: x, y: y+10, text: "\(team.name) \("report".trad())".uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        y+=45
        
        
        addShape(x: x, y: y, width: Int(self.pageWidth-54), height: 100, shape: "rect", color: UIColor.gray.withAlphaComponent(0.2), fill: true)
        addImage(x: Int(self.pageWidth-47), y: y+6, width: 15, height: 15, image: UIImage(systemName: "info.circle")!)
        x+=10
        y+=20
        addText(x: x, y: y, text: "date.range".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        y+=15
        addText(x: x, y: y, text: "\(df.string(from: date))", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        y+=25
        addText(x: x, y: y, text: "\(df.string(from: Date()))", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        y-=40
        x+=175
        addText(x: x, y: y, text: "number.matches".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
        let matches = team.matches(startDate: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), endDate: Date())
        y+=15
        addText(x: x+50, y: y, text: "\(matches.count)", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        x+=175
        y-=15
        addText(x: x, y: y, text: "number.trainings".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
//        let trainings = Improve.dates().filter{$0 >= date}
        y+=15
        addText(x: x+50, y: y, text: "\(0)", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        x=27
        y+=75
        
        addText(x: x, y: y+10, text: "stats".trad().uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        let graphLen = Int(self.pageWidth/2) - 37
        y+=45
        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let atks = (stats["attack"]!["total"]!, stats["attack"]!["error"]!, stats["attack"]!["earned"]!)
        let atksLen = (atks.0 > 0 ? graphLen : 30, (atks.0 > 0 && atks.1 > 0) ? (graphLen*atks.1)/atks.0 : 30, (atks.0 > 0 && atks.2 > 0) ? (graphLen*atks.2)/atks.0 : 30)
        y+=25
        addShape(x: x, y: y, width: atksLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (atks.1 > 0){
            addText(x: x+atksLen.1-25, y: y+8, text: "\(atks.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: atksLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (atks.2 > 0){
            addText(x: x+atksLen.2-25, y: y+8, text: "\(atks.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: atksLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (atks.0 > 0){
            addText(x: x+atksLen.0-25, y: y+8, text: "\(atks.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let srv = (stats["serve"]!["total"]!, stats["serve"]!["error"]!, stats["serve"]!["earned"]!)
        let srvLen = (srv.0 > 0 ? graphLen : 30, (srv.0 > 0 && srv.1 > 0) ? (graphLen*srv.1)/srv.0 : 30, (srv.0 > 0 && srv.2 > 0) ? (graphLen*srv.2)/srv.0 : 30)
        y+=25
        addShape(x: x, y: y, width:  srvLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (srv.1 > 0){
            addText(x: x+srvLen.1-25, y: y+8, text: "\(srv.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: srvLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (srv.2 > 0){
            addText(x: x+srvLen.2-25, y: y+8, text: "\(srv.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: srvLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (srv.0 > 0){
            addText(x: x+srvLen.0-25, y: y+8, text: "\(srv.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "set".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let set = (stats["set"]!["total"]!, stats["set"]!["error"]!, stats["set"]!["earned"]!)
        let setLen = (set.0 > 0 ? graphLen : 30, (set.0 > 0 && set.1 > 0) ? (graphLen*set.1)/set.0 : 30, (set.0 > 0 && set.2 > 0) ? (graphLen*set.2)/set.0 : 30)
        y+=25
        addShape(x: x, y: y, width: setLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (set.1 > 0){
            addText(x: x+setLen.1-25, y: y+8, text: "\(set.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: setLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (set.2 > 0){
            addText(x: x+setLen.2-25, y: y+8, text: "\(set.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: setLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (set.0 > 0){
            addText(x: x+setLen.0-25, y: y+8, text: "\(set.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y-=385
        x=Int(self.pageWidth/2)
        addText(x: x+10, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let blk = (stats["block"]!["total"]!, stats["block"]!["error"]!, stats["block"]!["earned"]!)
        let blkLen = (blk.0 > 0 ? graphLen : 30, (blk.0 > 0 && blk.1 > 0) ? (graphLen*blk.1)/blk.0 : 30, (blk.0 > 0 && blk.2 > 0) ? (graphLen*blk.2)/blk.0 : 30)
        y+=25
        addShape(x: x, y: y, width: blkLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (blk.1 > 0){
            addText(x: x+blkLen.1-25, y: y+8, text: "\(blk.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: blkLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (blk.2 > 0){
            addText(x: x+blkLen.2-25, y: y+8, text: "\(blk.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: blkLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (blk.0 > 0){
            addText(x: x+blkLen.0-25, y: y+8, text: "\(blk.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let rcv = (stats["receive"]!["total"]!, stats["receive"]!["error"]!, stats["receive"]!["earned"]!)
        let rcvLen = (rcv.0 > 0 ? graphLen : 30, (rcv.0 > 0 && rcv.1 > 0) ? (graphLen*rcv.1)/rcv.0 : 30, (rcv.0 > 0 && rcv.2 > 0) ? (graphLen*rcv.2)/rcv.0 : 30)
        y+=25
        addShape(x: x, y: y, width: rcvLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (rcv.1 > 0){
            addText(x: x+rcvLen.1-25, y: y+8, text: "\(rcv.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: rcvLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (rcv.2 > 0){
            addText(x: x+rcvLen.2-25, y: y+8, text: "\(rcv.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: rcvLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (rcv.0 > 0){
            addText(x: x+rcvLen.0-25, y: y+8, text: "\(rcv.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "dig".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let dig = (stats["dig"]!["total"]!, stats["dig"]!["error"]!, stats["dig"]!["earned"]!)
        let digLen = (dig.0 > 0 ? graphLen : 30, (dig.0 > 0 && dig.1 > 0) ? (graphLen*dig.1)/dig.0 : 30, (dig.0 > 0 && dig.2 > 0) ? (graphLen*dig.2)/dig.0 : 30)
        y+=25
        addShape(x: x, y: y, width: digLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (dig.1 > 0){
            addText(x: x+digLen.1-25, y: y+8, text: "\(dig.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: digLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (dig.2 > 0){
            addText(x: x+digLen.2-25, y: y+8, text: "\(dig.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: digLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (dig.0 > 0){
            addText(x: x+digLen.0-25, y: y+8, text: "\(dig.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        return self
    }
    
    func statsReport(team: Team, match: Match) -> PDF{
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
        x+=100
        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=75
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
        x+=45
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
        x+=40
        addText(x: x, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        y+=22
        x=27
        let stats = match.stats()
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
                let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
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
        match.sets().forEach{set in
            players += 1
            let ps = stats.filter{s in return s.set == set.id && s.player != 0}
            addText(x: x, y: y, text: "\("totals".trad()) set \(set.number)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=110
            let gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
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
            let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
            addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=30
            // kills
            let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
            addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=40
            // blocks
            let blocks = ps.filter{s in return s.action==13}.count
            addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            y+=20
            x=77
        }
        addText(x: x, y: y, text: "\("match".trad()) \("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
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
        let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
        addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=30
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=40
        // blocks
        let blocks = ps.filter{s in return s.action==13}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x=27
        y+=45
        let (errx, erry) = self.errorTree(match: match, startX: x, startY: y)
        x = errx + 40
        (x, y) = self.matchCompare(match: match, startX: x, startY: y)
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
    
    func multiMatchReport(team: Team, matches: [Match]) -> PDF{
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
                let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
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
        let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
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
    
    func scoutingReport(scout: Scout, player: Int = 0) -> PDF {
        self.title = "\(scout.teamName)_scouting_\(Date().timeIntervalSince1970)"
        var stats = Scout.teamScouts(teamName: scout.teamName, related: scout.teamRelated)
        if player != 0{
            stats = stats.filter{$0.player==player}
        }
        var x = 27
        var y = header(info: player == 0 ? "scouting.report".trad() : "scouting".trad() + " " + scout.teamName)
        let positions = scout.rotation.filter{$0 != .zero}.count
//        y+=10
        if player != 0 {
            addText(x: x, y: y+10, text: "scouting".trad() + " #\(player)", font: self.fonts["title"]!, color:UIColor.black)
        } else {
            addText(x: x, y: y+10, text: "scouting".trad() + " " + scout.teamName, font: self.fonts["title"]!, color:UIColor.black)
        }
        y+=40
        if player == 0 {
            addText(x: x+240, y: y+10, text: "general.trends".trad(), font: self.fonts["headingBold"]!, color:UIColor.black)
            y+=30
        }
        //GENERAL SCOUTING
        var serve = [
            1: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            5: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            6: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ]
        ]
        stats.forEach{ s in
            if s.action == "serve" && s.difficulty != 0{
                serve[s.from]?[s.to]?.append(s)
            }
        }
        let maxSrv = serve.reduce(0){ max($0, $1.1.reduce(0){max($0, $1.1.count)})}
        addText(x: x+50, y: y+10, text: "serve".trad(), font: self.fonts["heading"]!, color:UIColor.black)
        y+=25
        addCourt(ix: x, iy: y, width: 150, positions: 9)
        
        y+=155
        addShape(x: x, y: y, width: 150, height: 5, shape: "rect", color: UIColor.black, fill: true)
        y+=10
        addCourt(ix: x, iy: y, width: 150, positions: positions)
        
        y+=155
        addShape(x: x, y: y, width: 150/3 - 3, height: 25, shape: "rect", color: UIColor.gray, fill: true)
        x += 150/3 + 1
        addShape(x: x, y: y, width: 150/3 - 3, height: 25, shape: "rect", color: UIColor.gray, fill: true)
        x += 150/3 + 1
        addShape(x: x, y: y, width: 150/3 - 3, height: 25, shape: "rect", color: UIColor.gray, fill: true)
        serve.forEach{from in
            let start = getFromToCoords(x: x-(150/3*2-2), y: y-155, width: 150, zone: from.key, positions: positions, action: "serve")
            from.value.forEach{to in
                let end = getFromToCoords(x: x-(150/3*2-2), y: y-320, width: 150, zone: to.key, positions: 9, action: "serve")
                if to.value.count > 0{
                    addShape(x: end.0, y: end.1, width: start.0, height: start.1, shape: "line", color: UIColor.red.withAlphaComponent(CGFloat(to.value.count)/CGFloat(maxSrv)), fill: false, radius: CGFloat(to.value.count)*5/CGFloat(maxSrv))
                }
            }
        }
        x+=200 - (150/3) * 2 - 4
        y-=345
        var atk = [
            1: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            2: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            3: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            4: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            5: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ],
            6: [
                1: [],
                2: [],
                3: [],
                4: [],
                5: [],
                6: [],
                7: [],
                8: [],
                9: []
            ]
        ]
        stats.forEach{ s in
            if s.action == "attack" && s.difficulty != 0 && s.to < 10{
                atk[s.from]?[s.to]?.append(s)
            }
        }
        let maxAtk = atk.reduce(0){ max($0, $1.1.reduce(0){max($0, $1.1.count)})}
        addText(x: x+50, y: y+10, text: "attack".trad(), font: self.fonts["heading"]!, color:UIColor.black)
        y+=25
        addCourt(ix: x, iy: y, width: 150, positions: 9)
        y+=155
        addShape(x: x, y: y, width: 150, height: 5, shape: "rect", color: UIColor.black, fill: true)
        y+=10
        addCourt(ix: x, iy: y, width: 150, positions: positions)
        atk.forEach{from in
            let start = getFromToCoords(x: x, y: y, width: 150, zone: from.key, positions: positions, action: "attack")
            from.value.forEach{to in
                let end = getFromToCoords(x: x, y: y-165, width: 150, zone: to.key, positions: 9, action: "attack")
                if to.value.count > 0{
                    addShape(x: end.0, y: end.1, width: start.0, height: start.1, shape: "line", color: UIColor.red.withAlphaComponent(CGFloat(to.value.count)/CGFloat(maxAtk)), fill: false, radius: CGFloat(to.value.count)*5/CGFloat(maxAtk))
                }
            }
        }
        
        x+=200
        y-=190
        
        var digs: Dictionary<Int,[Scout]> = [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ]
        stats.forEach{ s in
            if s.action == "dig"{
                digs[s.to]?.append(s)
            }
        }
        let maxDigs = digs.reduce(0){ max($0, $1.1.count)}
        addText(x: x+50, y: y+10, text: "dig".trad(), font: self.fonts["heading"]!, color:UIColor.black)
        y+=25
        addCourt(ix: x, iy: y, width: 150, positions: 9)
        addHeatmapCourt(ix: x, iy: y, width: 150, alpha: digs.sorted(by: { $0.0 < $1.0 }).map{s in
            let err = s.value.filter{$0.difficulty == 5}.count
            let tot = s.value.count
            return tot > 0 && err == 0 ? -1 : (tot > 0 ? CGFloat(err)/CGFloat(tot) : 0)
            
        })
        y+=165
        
        var rcv: Dictionary<Int,[Scout]> = [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ]
        stats.forEach{ s in
            if s.action == "receive"{
                rcv[s.to]?.append(s)
            }
        }
        let maxRcv = rcv.reduce(0){ max($0, $1.1.count)}
        addText(x: x+50, y: y+10, text: "receive".trad(), font: self.fonts["heading"]!, color:UIColor.black)
        y+=25
        addCourt(ix: x, iy: y, width: 150, positions: 9)
        addHeatmapCourt(ix: x, iy: y, width: 150, alpha: rcv.sorted(by: { $0.0 < $1.0 }).map{s in
            
            let err = s.value.filter{$0.difficulty == 5}.count
            let tot = s.value.count
            return tot > 0 && err == 0 ? -1 : (tot > 0 ? CGFloat(err)/CGFloat(tot) : 0)
            
        })
        x=27
        y+=180
        //USEFUL INFO
        if player == 0 {
            let bests = scout.teamInfo()
            addShape(x: x, y: y, width: Int(self.pageWidth-47), height: 270, shape: "rect", color: UIColor.gray.withAlphaComponent(0.2), fill: true)
            addImage(x: Int(self.pageWidth-47), y: y+10, width: 15, height: 15, image: UIImage(systemName: "info.circle")!)
            x+=25
            y+=15
            
//            var bestSrv = [
//                1: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                5: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                6: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ]
//            ]
//            stats.forEach{ s in
//                if s.action == "serve" && s.difficulty != 0 && s.player == bests["server"]!.0{
//                    bestSrv[s.from]?[s.to]?.append(s)
//                }
//            }
//            let maxBSrv = serve.reduce(0){ max($0, $1.1.reduce(0){max($0, $1.1.count)})}
//
//            addText(x: x, y: y+10, text: "best.serve".trad() + " (#\(bests["server"]!.0))", font: self.fonts["bodyBold"]!, color:UIColor.black)
//            y+=35
//            addCourt(ix: x, iy: y, width: 75, positions: 9)
//            y+=80
//            addShape(x: x, y: y, width: 75, height: 5, shape: "rect", color: UIColor.black, fill: true)
//            y+=10
//            addCourt(ix: x, iy: y, width: 75, positions: positions)
//
//            y+=80
//            addShape(x: x, y: y, width: 75/3 - 3, height: 15, shape: "rect", color: UIColor.gray, fill: true)
//            x += 75/3 + 1
//            addShape(x: x, y: y, width: 75/3 - 3, height: 15, shape: "rect", color: UIColor.gray, fill: true)
//            x += 75/3 + 1
//            addShape(x: x, y: y, width: 75/3 - 3, height: 15, shape: "rect", color: UIColor.gray, fill: true)
//
//            bestSrv.forEach{from in
//                let start = getFromToCoords(x: x-(75/3*2+2), y: y-80, width: 75, zone: from.key, positions: positions, action: "serve")
//                from.value.forEach{to in
//                    let end = getFromToCoords(x: x-(75/3*2+2), y: y-170, width: 75, zone: to.key, positions: 9, action: "serve")
//                    if to.value.count > 0{
//                        addShape(x: end.0, y: end.1, width: start.0, height: start.1, shape: "line", color: UIColor.red.withAlphaComponent(CGFloat(to.value.count)/CGFloat(maxBSrv)), fill: false, radius: CGFloat(to.value.count)*3/CGFloat(maxBSrv))
//                    }
//                }
//            }
//
//            y-=205
//            x += 80
//            var bestAtk = [
//                1: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                2: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                3: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                4: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                5: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ],
//                6: [
//                    1: [],
//                    2: [],
//                    3: [],
//                    4: [],
//                    5: [],
//                    6: [],
//                    7: [],
//                    8: [],
//                    9: []
//                ]
//            ]
//            stats.forEach{ s in
//                if s.action == "attack" && s.difficulty != 0 && s.player == bests["bestAtk"]!.0{
//                    bestAtk[s.from]?[s.to]?.append(s)
//                }
//            }
//            let maxBAtk = atk.reduce(0){ max($0, $1.1.reduce(0){max($0, $1.1.count)})}
//            addText(x: x, y: y+10, text: "best.attack".trad() + " (#\(bests["bestAtk"]!.0))", font: self.fonts["bodyBold"]!, color:UIColor.black)
//            y+=35
//            addCourt(ix: x, iy: y, width: 75, positions: 9)
//            y+=80
//            addShape(x: x, y: y, width: 75, height: 5, shape: "rect", color: UIColor.black, fill: true)
//            y+=10
//            addCourt(ix: x, iy: y, width: 75, positions: positions)
//            bestAtk.forEach{from in
//                let start = getFromToCoords(x: x, y: y, width: 75, zone: from.key, positions: positions, action: "attack")
//                from.value.forEach{to in
//                    let end = getFromToCoords(x: x, y: y-90, width: 75, zone: to.key, positions: 9, action: "attack")
//                    if to.value.count > 0{
//                        addShape(x: end.0, y: end.1, width: start.0, height: start.1, shape: "line", color: UIColor.red.withAlphaComponent(CGFloat(to.value.count)/CGFloat(maxBAtk)), fill: false, radius: CGFloat(to.value.count)*3/CGFloat(maxBAtk))
//                    }
//                }
//            }
//            y-=115
//            x+=120
//
//            addShape(x: x, y: y, width: 120, height: 30, shape: "rect", color: UIColor.white.withAlphaComponent(0.4), fill: true)
//            addText(x: x+10, y: y+7, text: "best.block".trad() + ": #\(bests["blocker"]!.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//            y+=40
//            addShape(x: x, y: y, width: 120, height: 30, shape: "rect", color: UIColor.white.withAlphaComponent(0.4), fill: true)
//            addText(x: x+10, y: y+7, text: "best.receiver".trad() + ": #\(bests["bestRcv"]!.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//            y+=40
//            addShape(x: x, y: y, width: 120, height: 30, shape: "rect", color: UIColor.white.withAlphaComponent(0.4), fill: true)
//            addText(x: x+10, y: y+7, text: "worst.receiver".trad() + ": #\(bests["worstRcv"]!.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//            y-=80
//            x+=140
            addText(x: x, y: y, text: "initial.rotation".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
            y+=20
            x+=10
            addCourt(ix: x, iy: y, width: 75, positions: positions)
            for i in 1...positions{
                let pos = getFromToCoords(x: x, y: y, width: 75, zone: i, positions: positions, action: "rotation")
                addText(x: pos.0-4, y: pos.1-6, text: "\(scout.rotation[i-1])", font: self.fonts["body"]!, color: UIColor.black)
            }
            x+=120
            y-=20
            addText(x: x, y: y, text: "best.rotation.stats".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
            y+=20
            x+=5
            addCourt(ix: x, iy: y, width: 75, positions: positions)
            let bestRot = scout.bestRotation()
            for i in 1...positions{
                let pos = getFromToCoords(x: x, y: y, width: 75, zone: i, positions: positions, action: "rotation")
                addText(x: pos.0-4, y: pos.1-6, text: "\(bestRot.0[i-1])", font: self.fonts["body"]!, color: UIColor.black)
            }
            y+=100
            x-=115
            addText(x: x, y: y, text: "comments".trad(), font: self.fonts["body"]!, color: UIColor.black)
            y+=15
            for comment in scout.comments(){
                addText(x: x, y: y, text: "\(comment.comment)", font: self.fonts["caption"]!, color: UIColor.black)
                y+=10
            }
            self.newPage()
            var x = 27
            var y = header(info: "scouting.report".trad())
            addText(x: x, y: y+10, text: "players.rank.by.area".trad(), font: self.fonts["title"]!, color:UIColor.black)
            y+=60
            for area in scout.playersRank(){
                addText(x: x, y: y, text: area.key.trad(), font: self.fonts["headingBold"]!, color:UIColor.black)
                y+=20
                addText(x: x, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=125
                addText(x: x, y: y, text: "Tot", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=100
                addText(x: x, y: y, text: "Err", font: self.fonts["bodyBold"]!, color:UIColor.black)
                x+=100
                addText(x: x, y: y, text: "Pts", font: self.fonts["bodyBold"]!, color:UIColor.black)
                y+=10
                x=27
                for player in area.value{
                    addText(x: x, y: y, text: "#" + player.0.description, font: self.fonts["body"]!, color:UIColor.black)
                    x+=125
                    addText(x: x, y: y, text: player.2.description, font: self.fonts["body"]!, color:UIColor.black)
                    x+=100
                    addText(x: x, y: y, text: player.3.description, font: self.fonts["body"]!, color:UIColor.black)
                    x+=100
                    addText(x: x, y: y, text: player.4.description, font: self.fonts["body"]!, color:UIColor.black)
                    y+=10
                    x=27
                }
                y+=30
            }
        }
        return self
    }
    
    func fullScoutingReport(scout: Scout) -> PDF{
        scoutingReport(scout: scout)
        for player in scout.getPlayers(){
            self.newPage()
            scoutingReport(scout: scout, player: player)
            
        }
        return self
    }
    
    func playerReport(player:Player, data: Dictionary<String,Dictionary<String,Float>>, startDate: Date, endDate: Date, feedBack: String) -> PDF{
        self.title = "\(player.name)_report_\(Date().timeIntervalSince1970)"
//        let stats = player.stats()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        var x = 27
        var y = header(info: "player.report".trad())
        addText(x: x, y: y+10, text: player.name.uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        
        y+=55
        var width = Int(self.pageWidth)-40
        addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: self.colors["gray"]!.withAlphaComponent(0.3), fill: true)
        y+=10
        x+=15
//        addShape(x: x, y: y, width: 120, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
        y+=10
//        addText(x: x, y: y, text: "date.range".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 120, alignment: .center)
        y += 20
//        addText(x: x, y: y, text: "\(df.string(from: startDate))", font: self.fonts["heading"]!, color:UIColor.black, width: 120, alignment: .center)
        y += 20
//        addText(x: x, y: y, text: "\(df.string(from: endDate))", font: self.fonts["heading"]!, color:UIColor.black, width: 120, alignment: .center)
        
        y -= 50
        x += 130
        addShape(x: x, y: y, width: 140, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
        y+=10
        addText(x: x, y: y, text: "position".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 140, alignment: .center)
        y += 25
        addText(x: x, y: y, text: "\(player.position.rawValue.trad())", font: self.fonts["heading"]!, color:UIColor.black, width: 140, alignment: .center)
        x += 150
        y -= 35
//        let matchCount = Swift.Set(stats.map({$0.match})).count
//        let setCount = Swift.Set(stats.map({$0.set})).count
        addShape(x: x, y: y, width: 120, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
        y+=10
        addText(x: x, y: y, text: "match.played".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 120, alignment: .center)
        y += 25
        addText(x: x, y: y, text: "\(String(format: "%.0f", data["general"]!["matches"]!))", font: self.fonts["heading"]!, color:UIColor.black, width: 120, alignment: .center)
        y-=35
        x+=130
        addShape(x: x, y: y, width: 120, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
        y+=10
        addText(x: x, y: y, text: "set.played".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 120, alignment: .center)
        y += 25
        addText(x: x, y: y, text: "\(String(format: "%.0f", data["general"]!["sets"]!))", font: self.fonts["heading"]!, color:UIColor.black, width: 120, alignment: .center)
        y+=90
        x=27
        //serve data
        
//        let serves = stats.filter{s in return s.server == player.id && s.stage == 0}
//        let serveTot = serves.filter{ s in s.to != 0}.count
//        let aces = serves.filter{s in return s.action==8}.count
//        let serve1 = serves.filter{s in return s.action==39}.count
//        let serve2 = serves.filter{s in return s.action==40}.count
//        let serve3 = serves.filter{s in return s.action==41}.count
//        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
//        let serveMark = serveTot == 0 ? 0.00 : Float(serve1/2 + serve2 + 2*serve3 + 3*aces)/Float(serveTot)
        var bg = data["serve"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["serve"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
        width = Int(self.pageWidth/2)-25
        addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
        y+=5
        addText(x: x+15, y: y, text: "serve".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width)
        addText(x: x-15, y: y, text: "\(String(format: "%.2f", data["serve"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
        y+=35
        x+=15
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["serve"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "ace.short".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["serve"]!["ace"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "++".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["serve"]!["++"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "-".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["serve"]!["-"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["serve"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        
        y-=40
        x=Int(self.pageWidth/2)+10
        width = Int(self.pageWidth/2)-25
//        let rcv = stats.filter{s in return [1, 2, 3, 4, 22].contains(s.action) && s.player == player.id}
//        let Rerr = rcv.filter{s in return s.action==22}.count
//        let op = rcv.filter{s in return s.action==1}.count
//        let s1 = rcv.filter{s in return s.action==2}.count
//        let s2 = rcv.filter{s in return s.action==3}.count
//        let s3 = rcv.filter{s in return s.action==4}.count
//        let mark = rcv.count == 0 ? 0.00 : Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count)
        bg = data["receive"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["receive"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
        addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
        
        y+=10
        addText(x: x+15, y: y, text: "receive".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
        addText(x: x-15, y: y, text: "\(String(format: "%.2f", data["receive"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
        y+=30
        x+=15
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["receive"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "++".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["receive"]!["++"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "+".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["receive"]!["+"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "-".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["receive"]!["-"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["receive"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        
        x=27
        y+=80
        width = 220
//        let atk = stats.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action) && s.player == player.id}
//        let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action) && s.detail.lowercased() != "block"}.count
//        let blocked = atk.filter{s in return [16, 17, 18, 19].contains(s.action) && s.detail.lowercased() == "block"}.count
//        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
//        let atkMark = atk.count > 0 ? Float(kills*3)/Float(atk.count) : 0.00
        bg = data["attack"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["attack"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
        addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
        
        y+=10
        addText(x: x+15, y: y, text: "attack".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
        addText(x: x-15, y: y, text: "\(String(format: "%.2f", data["attack"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
        y+=30
        x+=15
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["attack"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "kills".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["attack"]!["kill"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "block".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["attack"]!["block"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["attack"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        
        y-=40
        x=255
        width = 170
//        let blocks = stats.filter{s in return [7, 13, 20, 31].contains(s.action) && s.player == player.id}
//        let blocksEarn = blocks.filter{s in return s.action==13}.count
//        let blockErr = blocks.filter{s in return [20, 31].contains(s.action)}.count
//        let blockMark = blocks.count > 0 ? Float(blocksEarn*3)/Float(blocks.count) : 0.00
        bg = data["block"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["block"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
        addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
        
        y+=10
        addText(x: x+15, y: y, text: "block".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
        addText(x: x-15, y: y, text: "\(String(format: "%.2f",data["block"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
        y+=30
        x+=15
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["block"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "points".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["block"]!["points"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=50
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["block"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        
        y-=40
        x=430
        width = 150
        
//        let dig = stats.filter{s in return [23, 5, 21].contains(s.action) && s.player == player.id}
//        let digErr = dig.filter{s in return [23, 21].contains(s.action)}.count
//        let digMark = dig.count > 0 ? (Float(dig.count-digErr)*3)/Float(dig.count) : 0.00
        bg = data["dig"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["dig"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
        addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
        
        y+=10
        addText(x: x+10, y: y, text: "dig".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
        addText(x: x-10, y: y, text: "\(String(format: "%.2f",data["dig"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
        y+=30
        x+=15
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["dig"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=70
        addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
        addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
        addText(x: x, y: y+20, text: "\(Int(data["dig"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
        
        y+=80
        x=27
        if feedBack.count > 0{
            addText(x: x, y: y, text: "comments".trad().uppercased(), font: self.fonts["title3"]!, color:UIColor.black)
            y+=35
            addText(x: x, y: y, text: feedBack, font: self.fonts["body"]!, color:UIColor.black, width: Int(self.pageWidth)-50)
        }
        return self
    }
    
    func errorTree(match: Match, startX: Int, startY: Int)->(Int, Int){
        let data = match.getErrorTree()
        var x = startX
        var y = startY
        self.addText(x: x, y: y, text: "error.tree".trad().uppercased(), font: PDFonts.bodyBold, color: Colors.black, width: 250, alignment: .center)
        y+=30
        self.addText(x: x, y: y, text: "us".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 125, alignment: .left)
        x += 125
        self.addText(x: x, y: y, text: "them".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 125, alignment: .right)
        y += 25
        data.sorted(by: {$0.key < $1.key}).forEach{area in
            x=startX
            self.addText(x: x, y: y, text: "\(area.value.0)", font: PDFonts.body, color: Colors.black, width: 50, alignment: .left)
            x+=50
            self.addText(x: x, y: y, text: "\(area.key.split(separator: ".")[1])".trad().capitalized, font: PDFonts.body, color: Colors.black, width: 150, alignment: .center)
            x+=150
            self.addText(x: x, y: y, text: "\(area.value.1)", font: PDFonts.body, color: Colors.black, width: 50, alignment: .right)
            x+=50
            y+=20
        }
        self.addShape(x: startX-10, y: startY-10, width: x-startX+20, height: y-startY+10, shape: "rect", color: Colors.black, fill: false)
        return (x, y)
    }
    
    func matchCompare(match: Match, startX: Int, startY: Int)->(Int, Int){
        var x = startX
        var y = startY
        let data = match.compareMatches()
        self.addText(x: x, y: y, text: "match.compare".trad().uppercased(), font: PDFonts.bodyBold, color: Colors.black, width: 250, alignment: .center)
        y+=30
        x+=30
        self.addText(x: x, y: y, text: "area".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 100, alignment: .left)
        x += 100
        self.addText(x: x, y: y, text: "actual".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 60, alignment: .center)
        x += 60
        self.addText(x: x, y: y, text: "previous".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 60, alignment: .center)
        y+=25
        data.sorted(by: {$0.key < $1.key}).forEach{area in
            x=startX
            if area.value.0 > area.value.1{
                self.addShape(x: x-1, y: y-1, width: 18, height: 18, shape: "rect", color: Colors.green, fill: true, radius: 9)
                self.addImage(x: x, y: y, width: 16, height: 16, image: UIImage(systemName: "arrow.up.circle")!)
                
            }else if area.value.0 < area.value.1{
                self.addShape(x: x-1, y: y-1, width: 18, height: 18, shape: "rect", color: Colors.red, fill: true, radius: 9)
                self.addImage(x: x, y: y, width: 16, height: 16, image: UIImage(systemName: "arrow.down.circle")!)
                
            }else{
                self.addShape(x: x-1, y: y-1, width: 18, height: 18, shape: "rect", color: Colors.gray, fill: true, radius: 9)
                self.addImage(x: x, y: y, width: 16, height: 16, image: UIImage(systemName: "equal.circle")!)
                
            }
            x+=30
            self.addText(x: x, y: y, text: "\(area.key.split(separator: "-")[1])".trad().capitalized, font: PDFonts.body, color: Colors.black, width: 100, alignment: .left)
            x+=100
            self.addText(x: x, y: y, text: "\(area.value.0.formatted(.number.precision(.fractionLength(2))))", font: PDFonts.body, color: Colors.black, width: 60, alignment: .center)
            x+=60
            self.addText(x: x, y: y, text: "\(area.value.1.formatted(.number.precision(.fractionLength(2))))", font: PDFonts.body, color: Colors.black, width: 60, alignment: .center)
            x+=60
            y+=25
        }
        self.addShape(x: startX-10, y: startY-10, width: x-startX+20, height: y-startY+10, shape: "rect", color: Colors.black, fill: false)
        return (x, y)
    }
    
    func getFromToCoords(x:Int, y: Int, width: Int, zone: Int, positions: Int, action: String)->(Int, Int){
        var coords = (0,0)
        switch (zone){
            case 1:
            if action == "serve"{
                    coords = (x+width-width/6,y+width+width/8)
            }else{
                if positions == 4 {
                    coords = (x+width/2,y+width-width/8)
                }
                if positions == 6 {
                    coords = (x+width-width/6,y+width-width/6)
                }
            }
            if positions == 9 {
                coords = (x+width/6,y+width/6)
            }
                break
            case 2:
                if positions == 4 {
                    coords = (x+width-width/4,y+width/2)
                }
                if positions == 6 {
                    coords = (x+width-width/6,y+width/6)
                }
            
            if positions == 9 {
                coords = (x+width/6,y+width-width/6)
            }
                
                break
            case 3:
                if positions == 4 {
                    coords = (x+width/2,y+width/8)
                }
                if positions == 6 {
                    coords = (x+width/2+width/8,y+width/6)
                }
            
                if positions == 9 {
                    coords = (x+width/2,y+width-width/6)
                }
                break
            case 4:
                if positions == 4 {
                    coords = (x+width/4,y+width/2)
                }
                if positions == 6 {
                    coords = (x+width/6,y+width/6)
                }
            
                if positions == 9 {
                    coords = (x+width-width/6,y+width-width/6)
                }
                break
            case 5:
            if action == "serve"{
                    coords = (x+width/6,y+width+width/8)
                
            }else{
                if positions == 4 {
                    coords = (x,y+width-width/6)
                }
                if positions == 6 {
                    coords = (x+width/8,y+width-width/8)
                }
            }
                if positions == 9 {
                    coords = (x+width-width/6,y+width/6)
                }
                break
            case 6:
            if action == "serve"{
                    coords = (x+width/2,y+width+width/8)
            }else{
                if positions == 4 {
                    coords = (x+width/2,y+width-width/8)
                }
                if positions == 6 {
                    coords = (x+width/2,y+width-width/6)
                }
            }
            if positions == 9 {
                coords = (x+width/2,y+width/6)
            }
                
                break
            case 7:
                coords = (x+width-width/6,y+width/2)
                break
            case 8:
                coords = (x+width/2,y+width/2)
                break
            case 9:
                coords = (x+width/6,y+width/2)
                break
            default:
                coords = (0,0)
        }
        return coords
    }
    
    func addCourt(ix:Int, iy: Int, width: Int, positions: Int){
        var x = ix
        var y = iy
        if positions == 4{
            addShape(x: x, y: y, width: width, height: width/4 - 2, shape: "rect", color: UIColor.orange, fill: true)
            y += width/4 + 2
            addShape(x: x, y: y, width: width/2 - 2, height: width/2 - 2, shape: "rect", color: UIColor.orange, fill: true)
            x += width/2 + 2
            addShape(x: x, y: y, width: width/2 - 2, height: width/2 - 2, shape: "rect", color: UIColor.orange, fill: true)
            x = ix
            y += width/2 + 2
            addShape(x: x, y: y, width: width, height: width/4 - 2, shape: "rect", color: UIColor.orange, fill: true)
        }
        if positions == 6{
            addShape(x: x, y: y, width: width/3 - 2, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 2
            addShape(x: x, y: y, width: width/3 - 2, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 2
            addShape(x: x, y: y, width: width/3 - 2, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x = ix
            y += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 2, height: (width/3)*2 - 2, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 2
            addShape(x: x, y: y, width: width/3 - 2, height: (width/3)*2 - 2, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 2
            addShape(x: x, y: y, width: width/3 - 2, height: (width/3)*2 - 2, shape: "rect", color: UIColor.orange, fill: true)
        }
        if positions == 9{
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x = ix
            y += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x = ix
            y += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
            x += width/3 + 1
            addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: UIColor.orange, fill: true)
        }
    }
    
    func addHeatmapCourt(ix:Int, iy: Int, width: Int, alpha: [CGFloat]){
        var x = ix
        var y = iy
        
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[3] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[3]), fill: true)
        x += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[2] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[2]), fill: true)
        x += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[1] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[1]), fill: true)
        x = ix
        y += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[6] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[6]), fill: true)
        x += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[7] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[7]), fill: true)
        x += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[8] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[8]), fill: true)
        x = ix
        y += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[4] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[4]), fill: true)
        x += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[5] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[5]), fill: true)
        x += width/3 + 1
        addShape(x: x, y: y, width: width/3 - 3, height: width/3 - 3, shape: "rect", color: alpha[0] < 0 ? UIColor.green : UIColor.red.withAlphaComponent(alpha[0]), fill: true)
        
    }
    
    func addImage(x:Int, y:Int, width:CGFloat, height:CGFloat, image:UIImage){
//        let maxHeight = self.page.height * 0.4
//        let maxWidth = self.page.width * 0.8
          // 2
          let aspectWidth = width / image.size.width
          let aspectHeight = height / image.size.height
          let aspectRatio = min(aspectWidth, aspectHeight)
          // 3
          let scaledWidth = image.size.width * aspectRatio
          let scaledHeight = image.size.height * aspectRatio
          // 4
//            let imageX = (self.page.width - scaledWidth) / 2.0
        
          let imageRect = CGRect(x: x, y: y, width: Int(scaledWidth), height: Int(scaledHeight))
          self.elements.append(PDFElement(x: x, y: y, data: image, rect: imageRect))
          // 5
//          image.draw(in: imageRect)
//          return imageRect.origin.y + imageRect.size.height
    }
    
    func addText(x:Int, y:Int, text: String, font: UIFont, color:UIColor, width: Int? = nil, alignment: NSTextAlignment = .left){
        self.elements.append(PDFElement(x: x, y: y, data: text, font: font, color: color, width: width, alignment: alignment))
    }
    
    func addShape(x: Int, y:Int, width:Int, height:Int, shape:String, color: UIColor, fill: Bool, radius:CGFloat = 6){
        self.elements.append(PDFElement(x: x, y: y, width: width, height: height, shape: shape, color: color, fill: fill, radius:radius))
    }
    
    func newPage(){
        self.elements.append(PDFElement())
    }
    
    func drawShape(x: Int, y:Int, width:Int, height:Int, shape:String, color: UIColor, fill: Bool, radius:CGFloat, context:UIGraphicsPDFRendererContext){
        if shape == "rect" {
            if fill {
//                context.stroke(self.pdf.format.bounds)
//                color.setFill()
//                context.fill(CGRect(x: x, y: y, width: width, height: height))
                let rect = CGRect(x: x, y: y, width: width, height: height)
                context.cgContext.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
                context.cgContext.setFillColor(color.cgColor)
                context.cgContext.closePath()
                context.cgContext.fillPath()
            } else{
                let rect = CGRect(x: x, y: y, width: width, height: height)
                context.cgContext.addRect(rect)
                context.cgContext.setStrokeColor(color.cgColor)
                context.cgContext.drawPath(using: .stroke)
            }
            
        }
        if shape == "line" {
            context.cgContext.setStrokeColor(color.cgColor)
            context.cgContext.setLineWidth(radius)
            context.cgContext.setLineCap(.round)

            context.cgContext.move(to: CGPoint(x: x, y: y))
            context.cgContext.addLine(to: CGPoint(x: width, y: height))
            context.cgContext.drawPath(using: .stroke)
        }
    }
    
    func generate() -> URL {
        let data = self.pdf.pdfData { (context) in
            // 5
            context.beginPage()
            // 6
            self.elements.forEach{el in
                if el.type == "image" {
                    el.image!.draw(in: el.rect!)
                } else if el.type == "shape" {
                    self.drawShape(x: el.x, y: el.y, width: el.width!, height: el.height!, shape: el.shape!, color: el.color!, fill: el.fill, radius: el.radius,  context: context)
                    context.cgContext.setStrokeColor(UIColor.white.cgColor)
                } else if el.type == "newPage" {
                    context.beginPage()
                } else {
                    let pStyle = NSMutableParagraphStyle()
                    pStyle.alignment = el.alignment!
                    let attributes = [
                        NSAttributedString.Key.font: el.font!,
                        NSAttributedString.Key.foregroundColor: el.color!,
                        NSAttributedString.Key.paragraphStyle: pStyle
                    ]
                    el.text!.draw(in: CGRect(x: el.x, y: el.y, width: el.width ?? Int(self.pageWidth)-50, height: Int(self.pageHeight)-30), withAttributes: attributes)
//                    el.text!.draw(at: CGPoint(x: el.x, y: el.y), withAttributes: attributes)
                }
                
            }
        }
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(title).pdf")
        else { fatalError("Destination URL not created") }
//        do{
//            try FileManager.default.createDirectory(atPath: outputURL.path, withIntermediateDirectories: true)
            
            PDFDocument(data: data)?.write(to: outputURL)
            
//        } catch {
//            print("Report not created")
//        }
        return outputURL
    }
}
