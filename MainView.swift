//
//  MainView.swift
//  SSC_2025
//
//  Created by Venkatesh Devendran on 12/2/25.
//

import SwiftUI
import SpriteKit
import WebKit
import JavaScriptCore

struct MainView: View {
    @State var editable = true
    @State var frameSize: CGSize? = nil
    
    @Binding var level: Int
    @Binding var showTutorial: Bool
    @Binding var showProxima: Bool

    @State var actions = [""]
    
    @Binding var textEdtorContent: String
    
    @State var codeOutput: String = ""
    
    @State var gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height))
    
    @State var runTask: Task<Void, Never>? = nil
    @State var running = false
    
    @State var consoleHeight = 250.0
    
    @State var levelWon = false
    
    @State var gameConfig: GameConfig = GameConfig()
//    @State var spawnAsteroids = true
//    @State var spawnJumpgateAt: Int = -1
//    @State var scoreForJumpgate = 10
    
    var scene: SKScene{
        let scene = gameScene
        scene.size = frameSize != nil ? frameSize! : CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        scene.mainView = self
        scene.scoreForJumpgate = gameConfig.scoreForJumpgate
        return scene
    }
    
    @State var keyboardHeight: CGFloat = 0
    
    @State var lineCount = ""

    @FocusState var isEditorFocused: Bool
    
    @State var dragAmount: CGPoint?
    
    @State var isOctaciusSheetShown = true
    
    @State var firstTimeSheet = true
    
    var body: some View {
        ZStack{
            Color(UIColor.systemBackground)
            
            HStack(spacing: 0){
                if editable{
                    VStack(spacing: 0){
                        VStack{
                            ZStack{
                                Text("spaceship.js")
                                    .font(.system(size: 14, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                            }
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.secondarySystemBackground).opacity(0.5))

                            ScrollView(.vertical){
                                ScrollView(.horizontal){
                                    HStack(alignment: .top, spacing: 0){
                                        
                                        TextEditor(text: $lineCount)
                                            .font(.system(size: 12, weight: .none, design: .monospaced))
                                            .multilineTextAlignment(.trailing)
                                            .lineSpacing(1.1)
                                            .keyboardType(.asciiCapable)
                                            .disableAutocorrection(true)
                                            .scrollDisabled(true)
                                            .scrollContentBackground(.hidden)
                                            .frame(width: 40)
                                            .disabled(true)
                                            .opacity(0.5)
                                        
                                        TextEditor(text: $textEdtorContent)
                                            .font(.system(size: 12, weight: .none, design: .monospaced))
                                            .lineSpacing(1.1)
                                            .keyboardType(.asciiCapable)
                                            .autocorrectionDisabled()
                                            .textInputAutocapitalization(.never)
                                            .scrollDisabled(true)
                                            .scrollContentBackground(.hidden)
                                            .onAppear{
                                                updateLineCount()
                                            }
                                            .onChange(of: textEdtorContent){
                                                updateLineCount()
                                            }
                                            .focused($isEditorFocused)
                                            .frame(maxWidth: .infinity)
                                    }
                                    
                                }
                                .scrollBounceBehavior(.basedOnSize)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .background(Color(UIColor.systemBackground))
                        .opacity(!running ? 1.0: 0.5)
                        .onTapGesture {}
                        .disabled(running)
                        
                        if !isEditorFocused{
                            VStack(spacing: 0){
                                
                                VStack(spacing: 0){
                                    HStack{
                                        Capsule()
                                            .frame(width: 50, height: 4, alignment: .center)
                                            .padding(2)
                                            .foregroundStyle(Color(UIColor.secondaryLabel).opacity(0.25))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color(UIColor.tertiarySystemBackground))
                                    
                                    ButtonBar(parentMainView: self)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(8)
                                        .background(Color(UIColor.tertiarySystemBackground))
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            consoleHeight = min(max(100, -gesture.translation.height + consoleHeight), UIScreen.main.bounds.size.height-250)
                                        }
                                )
                                
//                                Divider()
//                                
                                //output for now but soon shall be the tutorial unless it should be comments in the code section.
                                VStack(alignment: .leading){
                                    ScrollView{
                                        Text(codeOutput.replacingOccurrences(of: "<br>", with: "\n"))
                                            .padding()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(codeOutput.starts(with: "ERROR") ? .red : .primary)
                                    }
                                    .onChange(of: codeOutput){
                                        print(codeOutput)
                                    }
                                }
                                .background(Color(UIColor.secondarySystemBackground))
                                .opacity(!running ? 1.0: 0.5)
                            }
                            .ignoresSafeArea(.keyboard)
                            .frame(height: consoleHeight)
                            .background(Color(UIColor.secondarySystemBackground))
                        }
                    }
                    .background(Color(UIColor.systemBackground))
                    .scrollIndicators(.never)
                    
//                    Divider()

                }
                
                VStack(spacing: 0){
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                    
                    if !editable{
                        ButtonBar(parentMainView: self)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(12)
                            .background(Color("Primary"))
                    }
                }
                .ignoresSafeArea(.keyboard)
            }
            
            Button{
                isOctaciusSheetShown = true
            }label:{
                Image("OctaciusPFP")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(UIColor.label).opacity(0.5), lineWidth: 2)
                    )
            }
            .animation(.default, value: dragAmount)
            .position(self.dragAmount ?? CGPoint(x: UIScreen.main.bounds.width*0.45, y: UIScreen.main.bounds.height*0.9))
            .highPriorityGesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.location}
            )
            .sheet(isPresented: $isOctaciusSheetShown, onDismiss: {
                firstTimeSheet = false
            }){
                OctaciusSheet(showTutorial: $showTutorial, level: $level, isExpectedSheetShown: firstTimeSheet ? true : false)
                    .presentationCornerRadius(24)
            }
        }
        .onTapGesture {
            isEditorFocused = false
        }

    }
    
    func updateLineCount(){
        lineCount = ""
        for x in 1...textEdtorContent.components(separatedBy: .newlines).count{
            print(x)
            lineCount += String(x) + "\n"
        }
    }
    
    func evaluateJavaScript(code: String) -> String? {
        var errorString = ""
        let context = JSContext()
        context!.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
            // type of String
//            let stacktrace = value.objectForKeyedSubscript("stack").toString()
            // type of Number
            let lineNumber = value.objectForKeyedSubscript("line")
            // type of Number
//            let column = value.objectForKeyedSubscript("column")
//            let moreInfo = "in method \(stacktrace!)"
            errorString = "ERROR:\n\(value!) at line: \(Int(lineNumber!.toString())! - 104)"
        }
        
        context?.evaluateScript(code)
        let output = context?.objectForKeyedSubscript("Op_V_aR5")
        let lootBoxIndexesOutput = context!.objectForKeyedSubscript("lotBex_LAnI_ndex")
        let jumpGateLaneEnd = context!.objectForKeyedSubscript("jumpGete_enaL")
        let asteroidLanes = context!.objectForKeyedSubscript("Astrid_enaLlISt")
        
        let outputValue: String?
        if let outputUnwrapped = output?.toString() {
            outputValue = outputUnwrapped
        } else {
            outputValue = nil
        }
                
        if outputValue != "undefined"{
            
            gameScene.currentJumpgateLane = Int(jumpGateLaneEnd!.toString())!
            print("gameScene.currentJumpgateLane 1st Time: ", gameScene.currentJumpgateLane)
            
            //asteroid lanes list
            let asteroidLanesString = asteroidLanes!.toString()!.components(separatedBy: ",")
            var asteroidLanesArray: [Bool] = []
            for i in asteroidLanesString{
                if i == "true"{
                    asteroidLanesArray.append(true)
                }
                else{
                    asteroidLanesArray.append(false)
                }
            }
            
            gameScene.asteroidLanes = asteroidLanesArray
            print("asteroidLanesArray: ", asteroidLanesArray)
            
            // so when there is an exmpty JS array it gets converted to a [""] so I have to remove that...
            var lootBoxIndexesArrayString =  lootBoxIndexesOutput!.toString()!.components(separatedBy: ",")
            lootBoxIndexesArrayString.removeAll(where: { $0 == "" })
            
            var lootBoxIndexesArray: [Int] = []
            for i in lootBoxIndexesArrayString{
                lootBoxIndexesArray.append(Int(i)!)
            }
            gameScene.lootBoxLanes = lootBoxIndexesArray
            
            print(asteroidLanesArray)
            print(lootBoxIndexesArray)
        }
        else{
            print(errorString)
            return errorString
        }

        print("gameScene.currentJumpgateLane 2nd Time: ", gameScene.currentJumpgateLane)

        return outputValue
        


    }
    
    
    func runCode(){
        
        gameScene.reset()
        
        if gameConfig.spawnLootBoxes{
            if gameConfig.spawnFirstLootBoxNearBy{
                gameScene.spawnLootBox(lane: Int.random(in: 1..<4))
            }else{
                gameScene.spawnLootBox(lane: Int.random(in: 0..<5))
            }
        }

        let JSCod = generateJSCode()
        
        runTask = Task{
            running = true

            await readAndExecuteCode()
            
            running = false

        }
        
        func readAndExecuteCode() async {
            //get all the output and move accordingly
            
            codeOutput = evaluateJavaScript(code: JSCod) ?? ""
            actions = codeOutput.components(separatedBy: "<br>")
            actions.removeLast()
            print(actions)

            for action in actions{
                if Task.isCancelled { return }

                if action == "moveLeft"{ await gameScene.moveSpaceship(moveDirection: .left) }
                else if action == "moveRight"{ await gameScene.moveSpaceship(moveDirection: .right) }
                else if action == "shoot"{ await gameScene.shoot() }
                else if action == "moveToJumpgate"{ await gameScene.moveToJumpgate() }
                else if action == "activateShields"{ gameScene.activateShields() }
//                else if action == "spawnJumpgate"{ gameScene.spawnJumpgate() }

            }
        }
    }
        
    func generateJSCode() -> String{
        return ("""
            //using the weirdest variable names to make sure that the chance of the user declaring a variable with the same name of what's being used here is super low 
        
            var OPtEx_t = ""
            var lotBex_LAnI_ndex = []
            var Astrid_enaLlISt = [false]

            var lotBex_LAn = \(gameScene.lootBoxLane ?? -1)
            var currentLane = \(gameScene.currentLane)
            var shoot_x_many_lotBxes = 0
            var jumpGete_enaL = -1
            var Astrid_enaL = false
        
            var boxs_NEEEDEDToSpawn_Jump_gete = \(gameScene.scoreForJumpgate)

            const Direction = {
                FRONT: "FRONT",
                LEFT: "LEFT",
                RIGHT: "RIGHT"
            }
        
            var jumpgateReached = false

            class Spaceship {
                lootBoxDirection() { 
                    if (lotBex_LAn != -1){
                        if (currentLane < lotBex_LAn){
                            return "RIGHT"
                        }
                        else if (currentLane > lotBex_LAn){
                            return "LEFT"
                        }
                        else{
                            
                            return "FRONT"
                        }
                    }
                    else{
                        return ""
                    }
                }
                isJumpgatePresent(){
                    if(jumpGete_enaL != -1){ return true; };
                    return false;
                }
        
                isAsteroidPresent(){
                    if(lotBex_LAn == currentLane){
                        return Astrid_enaL
                    }
                    return false
                }
                activateShields(){
                    OPtEx_t += "activateShields<br>"; 
                }

                moveLeft() { 
                    OPtEx_t += "moveLeft<br>"; 
                    currentLane -= 1;
                }

                moveRight() { 
                    OPtEx_t += "moveRight<br>"; 
                    currentLane += 1;
                }
        
                moveToJumpgate(){
                    OPtEx_t += "moveToJumpgate<br>"; 
                    jumpgateReached = true
                }

                shoot() { 
                    OPtEx_t += "shoot<br>" 
                    
                    if (currentLane == lotBex_LAn){

                        shoot_x_many_lotBxes += 1
        
                        if(shoot_x_many_lotBxes >= boxs_NEEEDEDToSpawn_Jump_gete){
                            if(\(gameConfig.spawnJumpgateAt < 0)){
                                jumpGete_enaL = currentLane
                            }
                            else{
                                jumpGete_enaL = \(gameConfig.spawnJumpgateAt)
                            }

                        }else{
                            var randomIndex = Math.floor(Math.random() * 5)
                            while(randomIndex == lotBex_LAn){
                                randomIndex = Math.floor(Math.random() * 5)
                            }
                            lotBex_LAn = randomIndex
                            lotBex_LAnI_ndex.push(randomIndex)
                        }
        
                        if (Math.floor(Math.random()*2) == 1 && \(gameConfig.spawnAsteroids)){
                            Astrid_enaL = true
                            Astrid_enaLlISt.push(true)
                        }
                        else{
                            Astrid_enaL = false
                            Astrid_enaLlISt.push(false)
                        }
        
                    }
                }  
        
            }
        
            if(shoot_x_many_lotBxes >= boxs_NEEEDEDToSpawn_Jump_gete){
                lotBex_LAn = -1
                if(\(gameConfig.spawnJumpgateAt < 0)){
                    jumpGete_enaL = currentLane
                }
                else{
                    jumpGete_enaL = \(gameConfig.spawnJumpgateAt)
                }

            }

            \(textEdtorContent)

            var Op_V_aR5 = OPtEx_t

        """)
    }
    
}

