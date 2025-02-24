//
//  TutorialView.swift
//  SSC_2025
//
//  Created by Venkatesh Devendran on 12/2/25.
//

import SwiftUI
import SpriteKit
import AVFoundation

//components usuable in messages to user
enum TextType{
    case textTitle
    case bodyText
    
}

struct ButtonData{
    let buttonText: String
    var endMessage: Bool = false
    var endApp: Bool = false
    var buttonColor: Color = .blue
}

struct OctaciusMessage{
    let messages: [String]
    let buttonTexts: [String]
    var lastButton: Bool = false
}

struct LittleSpriteKit{
    let code: String
    var gameConfig: GameConfig = GameConfig()
    var showCode: Bool = true
}

struct TextData{
    let text: Text
    let type: TextType
}

struct CodeBlock{
    let code: String
    var takeFrame: Bool = false
}

struct Quiz{
    let question: String
    let options: [Text]
    let answer: Int
}

var ExpectedBehaviousList: [[Any]]? = [
    [
//        //Task 1
//        TextData(text: Text("The Task"), type: .textTitle),
//        TextData(text: Text("""
//        The goal is to reach the jumpgate. This time we know for sure that the jumpgate will be spawning at the 2nd lane from the left. You start on the middle lane. So program your spaceship to move to the lane of the jumpgate and then move to the jumpgate.
//        """), type: .bodyText),
        
        LittleSpriteKit(code: """
        var spc = new Spaceship()
        spc.moveLeft()
        spc.moveToJumpgate()
        """,
        gameConfig: GameConfig(spawnJumpgateAt: 1, scoreForJumpgate: 0, spawnLootBoxes: false), showCode: false),

    ],
    
    [
        //Task 2
        LittleSpriteKit(code: """
        var spc = new Spaceship()

        if(spc.lootBoxDirection() == Direction.LEFT){
            spc.moveLeft()
        }
        if(spc.lootBoxDirection() == Direction.RIGHT){
            spc.moveRight()
        }
        if(spc.lootBoxDirection() == Direction.FRONT){
            spc.shoot()
        }

        if(spc.isJumpgatePresent()){
            spc.moveToJumpgate()
        }
        """,
        gameConfig: GameConfig(spawnFirstLootBoxNearBy: true, scoreForJumpgate: 1), showCode: false),

    ],
    
    [
        //Task 3
        LittleSpriteKit(code: """
        var spc = new Spaceship()

        while(!jumpgateReached){

            if(spc.isAsteroidPresent()){
                spc.activateShields()
            }

            if(spc.lootBoxDirection() == Direction.LEFT){
                spc.moveLeft()
            }
            else if(spc.lootBoxDirection() == Direction.RIGHT){
                spc.moveRight()
            }
            else if(spc.lootBoxDirection() == Direction.FRONT){
                spc.shoot()
            }

            if(spc.isJumpgatePresent()){
                spc.moveToJumpgate()
            }

        }
        """,
        gameConfig: GameConfig(spawnAsteroids: false), showCode: false),

    ],
    
//    [
//        //Task 4
//        LittleSpriteKit(code: """
//        var spc = new Spaceship()
//
//        while(!jumpgateReached){
//
//            if(spc.isAsteroidPresent()){
//                spc.activateShields()
//            }
//
//            if(spc.lootBoxDirection() == Direction.LEFT){
//                spc.moveLeft()
//            }
//            else if(spc.lootBoxDirection() == Direction.RIGHT){
//                spc.moveRight()
//            }
//            else if(spc.lootBoxDirection() == Direction.FRONT){
//                spc.shoot()
//            }
//
//            if(spc.isJumpgatePresent()){
//                spc.moveToJumpgate()
//            }
//
//        }
//        """,
//        showCode: false),
//
//    ],

]

