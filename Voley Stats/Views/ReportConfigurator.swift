import SwiftUI
import UIPilot

struct ReportConfigurator: View {
    var team: Team
    var match:Match
    var fileUrl:Binding<URL?>
    var show: Binding<Bool>
    @State var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @State var actualLang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @State var pointLog: Bool = false
    @State var receiveDetail: Bool = false
    @State var serveDetail: Bool = false
    @State var attackDetail: Bool = false
    @State var matchCompare: Bool = false
    @State var errorTree: Bool = false
    @State var countHidden: Bool = true

    var body: some View {
        VStack {
            Text("report. configurator".trad()).font(.title).padding(.bottom)
            VStack{
                Text("language".trad()).font(.title2).padding(.bottom)
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(lang == "es" ? .blue : .gray)
                        Text("spanish".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        lang = "es"
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(lang == "en" ? .blue : .gray)
                        Text("english".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        lang = "en"
                    }
                }
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxHeight: 150).padding()
            VStack{
                Text("sections".trad()).font(.title2).padding(.bottom)
                Toggle("error.tree".trad(), isOn: $errorTree)
                Divider().overlay(.gray).padding(.vertical)
                Toggle("match.compare".trad(), isOn: $matchCompare)
                Divider().overlay(.gray).padding(.vertical)
                Toggle("attack.detail".trad(), isOn: $attackDetail)
                Divider().overlay(.gray).padding(.vertical)
                Toggle("serve.detail".trad(), isOn: $serveDetail)
                Divider().overlay(.gray).padding(.vertical)
                Toggle("receive.detail".trad(), isOn: $receiveDetail)
                Divider().overlay(.gray).padding(.vertical)
                Toggle("point.log".trad(), isOn: $pointLog)
                Divider().overlay(.gray).padding(.vertical)
                Toggle("hidden.count".trad(), isOn: $countHidden)
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
            ZStack{
                RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.blue)
                Text("generate".trad()).foregroundColor(.white).padding(5)
            }.clipped().onTapGesture {
                UserDefaults.standard.set(lang, forKey: "locale")
                var sections:[ReportSections] = []
                if errorTree {
                    sections.append(ReportSections.errorTree)
                }
                if pointLog {
                    sections.append(ReportSections.pointLog)
                }
                if matchCompare {
                    sections.append(ReportSections.matchCompare)
                }
                if receiveDetail {
                    sections.append(ReportSections.receiveDetail)
                }
                if serveDetail {
                    sections.append(ReportSections.serveDetail)
                }
                if attackDetail {
                    sections.append(ReportSections.attackDetail)
                }
                if countHidden {
                    sections.append(.hiddenCount)
                }
                fileUrl.wrappedValue = Report(team:team, match: match, sections: sections).generate()
                UserDefaults.standard.set(actualLang, forKey: "locale")
                show.wrappedValue.toggle()
            }.frame(maxHeight: 100).padding()
        }
//        .frame(maxHeight: .infinity, alignment: .top)
//        .background(Color.swatch.dark.high).foregroundColor(.white)
    }
    
}


