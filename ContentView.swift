//
//  ContentView.swift
//  SSC_2025
//
//  Created by Venkatesh Devendran on 2/2/25.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct GameConfig{
    var spawnFirstLootBoxNearBy = false
    var spawnAsteroids: Bool = true
    var spawnJumpgateAt: Int = -1
    var scoreForJumpgate: Int = 10
    var spawnLootBoxes: Bool = true
}

var BGMusicPlayer = createSound(filePath: "BGMusic.mp3")

struct ContentView: View {
    @State var textEdtorContent: String = "var spc = new Spaceship()"
    @State var level = 0
    @State var showTutorial = true
    @State var showProxima = false

    var body: some View {
        ZStack{
            if showTutorial{
                Color("Secondary")
                    .ignoresSafeArea()
                
                TutorialView(level: $level, showTutorial: $showTutorial, showProxima: showProxima)
            }
            else{
                switch level{
                    case 0:
                    MainView(level: $level, showTutorial: $showTutorial, showProxima: $showProxima, textEdtorContent: $textEdtorContent, gameConfig: GameConfig(spawnJumpgateAt: 1, scoreForJumpgate: 0, spawnLootBoxes: false))
                    case 1:
                    MainView(level: $level, showTutorial: $showTutorial, showProxima: $showProxima, textEdtorContent: $textEdtorContent, gameConfig: GameConfig(spawnFirstLootBoxNearBy: true, scoreForJumpgate: 1))
                        
                    case 2:
                    MainView(level: $level, showTutorial: $showTutorial, showProxima: $showProxima, textEdtorContent: $textEdtorContent, gameConfig: GameConfig(spawnAsteroids: false))
                        
                    case 3:
                    MainView(level: $level, showTutorial: $showTutorial, showProxima: $showProxima, textEdtorContent: $textEdtorContent)
                        
                    case 4:
                    MainView(level: $level, showTutorial: $showTutorial, showProxima: $showProxima, textEdtorContent: $textEdtorContent, gameConfig: GameConfig(spawnJumpgateAt: 2))
                        
                    default:
                    MainView(level: $level, showTutorial: $showTutorial, showProxima: $showProxima, textEdtorContent: $textEdtorContent)

                }
            }
        }
        .onAppear{
            BGMusicPlayer?.volume = 0.5
            BGMusicPlayer?.play()
        }
        
    }
}

struct NormalButtonStyle: ButtonStyle {
    var bgColor: Color
    init(_ bgColor: Color){
        self.bgColor = bgColor
    }
    
    @Environment(\.isEnabled) var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        if isEnabled{
            configuration.label
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(bgColor.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        else{
            configuration.label
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(0.25)
        }
    }
}
func createSound(filePath: String) -> AVAudioPlayer?{
    var player: AVAudioPlayer? = nil
    let path = Bundle.main.path(forResource: filePath, ofType: nil)!
    let url = URL(fileURLWithPath: path)
    do {
        player = try AVAudioPlayer(contentsOf: url)
    } catch {
        print("audio file not found at \(filePath)")
    }
    
    return player

}