struct ButtonBar: View {
    var parentMainView: MainView
    
    var body: some View {
        
        HStack{
            Button{
                parentMainView.runTask?.cancel()
                parentMainView.running = false
            }label:{
                HStack{
                    Image(systemName: "stop.fill")
                    Text("Stop")
                }
                
            }
            .buttonStyle(NormalButtonStyle(.red))
            .disabled(!parentMainView.running)
            
            Button{
                parentMainView.runCode()
                
            }label:{
                HStack{
                    Image(systemName: "play.fill")
                    Text("Run")
                }
                
            }
            .buttonStyle(NormalButtonStyle(.green))
            .disabled(parentMainView.running)
            
            if parentMainView.levelWon && parentMainView.editable{
                Button{
                    if parentMainView.level < 2{
                        parentMainView.level += 1
                        parentMainView.showTutorial = true
                        parentMainView.levelWon = false
                    }
                    else{
                        parentMainView.showProxima = true
                        parentMainView.level += 1
                        parentMainView.showTutorial = true
                        parentMainView.levelWon = false
                    }
                    
                }label:{
                    HStack{
                        Image(systemName: "arrowshape.right.fill")
                        Text("Next")
                    }
                    
                }
                .buttonStyle(NormalButtonStyle(.blue))

                
            }
            
            
        }
    }
}

