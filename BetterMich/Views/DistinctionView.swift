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
                Image(.star)
                    .foregroundStyle(.red)
                
            case 2:
                HStack {
                    Image(.star)
                        .foregroundStyle(.red)
                        .padding(.trailing, -9)
                    Image(.star)
                        .foregroundStyle(.red)
                }
                
            case 3:
                HStack {
                    Image(.star)
                        .foregroundStyle(.red)
                        .padding(.trailing, -9)

                    Image(.star)
                        .foregroundStyle(.red)
                        .padding(.trailing, -9)

                    Image(.star)
                        .foregroundStyle(.red)
                }
                
            case 0:
                if bibendum == true {
                    Image(.bibendum)
                        .foregroundStyle(.red)
                    
                } else {
                    Image(.plate)
                        .foregroundStyle(.red)
                }
                
            default:
                Text("")
            }
            
            if sustainable {
                Image(.greenstar)
                    .foregroundColor(.green)
            }
        }
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
}

