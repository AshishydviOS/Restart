//
//  OnboardingView.swift
//  Restart
//
//  Created by Ashish Yadav on 06/02/22.
//

import SwiftUI

struct OnboardingView: View {
    //MARK: - PROPERTY WRAPPER
    @AppStorage("onboarding") var isOnboaringViewActive = true
    
    //Its primary purpose to establish some constraints to the button horizontal moment.
    @State private var buttonWidth : Double = UIScreen.main.bounds.width - 80
    
    @State private var buttonOffset : CGFloat = 0
    //Button has two states,
    //there is an active state, when user is dragging it
    //there is an idle state when button is inactive
    
    //That's why we intialized the offset size with a zero value and this offset value will constantly be changing during the dragging activity.
    
    //----------------
    //think about this animation property as some kind of Switcher
    //A Property to control the Animation
    @State private var isAnimating : Bool = false
    //False : Animation start
    //true : Animation stop
    
    //----------------
    @State private var imageOffset : CGSize = .zero // OR CGSize(width: 0, height: 0)
    @State private var indicatorOpacity : Double = 1.0
    @State private var textTitle : String = "Share."
    
    let hapticFeedback  = UINotificationFeedbackGenerator()
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(SafeAreaRegions.all, edges: .all)
            VStack(spacing: 20) {
                //MARK: - HEADER
                Spacer()
                VStack(spacing: 0) {
                    Text(textTitle)
                        .font(Font.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle)
                    
                    Text("""
                    It's not how much we give but
                    How much love we put into giving.
                    """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        
                } //: HEADER
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                //MARK: - CENTER
                ZStack {
                    // Horizontal parallax Effect
                    CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("char1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(Angle.degrees(Double(imageOffset.width)/20)) // This will rotate the image
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    // MARK: This can drag the image to infinity
                                    // imageOffset = gesture.translation
                                    
                                    // MARK: This will limit the image dragging till 150 from left and right both
                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                        
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                })
                                .onEnded({ _ in
                                    imageOffset = .zero
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1.0
                                        textTitle = "Share."
                                    }
                                })
                        ) //: GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                } //: CENTER
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity)
                    , alignment: .bottom
                )
                Spacer()
                
                //MARK: - FOOTER
                ZStack {
                    //PARTS OF THE CUSTOM BUTTON
                    
                    // 1. BACKGROUND (STATIC)
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8)
                    
                    // 2. CALL-TO-ACTION (STATIC)
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .offset(x: 20)
                    
                    // 3. CAPSULE (DYNAMIC WIDTH)
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset+80)
                        
                        Spacer()
                    }
                    
                    // 4. CIRCLE (DRAGGABLE)
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(Color.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(Font.system(size: 24, weight: .bold))
                        } //: ZSTACK
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    //We can put any action inside it and these action will be triggered every time the gesture value changes.
                                    
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                })
                                .onEnded({ _ in
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        if buttonOffset > buttonWidth/2 {
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            
                                            //this state variable will check and navigate to the particular screen from contentView
                                            isOnboaringViewActive = false
                                        }
                                        else {
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                })
                        )//: GESTURE
                        
                        Spacer()
                    }//: HSTACK
                    
                } //: FOOTER
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            } //: VSTACK
        } //: ZSTACK
        .onAppear {
            isAnimating = true
            //this value change will trigger the animation
        }
        .preferredColorScheme(.dark)
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


//Drag Gesture:
/*
 Every drag gesture have two particular state
 1. when the drag user activity is happening
 2. when the drag user activity has ended
 
 We can tell the program what we want to do with the red button by knowing the value
 
 
Text("Ashish")
 .transition(.opacity)
 
 - This modifier should provide animated transition from transparent to Opaque on insertion
    and vice verca in removal
 
 */