struct OctaciusSheet: View {
    @Binding var showTutorial: Bool
    @Binding var level: Int
    @State var isExpectedSheetShown: Bool
    @State var isHintSheetShown: Bool = false

    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{

            if isExpectedSheetShown{
                TutorialView(level: $level, showTutorial: $showTutorial, requirePadding: false, otherList: ExpectedBehaviousList)
                    .scrollIndicators(.never)
            }
            else if isHintSheetShown{

                TutorialView(level: $level, showTutorial: $showTutorial, otherList: HintsList)
                    .scrollIndicators(.never)
            }
            else{
                Color("OctaciusBG")

                ScrollView(){
                    VStack(alignment: .center){
                        
                        Image("Octacius")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256, alignment: .center)
                        
                        Text("What would you like help with?")
                            .font(.system(size: 36, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 24)
                        
                        VStack(spacing: 16){
                            Button{
                                isHintSheetShown = false
                                isExpectedSheetShown = true

                            }label:{
                                Text("What's the expected output again?")
                            }
                            .buttonStyle(NormalButtonStyle(.accentColor))
                            
                            Button{
                                isExpectedSheetShown = false
                                isHintSheetShown = true
                            }label:{
                                Text("Can I get a hint?")
                            }
                            .buttonStyle(NormalButtonStyle(.accentColor))
                            
                            Button{
                                showTutorial = true
                                dismiss()
                            }label:{
                                Text("I want to see the Tutorial again")
                            }
                            .buttonStyle(NormalButtonStyle(.accentColor))
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
                .scrollIndicators(.never)
            }
        }
        .foregroundStyle(.black)
    }
}
