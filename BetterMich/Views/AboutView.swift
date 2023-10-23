//
//  AboutView.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/23.
//

import SwiftUI

struct AboutView: View {
            
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationStack {
            ScrollView {
   
                Image(.taiwanMich)
                    .resizable()
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.secondary, lineWidth: 1.8)
                    )
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)
                
                Text("米台目")
                    .font(.largeTitle)
                    .padding(.bottom, 2)

                
                Text("Version 1.0")
                    .font(.subheadline)
                
                Divider().padding()
                
                Text("圖例")
                    .font(.title)
                
                VStack(alignment: .leading) {
                    HStack {
                        DistinctionView(distinction: 3, bibendum: false, sustainable: false)
                        Spacer()
                        Text("三星")
                    }
                    HStack {
                        DistinctionView(distinction: 2, bibendum: false, sustainable: false)
                        Spacer()
                        Text("二星")
                    }
                    HStack {
                        DistinctionView(distinction: 1, bibendum: false, sustainable: false)
                        Spacer()
                        Text("一星")
                    }
                    
                    HStack {
                        Image(.greenstar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 17, height: 12)
                        Spacer()
                        Text("綠星")
                    }
                    HStack {
                        DistinctionView(distinction: 0, bibendum: true, sustainable: false)
                        Spacer()
                        Text("必比登")
                    }
                    HStack {
                        DistinctionView(distinction: 0, bibendum: false, sustainable: false)
                        Spacer()
                        Text("推薦")
                    }
                }
                .frame(maxWidth: 138)
                
                Divider().padding()

                Text("本 App 所提供的所有資訊皆來自：")
                    .font(.subheadline)
                    .padding(.bottom, 3)
                
                Link("台灣米其林官網", destination: URL(string: "https://guide.michelin.com/tw/zh_TW/selection/taiwan/restaurants")!)
                    .font(.headline)
                
                Spacer()
                
            }
            .navigationBarItems(trailing: Button("完成") {
                dismiss()
            })
        }

    }
    
}

#Preview {
    AboutView()
}
