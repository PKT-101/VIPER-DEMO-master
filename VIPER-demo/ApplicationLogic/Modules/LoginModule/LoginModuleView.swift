//
//  LoginModuleView.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import UIKit
import SwiftUI

extension LoginModule: LoginModuleViewRenderer {
    
    func renderView() {
        let view = UIHostingController(rootView: LoginModuleView(eventsHandler: self.eventsHandler!)).view
        view?.frame = UIScreen.main.bounds
        self.view.addSubview(view!)
    }
}

struct LoginModuleView: View {
    //@ObservedObject var viewModel: LoginViewModel
    var eventsHandler: LoginModuleEventsHandler
    
    /*init(viewModel: LoginViewModel, eventsHandler: LoginModuleEventsHandler) {
        //self.viewModel = viewModel
        self.eventsHandler = eventsHandler
    }*/
    
    var body : some View {
        HStack {
            Spacer()
            VStack {
                Spacer().frame(height: 150)
                Text("TM DB")
                    .font(.custom(
                        "AmericanTypewriter",
                        fixedSize: 34)
                        .weight(.heavy)
                    )
                    .foregroundColor(Color.red)
                    .lineLimit(1)
                Spacer().frame(height: 250)
                HStack {
                    Spacer()
                    Button {
                        eventsHandler.executeLogin()
                    } label: {
                        Text("Login")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(minWidth: 150)
                            .background(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button {
                        eventsHandler.useAsGuest()
                    } label: {
                        Text("Guest")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(minWidth: 150)
                            .background(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                Spacer().frame(height: 150)
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
    //let loginViewModel =
    //loginViewModel.buttonsDisbled = true
    LoginModuleView(eventsHandler: LoginModule())
}
