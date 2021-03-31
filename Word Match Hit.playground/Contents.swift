/*:
 # Welcome to customizable word matching game with music
  
 * Move letters to form matching words as each letter falls.
 * Touch each side of the screen to move the falling word.
 * Try to achieve the most matches while creating your music with all repeating sounds
 * The game ends when the pile of letters reaches the top
 
 In this playground, you can configure the game to play custom sounds when words match. You will use SKAction to choose your own sounds and make your own improvised music happen while you find matching words in the game. Each word match triggers a sound repetition, which can also be configured in the code.
 As sound choice, you can choose from one of the included chords, which are from the C major scale, so the strings you can insert are: Am Dm Em C G E F Bd and Bdim.
 But you can also do your own improvisation, recording sounds in other apps like GarageBand and importing them in here, the behavior is the same.
 The idea behind this game is to allow others to learn a bit more about SKAction and play with some music in the meantime.
  Below you can see some examples of how the game can be customized.

 ![Banner](banner.png)
 
 
 
 * You can edit the sounds of the chosen matches using SKAction, which here is used to load and play the sounds in the currently included library or any sounds you may import.
 The repetition behavior is also set below, in this example, the sound repeats for limited times, but you can set yours to repeat forever.
 * And speed of the falling letter
 */
//#-hidden-code
import PlaygroundSupport
import SpriteKit
let width = 440 as CGFloat
let height = 640 as CGFloat
let middle = CGPoint(x: 0, y: 0)
var gameAreaSize = CGSize()
var blockSize = CGFloat()
let skView = SKView(frame: CGRect(origin: middle, size: CGSize(width: width, height: height)))
skView.showsFPS = false
let game = GameScene(size: skView.frame.size)
//#-end-hidden-code

game.speedLetter = /*#-editable-code*/1.2/*#-end-editable-code*/
//#-editable-code
var hey = PossibleWord(text: "hey")

func heySound() -> SKAction{
    let note = SKAction.playSoundFileNamed("hey.m4a", waitForCompletion: true)
    let waitForInterval = SKAction.wait(forDuration: 0.1)
    let sequenceSound = SKAction.sequence([note, waitForInterval])
    let loopSound = SKAction.repeatForever(sequenceSound)
    
    return loopSound
}

hey.soundForMatch = heySound
//#-end-editable-code
//:You can also use emoji and symbols 😁
//#-editable-code
var pianoG = PossibleWord()
pianoG.text = "🎹🎹"

func pianoGSound() -> SKAction{
    let note = SKAction.playSoundFileNamed("Am.m4a", waitForCompletion: true)
    let waitForInterval = SKAction.wait(forDuration: 0.1)
    let sequenceSound = SKAction.sequence([note, waitForInterval])
    let loopSound = SKAction.repeat(sequenceSound, count: 3)
    
    return loopSound
}

pianoG.soundForMatch = pianoGSound
//#-end-editable-code
//:Use the object PossibleWord to create your own match
//#-editable-code
var car = PossibleWord(text: "🚘🚘")

func carSound() -> SKAction{
    let note = SKAction.playSoundFileNamed("car.m4a", waitForCompletion: true)
    let waitForInterval = SKAction.wait(forDuration: 0.04)
    let sequenceSound = SKAction.sequence([note, waitForInterval])
    let loopSound = SKAction.repeat(sequenceSound, count: 5)
    
    return loopSound
}

car.soundForMatch = carSound
//#-end-editable-code
//:Add your own background sound
//#-editable-code
game.backgroundSound = "drum_loop"

game.possibleWords.append(contentsOf: [hey, pianoG, car])
//#-end-editable-code

//:You can add a list of possible words without sound too
//#-editable-code
game.possibleWords.append(contentsOf: [PossibleWord(text: "🚘🎹"), PossibleWord(text: "🎹🚘")])

//#-end-editable-code

game.startGame()

//#-hidden-code
skView.presentScene(game)

PlaygroundPage.current.liveView = skView
//#-end-hidden-code