var HintsList: [[Any]]? = [
    [
        //Hint 1
        TextData(text: Text("Hint"), type: .textTitle),
        TextData(text: Text("""
        The goal is to reach the jumpgate. This time we know for sure that the jumpgate will be spawning at the 2nd lane from the left. You start on the middle lane. So program your spaceship to move to the lane of the jumpgate and then move to the jumpgate.
        """), type: .bodyText),
    ],
    
    [
        //Hint 2
        TextData(text: Text("Hint"), type: .textTitle),
        TextData(text: Text("""
        The goal is to reach the jumpgate. Use seperate if statemnets to check for each direction the lootBox could be at
        """), type: .bodyText),

    ],
    
    [
        //Task 3
        TextData(text: Text("Hint"), type: .textTitle),
        TextData(text: Text("""
        You would need to run your code \(Text("until").italic()) you reach the jumpgate. Remember that \(inlineCodeBlock("jumpgateReached")) is a boolean.
        """), type: .bodyText),

    ],
//    
//    [
//        //Task 4
//        TextData(text: Text("Hint"), type: .textTitle),
//        TextData(text: Text("""
//        \(inlineCodeBlock("isAsteroidPresent()")) return a true or false. A condition can be true or false.
//        """), type: .bodyText),
//
//    ],
]

var endScene: SKScene{
    let scene = EndScene()
    scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    scene.scaleMode = .aspectFill
    return scene
}

struct TutorialView: View {
    @Binding var level: Int
    @Binding var showTutorial: Bool
    
    @State var requirePadding = true
    
    @State var messageNumber = 0
    
    @State var showProxima = false
        
