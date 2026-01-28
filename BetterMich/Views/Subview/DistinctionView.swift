import SwiftUI


// input distinction, bibendum, and sustainable then show corresponding icons
struct DistinctionView: View {
    
    var distinction: Int
    var bibendum: Bool
    var sustainable: Bool
    var showOnlySustainable: Bool = false
    var tintColor: Color
    var sustainableTint: Color
    
    init(distinction: Int, bibendum: Bool, sustainable: Bool, showOnlySustainable: Bool = false, tintColor: Color = .red, sustainableTint: Color = .green) {
        self.distinction = distinction
        self.bibendum = bibendum
        self.sustainable = sustainable
        self.showOnlySustainable = showOnlySustainable
        self.tintColor = tintColor
        self.sustainableTint = sustainableTint
    }
    
    init(sustainableOnly: Bool, sustainableTint: Color = .green) {
        self.distinction = 0
        self.bibendum = false
        self.sustainable = sustainableOnly
        self.showOnlySustainable = true
        self.tintColor = .red
        self.sustainableTint = sustainableTint
    }
    
    var body: some View {
        HStack(spacing: 7) {
            if showOnlySustainable {
                if sustainable {
                    Image("mich.greenstar")
                        .foregroundColor(sustainableTint)
                }
            } else {
                switch distinction {
                case 1:
                    Image("mich.star")
                        .foregroundStyle(tintColor)
                    
                case 2:
                    HStack {
                        Image("mich.star")
                            .foregroundStyle(tintColor)
                            .padding(.trailing, -9)
                        Image("mich.star")
                            .foregroundStyle(tintColor)
                    }
                    
                case 3:
                    HStack {
                        Image("mich.star")
                            .foregroundStyle(tintColor)
                            .padding(.trailing, -9)

                        Image("mich.star")
                            .foregroundStyle(tintColor)
                            .padding(.trailing, -9)

                        Image("mich.star")
                            .foregroundStyle(tintColor)
                    }
                    
                case 0:
                    if bibendum == true {
                        Image("mich.bibendum")
                            .foregroundStyle(tintColor)
                    } else {
                        Image("mich.plate")
                            .foregroundStyle(tintColor)
                    }
                    
                default:
                    Text("")
                }
                
                if sustainable {
                    Image("mich.greenstar")
                        .foregroundColor(sustainableTint)
                        .padding(.leading, -3)
                }
            }
        }
        .padding(.leading, -2)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        DistinctionView(distinction: 3, bibendum: false, sustainable: false)
        DistinctionView(distinction: 2, bibendum: false, sustainable: false)
        DistinctionView(distinction: 1, bibendum: false, sustainable: true)
        DistinctionView(distinction: 0, bibendum: true, sustainable: true)
        DistinctionView(distinction: 0, bibendum: false, sustainable: true)
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .clipShape(.rect(cornerRadius: 20))
}

