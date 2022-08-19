//
//  ContentView.swift
//  TimerAppSwiftUI
//
//  Created by Alkın Çakıralar on 19.05.2022.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
            
        VStack {
            
                ZStack {
                    
                    Circle()
                        .trim(from: 0.0, to: 0.5)
                        .rotation(Angle(degrees: viewModel.circleDegree))
                        .stroke(LinearGradient(gradient: AppColors.circleGradient, startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .background(Circle().foregroundColor(.clear))
                        .overlay {
                            
                            VStack {
                                
                                Circle()
                                    .strokeBorder(AppColors.softRed, lineWidth: 1)
                                    .background(Circle().foregroundColor(AppColors.softRed))
                                    .frame(width: 10, height: 10)
                                    .opacity(viewModel.countDownViewOpacity)
                                    
                                Spacer()
                                
                                HStack {
                     
                                    Text(viewModel.getHourAndMinute(time: viewModel.currentTime))
                                        .font(Font.system(size: 35))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    +
                                    Text(viewModel.getSecond(time: viewModel.currentTime))
                                        .font(Font.system(size: 35))
                                        .fontWeight(.bold).foregroundColor(AppColors.softRed)
                                    
                                }
                                
                                Spacer()
                                
                            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.clear)
                            .padding(.bottom, 30)
                            .padding(.top, 30)
                        }
                    
                }
                .frame(height: 300)
                .background(.clear)
                .scaleEffect(viewModel.loadingScale)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 32) {
                    
                    Button {
                        viewModel.timerState == .Started || viewModel.timerState == .Paused ? viewModel.stopTimer(vibratePhone: true) : viewModel.startTimer()
                    } label: {
                        
                        HStack(alignment: .center) {
                            Text(viewModel.timerState == .Stopped ? "Start" : "Stop")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }.padding(.top, 20)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.softRed)
                        .cornerRadius(15)
                        
                    }
                    
                    Button {
                        
                        if viewModel.timerState == .Stopped { return }
        
                        viewModel.timerState == .Started ? viewModel.pauseTimer() : viewModel.startTimer()
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            Text(viewModel.timerState == .Paused ? "Resume" : "Pause")
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.darkRed)
                        }.padding(.top, 20)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.lightRed)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AppColors.softRed, lineWidth: 4))
                        .cornerRadius(15)
                        
                    }
                }
                    .scaleEffect(viewModel.loadingScale)
                 
                
            }.padding(.top, 42)
            .padding(.bottom, 42)
            .padding(.trailing, 22)
            .padding(.leading, 22)
            .background(AppColors.gray)
            .onAppear {
                viewModel.stopTimer(vibratePhone: false)
                
                withAnimation(Animation.spring().delay(0.3)) {
                    viewModel.loadingScale = 1.0
                }
            }
            .onReceive(viewModel.countDownTimer) { _ in
                viewModel.currentTime += 1
            }
            .onReceive(viewModel.circleTimer) { _ in
                withAnimation {
                    viewModel.circleDegree += 1
                }
            }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().previewDevice("iPhone 13 Pro")
    }
}