    @State var LevelMessages: [[[Any]]] = [
        //Level 1
        [
            //message1
            [
                OctaciusMessage(messages:[
                """
                Hello friend, remember me? I'm Octacius the Octopus. I heard you're lost in space in your damaged spaceship. Since your autopilot cannot work due to technical failures, I would suggest manually programming the spaceship to navigate through space. Use nearby jumpgates to reach back to Proxima Centauri. I'll be waiting.
                """,
                """
                Oh right... I remember you had skipped all of your computing classes and absolutely have no clue on how to program your spaceship. Fret not for Octacius knows exactly what to do!
                """,
                ],
                buttonTexts: [
                    "Program?",
                    "Phew...",
                ]),
            ],
            
            //tutorial 1
            [
                TextData(text: Text("How do you get to Proxima Centauri?"), type: .textTitle),
                TextData(text: Text("""
                First of all, your ship is cllibrated to move to 5 different lanes. You can move left and right between these lanes. You would have to move ship to the lane with the jumpgate and then move to the jumpgate. Moving through a jumpgate will teleport you light-years away which would help you travel faster.
                """), type: .bodyText),
                
                Spacer()
                    .frame(height: 24),
                
                TextData(text: Text("How to move left and right?"), type: .textTitle),
                
                TextData(text: Text("""
                As mentioned before you would have to program your ship. This sounds pretty simple right? Something like this would seem to work:
                """), type: .bodyText),
                
                CodeBlock(code: "moveLeft()"),
                
                TextData(text: Text("""
                Well that would work, if not for your spaceship requiring Object Orient Programming (OOP). OOP basically means that we create 'objects' to code. Which would mean we need a \(inlineCodeBlock("Spaceship")) object. Then we can make that object to move left. This can be done like this:
                """), type: .bodyText),
                
                CodeBlock(code: """
                var spc = new Spaceship()
                spc.moveLeft()
                """),
                
                TextData(text: Text("""
                The code above essentially works by creating a \(inlineCodeBlock("new Spaceship")) object and storing it in a variable called spc (short for spaceship). Then that object has the method \(inlineCodeBlock("moveLeft()")) which we can call as shown the code.
                """), type: .bodyText),
                
                Spacer()
                    .frame(height: 48),
                
                TextData(text: Text("""
                Here is a simulation of what the code does below
                """).bold(), type: .bodyText),

                LittleSpriteKit(code: """
                var spc = new Spaceship()
                spc.moveLeft()
                """,
                gameConfig: GameConfig(spawnLootBoxes: false)),
                
                Spacer()
                    .frame(height: 48),
                
//                TextData(text: Text("""
//                Now that you know how that works, you should be able to infer how to make the spaceship move to the jumpagte as well. 
//                """).bold(), type: .bodyText),
                
                Quiz(question: "Which of these would move the spaceship to the jumpgate?", options: [
                    inlineCodeBlock("spc.moveToJumpgate()"),
                    inlineCodeBlock("moveToJumpgate()"),
                    inlineCodeBlock("spc moveToJumpgate()"),
                ], answer: 0),
                
                TextData(text: Text("""
                *You would have to move the spaceship to the jumpgate only when you are in the same lane as the jumpgate, if not your spaceship will not move to the jumpgate.
                """).italic(), type: .bodyText),
                
//                littleSpriteKit(code: """
//                var spc = new Spaceship()
//                spc.moveLeft()
//                spc.moveToJumpgate()
//                """,
//                gameConfig: GameConfig(spawnJumpgateAt: 1, scoreForJumpgate: 0, spawnLootBoxes: false)),
//                
                ButtonData(buttonText: "Let's Go", endMessage: true),
            ],
        ],
        
        //Level 2
        [
            //message 2
            [
                OctaciusMessage(messages:[
                """
                Congrats! You just travelled your first jumpgate! Wasn't that easy? Just like I used to tell you, if you try hard enough anything is possible. 
                """,
                """
                In the next part of your journey, you would have to shoot at lootboxes which have the materials needed to form a jumpgate. Shooting such lootboxes will melt the materials which would allow you to form a jumpgate. To do so, you would need to learn about if statements and while loops.
                """,
                ],
                buttonTexts: [
                    "Thanks",
                    "Ok",
                ]),
            ],
            
            //tutorial 2
            [
                TextData(text: Text("if statements"), type: .textTitle),
                TextData(text: Text("""
                Like the name implies heavily, if statements check if something is true and perform an action. In your case you need to check if the lootbox is to the left or right of you before moving there accordingly.
                """), type: .bodyText),
                                
                TextData(text: Text("""
                You would need some way of detecting which direction the lootbox is. Luckily for you, your spaceship does that for you simply call \(inlineCodeBlock("spc.lootBoxDirection()")). You can then check if its left or right and move accordingly like the code below
                """), type: .bodyText),
                
                CodeBlock(code: """
                if(spc.lootBoxDirection() == Direction.LEFT){
                    //some action
                }
                
                if(spc.lootBoxDirection() == Direction.RIGHT){
                    //some action
                }
                
                if(spc.lootBoxDirection() == Direction.FRONT){
                    //some action
                }
                """),

                TextData(text: Text("""
                In the above code \(inlineCodeBlock("==")) simply means equals and \(inlineCodeBlock("Direction.RIGHT")) or \(inlineCodeBlock("Direction.LEFT")) or \(inlineCodeBlock("Direction.FRONT")) is just a value which describes left and right. Within the if statement you can code the spaeship to do something.
                """), type: .bodyText),
                
                TextData(text: Text("""
                Similarly you also have to use the method \(inlineCodeBlock("isJumpgatePresent()")) on your \(inlineCodeBlock("Spaceship")) object to check if you are on the same lane as lootbox like this
                """), type: .bodyText),
                
                CodeBlock(code: """
                if(spc.isJumpgatePresent()){
                    //some action
                }
                """),
                
                Spacer()
                    .frame(height: 24),
                
                TextData(text: Text("Shooting!"), type: .textTitle),

                TextData(text: Text("""
                Shooting! Finally, some action, am I right? Shooting is probably the easiest one to do here, all you have to do is call the \(inlineCodeBlock("shoot()")) method on your spaceship. You can pair this with an if statement to check if the lootbox is in front of you before shooting.
                """), type: .bodyText),
                
                Spacer()
                    .frame(height: 24),
                
                Quiz(question: "How would you shoot when the lootbox is in front?", options: [

                    inlineCodeBlock("""
                    if(spc.lootBoxDirection() = Direction.FRONT){
                        spc.shoot()
                    }
                    """),
                    inlineCodeBlock("""
                    if(spc.lootBoxDirection() == Direction.FRONT){
                        spc.shoot()
                    }
                    """),
                    inlineCodeBlock("""
                    if(spc.lootBoxDirection() == Direction.FRONT){
                        shoot()
                    }
                    """),
                    inlineCodeBlock("""
                    if(spc.lootBoxDirection() = Direction.FRONT){
                        shoot()
                    }
                    """),
                ], answer: 1),
                
                ButtonData(buttonText: "Shoot Some Boxes!", endMessage: true)

            ],
        ],
        
        //level 3
        [
            //message 3
            [
                OctaciusMessage(messages:[
                """
                Cool stuff back there, shooting lootboxes is fun isn't it?
                """,
                """
                You're pretty close to Proxima Centauri now! This is the last stretch, the lootboxes will spawn in randomly. You would have to shoot 10 lootboxes to spawn the gate this time.
                """,
                """
                Oh yes right, you would have to use a while loop for this. which I havent taught you yet 😅...
                """,
                ],
                buttonTexts: [
                    "Yup!",
                    "What?! How would I do that?!",
                    "...",
                ]),
            ],
            
            //tutorial 3
            [
                TextData(text: Text("while loops"), type: .textTitle),
                TextData(text: Text("""
                What while loops essential do is repeat whatever actions are inside of it until a condition becomes false. In our case we want out code to run until the jumpgate is reached. In your spaceship there is this special boolean variable for this purpose: \(inlineCodeBlock("jumpgateReached")). Do note that the vairable is not a method of \(inlineCodeBlock("Spaceship")) and can just be used on its own.
                """), type: .bodyText),
                                
                TextData(text: Text("""
                So we can write a while loop like this          
                """), type: .bodyText),
                
                CodeBlock(code: """
                while(condition1){
                    //actions go here
                }
                """),

                TextData(text: Text("""
                \(inlineCodeBlock("condition1")) is just a placeholder for the condition of your while loop.  
                """), type: .bodyText),
                
                ButtonData(buttonText: "Alright!", endMessage: true)
                
            ],
        ],
        
        //level 5
        [
            //message 5
            [
                TextData(text: Text("Proxima Centauri"), type: .textTitle),
                TextData(text: Text("""
                Getting here required learning some OOP and building your computational 
                thinking skills. These skills are fundemental in shaping your skill in 
                programming. The ability to program just enabled you to get here by 
                enabling you to implement your ideas. I hope, you had fun learning!
                """), type: .bodyText),
            ],
        ]
    ]
    
