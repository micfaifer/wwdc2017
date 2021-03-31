import SpriteKit

public class Word{
    var letters = Array<Letter>()
    var possibleWord = PossibleWord()
    
    init (){
    
    }
    
    init(letters: Array<Letter>){
        self.letters = letters
    }
    
    init(possibleWord: PossibleWord) {
        self.letters = Array<Letter>()
        self.possibleWord = possibleWord
    }
    
    public func colorLetters(){
        let color = getRandomColor()
        for letter in letters{
            letter.colorRect(color: color)
        }
    }
    
    func getRandomColor() -> SKColor{
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return SKColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

}
