//
//  ContentView.swift
//  Restart
//
//  Created by Ashish Yadav on 06/02/22.
//

import SwiftUI

struct ContentView: View {
    //will setup a new onboaring key in @AppStorage which is a special SwiftUI Property Wrapper that will use the UserDefault under the hood.
    //Purpose : store some value on the device's permanent storage by utilizing a get and set method
    
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = true
    
    
    var body: some View {
        ZStack {
            if isOnboardingViewActive {
                OnboardingView()
            }
            else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