    var scene: SKScene{
        let scene = BGScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    @State var otherList: [[Any]]? = nil
   
    var body: some View {
        ZStack{
            if showProxima{
                SpriteView(scene: endScene)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
            else{
                SpriteView(scene: scene)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .blur(radius: 10)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                Color(.black)
                    .opacity(0.77)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    ForEach(otherList != nil ? otherList![level].indices : LevelMessages[level][messageNumber].indices, id: \.self){ i in
                        
                        let component = otherList != nil ? otherList![level][i] : LevelMessages[level][messageNumber][i]
                        checkForComponents(component: component)
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(requirePadding || showProxima ? 64 : 0)
                .foregroundStyle(.white)
                    
            }
        }
    }
    
    func checkForComponents(component: Any) -> some View{
        if component is TextData{
            return AnyView(
                TextView(textData: .constant(component as! TextData))
            )
        }
        else if component is OctaciusMessage{
            return  AnyView(
                OctaciusMessageView(tutorialView: self, message: .constant(component as! OctaciusMessage))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            )
        }
        else if component is LittleSpriteKit{
            return  AnyView(
                littleSpriteKitView(frameSize: CGSize(width: (UIScreen.main.bounds.height-128)*0.6, height: UIScreen.main.bounds.height-128), tutorialView: self, little: .constant(component as! LittleSpriteKit))
                    .padding(.top, -16)
                    .padding(.vertical, 32)
            )
        }
        else if component is CodeBlock{
            return  AnyView(
                CodeBlockView(codeBlock: component as! CodeBlock)
                    .padding(.bottom, 16)
            )

        }
        else if component is ButtonData{
            return  AnyView(
                NavigationButtonView(tutorialView: self, button: .constant(component as! ButtonData))
                    .padding(.top, 32)
            )

        }
        else if component is Quiz{
            return  AnyView(
                QuizView(quiz: .constant(component as! Quiz))
                    .padding(.bottom, 32)
            )

        }else if component is SpriteView{
            return  AnyView((component as! SpriteView))

        }
        else if component is any View{
            return  AnyView((component as! any View))

        }else {
            return AnyView(Spacer().frame(height: 48))
        }
    }
}

struct TextView: View {
    @Binding var textData: TextData
    
    var body: some View {
        
        VStack(alignment: .leading){
            textData.text
                .font(.system(size: textData.type == .textTitle ? 36 : 16, weight: textData.type == .textTitle ? .bold : .none, design: .default))
                .padding(.bottom, textData.type == .textTitle ? 24 : 16)
                .padding(.top, textData.type == .textTitle ? 8 : 0)

        }
        
    }
}

struct OctaciusMessageView: View {
    var tutorialView: TutorialView
    @Binding var message: OctaciusMessage
    
    @State var messageNumber = 0
    
    @State private var texts: [String] = []
    @State private var textsIndex: Int = 0
    @State private var currentCharacterIndex = 0
    
    
    @State private var showButton: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            OctaciusMessageHeader()
            .frame(alignment: .topLeading)
            .padding(.bottom, 16)
            
            ForEach(0...messageNumber, id: \.self){ i in
                
                Text((i < texts.count) ? texts[i] : "")
                    .font(.system(size: 21, weight: .none, design: .default))
                    .frame(alignment: .topLeading)
                
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color("Primary"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .overlay{
//                        RoundedRectangle(cornerRadius: 24.0)
//                            .stroke(Color("Secondary").opacity(0.5), lineWidth: 2)
//                    }
                
                    .padding(.bottom, 8)
                    .onAppear {
                        currentCharacterIndex = 0
                        
                        Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
                            
                            let characters = Array(message.messages[i])
                            
                            if texts.count <= i{
                                texts.append("\(characters[currentCharacterIndex])")
                            }
                            else{
                                texts[i] = "\(texts[i])\(characters[currentCharacterIndex])"
                            }
                            currentCharacterIndex += 1

                            if currentCharacterIndex == characters.count {
                                showButton = true
                                timer.invalidate()
                            }
                            
                            
                        }
                    }
            }
            
            if showButton{
                Button{
                    showButton = false
                    if messageNumber < message.messages.count-1{
                        messageNumber += 1
                    }
                    else{
                        if message.lastButton{
                            tutorialView.messageNumber = 0
                            tutorialView.showTutorial = false
                        }
                        else{
                            tutorialView.messageNumber += 1
                        }
                    }
                    
                }label:{
                    Text(message.buttonTexts[messageNumber])
                        .font(.system(size: 21))
                }
                .buttonStyle(NormalButtonStyle(.blue))
                .padding(.top, 24)
            }
            
        }

    }
}

struct littleSpriteKitView: View {
    @State var frameSize: CGSize
    
    var tutorialView: TutorialView
    
    @Binding var little: LittleSpriteKit
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 16){
                if little.showCode{
                    CodeBlockView(codeBlock: CodeBlock(code: little.code, takeFrame: true))
                }
                MainView(editable: false, frameSize: frameSize, level: .constant(tutorialView.level), showTutorial: .constant(tutorialView.showTutorial), showProxima: .constant(false), textEdtorContent: .constant(little.code), gameConfig: little.gameConfig, isOctaciusSheetShown: false)
                    .frame(width: frameSize.width, height: frameSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay{
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("Secondary").opacity(0.5), lineWidth: 2)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct CodeBlockView: View {
    @State var codeBlock: CodeBlock
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0){
                if codeBlock.takeFrame{
                    Text("main.js")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundStyle(.white.opacity(0.5))
                    
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                        .background(Color("Secondary"))
                        .padding(.bottom, 8)
                }
                
                
                Text(codeBlock.code)
                    .frame(maxWidth: codeBlock.takeFrame ? .infinity : .none, maxHeight: codeBlock.takeFrame ? .infinity : .none, alignment: .topLeading)
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 16, weight: .none, design: .monospaced))
                
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                
            }
            .background(Color("Primary"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct NavigationButtonView: View {
    var tutorialView: TutorialView
    @Binding var button: ButtonData

    var body: some View {
        Button{
            if button.endMessage{
                tutorialView.messageNumber = 0
                tutorialView.showTutorial = false
            }
            else if button.endApp{
                tutorialView.showProxima = true
            }
            else{
                tutorialView.messageNumber += 1
            }
            
        }label:{
            Text(button.buttonText)
                .font(.system(size: 21))
        }
        .buttonStyle(NormalButtonStyle(button.buttonColor))

    }
}

struct QuizView: View {
    @Binding var quiz: Quiz
    
    @State var selected: Int = -1
    @State var correctAnswer: Bool? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
            HStack(alignment: .center, spacing: 16){

                if correctAnswer != nil{
                    Image(systemName: correctAnswer! ? "checkmark.circle.fill" : "multiply.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(correctAnswer! ? .green : .red)
                        .opacity(0.5)
                        .padding(.horizontal, 4)
                }else{
                    Image(systemName: "circle.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .padding(.horizontal, 4)
                }
                
                Text(quiz.question)
                    .font(.system(size: 24, weight: .semibold))
                
            }
            .padding(.bottom, 24)
            
            HStack{
                ForEach(quiz.options.indices, id: \.self){ i in
                    Button{
                        selected = i
                        correctAnswer = quiz.answer == i
                    }label:{
                        ScrollView(.horizontal){
                            quiz.options[i]
                                .multilineTextAlignment(.leading)
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        .padding(8)
                        .background(
                            (
                                (selected > -1) ?
                                (selected == i) ?
                                ((quiz.answer == i) ? Color.green : Color.red)
                                :
                                    ((quiz.answer == i) ? Color.green : Color.gray)
                                :
                                    Color.gray
                                
                            )
                            .opacity(0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    }
                    .disabled(selected > -1 ? true : false)
                }
            }
            .padding(.bottom, 4)
        }
    }
}

func inlineCodeBlock(_ text: String) -> Text{
    if #available(iOS 17.0, *){
        return Text(" " + text + " ")
            .font(.system(size: 14, design: .monospaced))
            .italic()
            .foregroundStyle(.white.opacity(0.8))

    }
    return Text(text).font(.system(size: 14, design: .monospaced)).italic().foregroundColor(.white.opacity(0.8))

}

struct OctaciusMessageHeader: View {

    var body: some View {
        HStack(alignment: .center, spacing: 24){
            
            Image("OctaciusPFP")
                .resizable()
                .scaledToFit()
                .frame(height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(UIColor.label).opacity(0.5), lineWidth: 2)
                )
            
            Text("Octacius")
                .font(.system(size: 40, weight: .bold, design: .default))
        }
    }
}



