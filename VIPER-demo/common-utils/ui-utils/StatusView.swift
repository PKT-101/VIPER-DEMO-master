//
//  SharedViews.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import SwiftUI

class OperationStatus: ObservableObject {
    @Published var status: String
    
    init(status: String = "") {
        self.status = status
    }
}

struct StatusView : View {
    
    @ObservedObject var viewModel: OperationStatus
    init(viewModel: OperationStatus) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(viewModel.status)")
                    .font(.custom(
                        "AmericanTypewriter",
                        fixedSize: 14)
                        .weight(.heavy)
                    )
                    .foregroundColor(Color.red)
                    .lineLimit(1)
                    .blinking(duration: 1.0)
                Spacer()
            }
            Spacer()
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        ).background(Color.yellow)
    }
}

#Preview {
    StatusView(viewModel: OperationStatus(status: "Fetching genres"))
}
