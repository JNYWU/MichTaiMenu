import SwiftUI


// input distinction, bibendum, and sustainable then show corresponding icons
struct DistinctionView: View {
    
    var distinction: Int
    var bibendum: Bool
    var sustainable: Bool
    
    var body: some View {
        HStack {
            switch distinction {
            case 1:
                Image("1star")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 12)
                
            case 2:
                Image("2stars")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 12)
                
            case 3:
                Image("3stars")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 12)
                
            case 0:
                if bibendum == true {
                    Image("bib")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 17, height: 12)
                } else {
                    Image("plate")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 21, height: 12)
                }
                
            default:
                Image("plate")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 12)
            }
            
            if sustainable {
                Image("greenstar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 17, height: 12)
            }
        }
    }
}

#Preview {
    DistinctionView(distinction: 1, bibendum: false, sustainable: true)
}

