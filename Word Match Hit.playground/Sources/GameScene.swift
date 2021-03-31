import SpriteKit
import AVFoundation

let width = 440 as CGFloat
let height = 640 as CGFloat

let middle = CGPoint(x: 0, y: 0)
var gameAreaSize = CGSize()
var blockSize = CGFloat()

public class GameScene: SKScene {
    var score = TextInf()
    
    var rows = Int()
    var cols = Int()
    
    var currentLetter = Letter()
    var nextLetter = Letter()
    
    var nextLetterArea = NextLetterArea()
    
    var gameArea = SKNode()
    
    var letterArray: Array2D<Letter>?
    
    var words = [String]()
    
    var foundWords = [Word]()
    
    var lettersGame = String()
    
    var rect = SKShapeNode()
    
    var endedGame = false
    

    var audioPlayer = AVAudioPlayer()
    
    public var possibleWords = [PossibleWord]()
    public var backgroundSound = ""
    public var speedLetter = CGFloat(1)
    
    override public func sceneDidLoad() {
        super.sceneDidLoad()
        setGameArea()
        
        rect = SKShapeNode(rect:CGRect(origin: middle, size: CGSize(width: width*0.9, height: height - gameAreaSize.height - 60)))
        score = TextInf(rect: CGRect(x: 0, y: 0, width: rect.frame.width/2 - 30, height: rect.frame.height/2 - 20))
        
        score.label.text = "Matchs "
        rect.addChild(score)
        
        rect.position.x += (width - gameArea.frame.width)/2
        rect.position.y += gameAreaSize.height + 40
        
        score.position.x += 10
        score.position.y += (rect.frame.height/2)/2
        
        
        self.addChild(rect)
    }
    
    func blurEffect() {
        let blurNode = SKEffectNode()
        let blur = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 1.0])
        blur?.setValue(10, forKey: kCIInputRadiusKey)
        
        blurNode.filter = blur
        blurNode.blendMode = .alpha
        addChild(blurNode)
        
        gameArea.removeFromParent()
        rect.removeFromParent()
        blurNode.addChild(gameArea)
        blurNode.addChild(rect)
    }
    
    func setEndGameArea(){
        let endGamePath = UIBezierPath(roundedRect: CGRect(origin: middle, size: CGSize(width: gameAreaSize.width - 40, height: gameAreaSize.height*0.6)), byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.bottomRight, UIRectCorner.topRight], cornerRadii: CGSize(width: 10, height: 10))
        
        
        let endGamePanel = SKShapeNode()
        endGamePanel.path = endGamePath.cgPath
        
        endGamePanel.position = CGPoint(x: (self.frame.width - endGamePanel.frame.width)/2, y: (self.frame.height - endGamePanel.frame.height)/2)
        
        endGamePanel.fillColor = SKColor.white
        
        let sizeBlock = endGamePanel.frame.width*0.8/CGFloat("Game Over".count)
        
        for (index, l) in "Game Over".enumerated(){
            let letter = Letter(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeBlock, height: sizeBlock)))
            letter.label.text = l.description
            letter.label.fontColor = SKColor.black
            
            letter.position.y = (endGamePanel.frame.height/2) + endGamePanel.frame.width*0.1
            letter.position.x += CGFloat(index) * sizeBlock + endGamePanel.frame.width*0.1
            letter.block.strokeColor = SKColor.black
            
            endGamePanel.addChild(letter)
        }
        
        let matches = SKLabelNode()
        matches.text = score.label.text
        matches.fontName = "Helvetica-bold"
        matches.fontColor = SKColor.black
        matches.position = CGPoint(x: (endGamePanel.frame.width/2), y: (endGamePanel.frame.height/2) - sizeBlock)
        
        endGamePanel.addChild(matches)
        
        endGamePanel.zPosition = 100
        
        self.addChild(endGamePanel)
        
    }
    
    func generateLettersGame(){
        let teste  = possibleWords.flatMap({$0.text})
        
        for char in teste {
            if (!lettersGame.contains(char.description)){
                lettersGame += char.description
            }
        }
        Letter.possibleLetters = lettersGame
    }
    
    func sortPossibleWords(){
        possibleWords = possibleWords.sorted { $0.text.count > $1.text.count }
    }
    
    public func startGame(){
        generateLettersGame()
        playSound(file: backgroundSound, type: "m4a")
        
        self.view?.backgroundColor = SKColor.lightGray
        score.label.text = "Matches 0"
        
        nextLetterArea = NextLetterArea(rect: CGRect(origin: middle, size: CGSize(width: rect.frame.width/2 - 30, height: rect.frame.height - 30)))
        
        rect.addChild(nextLetterArea)
        sortPossibleWords()
        
        nextLetter = Letter(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: blockSize, height: blockSize)))
        
        spawnLetter()
    }
    
    func endGame(){
        endedGame = true
        
        setEndGameArea()
        blurEffect()
    }
    
    func setGameArea(){
        rows = 13
        cols = 11
        
        blockSize = width*0.9/11
        Letter.blockSize = blockSize
        
        gameAreaSize = CGSize(width: width*0.9, height: blockSize * CGFloat(rows))
        
        gameArea = SKShapeNode(rect: CGRect(origin: middle, size: gameAreaSize))
        
        gameArea.position.x += (width - gameArea.frame.width)/2
        
        gameArea.position.y += 20
        self.addChild(gameArea)
        
        letterArray = Array2D<Letter>(columns: Int(cols), rows: Int(rows))
    }
    
    func spawnLetter (){
        let letter = Letter(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: blockSize, height: blockSize)))
        
        let colLetter = Int((cols - 1)/2)
        let rowLetter = rows - 1
        
        currentLetter = nextLetter
        nextLetter = letter
        nextLetterArea.letter.label.text = nextLetter.label.text
        
        currentLetter.position.x = getXLetter(col: colLetter)
        currentLetter.position.y = getYLetter(row: rowLetter)
        
        currentLetter.col = colLetter
        currentLetter.row = rowLetter
        
        gameArea.addChild(currentLetter)
        
        if (speedLetter <= 0 ){
            fallLetter(letter: currentLetter,waitMovDuration: TimeInterval(CGFloat(0.1)))
        }else {
            fallLetter(letter: currentLetter,waitMovDuration: TimeInterval(CGFloat(0.1)/speedLetter))
        }
    }
    
    func fallLetter(letter: Letter, waitMovDuration: TimeInterval){
        let moveDown = SKAction.run({
            self.moveLetterDown(letter: letter)
        })
        
        let wait = SKAction.wait(forDuration: waitMovDuration)
        let sequence = SKAction.group([wait, moveDown])
        let repeatMove = SKAction.repeatForever(sequence)
        letter.run(repeatMove, withKey: "moveDown")
    }
    
    func addLetterArray (letter: Letter){
        letterArray?[letter.col, letter.row] = letter
    }
    
    func removeLetterArray (letter: Letter){
        letterArray?[letter.col, letter.row] = nil
    }
    
    func getYLetter(row: Int) -> CGFloat{
        return (blockSize * CGFloat(row))
    }
    
    func getXLetter(col: Int) -> CGFloat{
        return (blockSize * CGFloat(col))
    }
    
    func moveLetterDown(letter: Letter){
        if ((letter.row == 0 && letter.onFloorRow) || (letter.row != 0 && letter.onFloorRow && letterArray?[letter.col, letter.row - 1] != nil)){
            stopLetter(letter: letter)
        }else{
            letter.isMoving = true
            letter.moveDown()
            self.setRowLetter(letter: letter)
        }
    }
    
    func stopLetter(letter: Letter){
        letter.removeAction(forKey: "moveDown")
        currentLetter.isMoving = false
        self.addLetterArray(letter: letter)
        self.verifyWords(col: currentLetter.col, row: currentLetter.row)
    }
    
    func verifyWords(col: Int, row: Int){
        for w in possibleWords{
            verifyMatchRow(wordToFind: w, row: row)
            //verifyMatchCol(wordToFind: w, col: col)
        }
    }
    
    func verifyMatchCol(wordToFind: PossibleWord, col: Int){
        var colString = ""
        for index in (0 ... cols - 1).reversed(){
            if (letterArray?[col, index] != nil && (letterArray?[col, index]?.word.letters.count)! < wordToFind.text.count ){
                colString += (letterArray?[col, index]?.label.text)!
            } else{
                colString += " "
            }
        }
        
        let matches = indexesMatch(sentence: colString, query: wordToFind.text)
        var word = Word()
        
        for match in matches{
            word = Word(possibleWord: wordToFind)
            for index in ((match) ... (match) + wordToFind.text.count - 1).reversed(){
                word.letters.append((letterArray?[col, index])!)
                removeWord(word: (letterArray?[col, index]?.word)!)
                word.colorLetters()
                letterArray?[col, index]?.word = word
            }
        }
        //disappearWord(word: word)
    }
    
    func removeFromPreviusWord(word: Word){
        for letter in word.letters {
            letter.word = word
        }
    }
    
    func verifyMatchRow(wordToFind: PossibleWord, row: Int){
        var rowString = ""
        for index in 0 ... cols - 1{
            if (letterArray?[index, row] != nil && (letterArray?[index, row]?.word.letters.count)! < wordToFind.text.count){
                rowString += (letterArray?[index, row]?.label.text)!
            }else{
                rowString += " "
            }
        }
        
        let matches = indexesMatch(sentence: rowString, query: wordToFind.text)
        
        for match in matches{
            let word = Word(possibleWord: wordToFind)
            for index in (match) ... (match) + wordToFind.text.count - 1{
                word.letters.append((letterArray?[index, row])!)
                removeWord(word: (letterArray?[index, row]?.word)!)
                letterArray?[index, row]?.word = word
                word.colorLetters()
                
                //disappearWord(word: word)
            }
            foundWords.append(word)
            if (word.possibleWord.soundForMatch != nil){
                self.run(word.possibleWord.soundForMatch!())
            }
        }
    }
    
    func removeWord(word: Word){
        for letter in word.letters{
            letter.word = Word()
            letter.resetColor()
        }
    }
    
    func disappearWord(word: Word){
        for letter in word.letters{
            removeLetterArray(letter: letter)
            letter.removeFromParent()
            fallLettersAbove(letter: letter)
        }
    }
    
    func fallLettersAbove(letter: Letter){
        var row = letter.row + 1
        
        while (row < rows - 1 && letterArray?[letter.col, row] != nil){
            fallLetter(letter: (letterArray?[letter.col, row])!, waitMovDuration: 0.1)
            letterArray?[letter.col, row] = nil
            
            row += 1
        }
    }
    
    func indexesMatch(sentence: String, query: String) -> [Int]{
        var searchRange = sentence.startIndex..<sentence.endIndex
        var indexes: [Int] = []
        
        while let range = sentence.range(of: query, options: .caseInsensitive, range: searchRange) {
            searchRange = range.upperBound..<searchRange.upperBound
            let intValue = sentence.distance(from: sentence.startIndex, to: range.lowerBound)
            indexes.append(intValue)
        }
        return indexes
        
    }
    
    func moveLetterRight(){
        if (currentLetter.col + 1 != cols && currentLetter.isMoving == true){
            if (letterArray?[currentLetter.col + 1, currentLetter.row] == nil){
                currentLetter.moveRight()
            }
        }
    }
    
    func moveLetterLeft(){
        if (currentLetter.col - 1 >= 0 && currentLetter.isMoving == true){
            if (letterArray?[currentLetter.col - 1, currentLetter.row] == nil){
                currentLetter.moveLeft()
            }
        }
    }
    
    func setColLetter(letter: Letter){
        let col = (letter.position.x / blockSize)
        letter.col  = Int(col)
    }
    
    func setRowLetter(letter: Letter){
        let row =  (letter.position.y / blockSize)
        if (floor(row) == row){
            letter.onFloorRow = true
        }else{
            letter.onFloorRow = false
        }
        
        letter.row = Int(row)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        if (currentLetter.isMoving == false && endedGame == false){
            self.spawnLetter()
        }
        
        if (currentLetter.row == rows - 1 && letterArray?[currentLetter.col, currentLetter.row - 1] != nil){
            //currentLetter.removeAction(forKey: "moveDown")
            endGame()
        }
        
        
        if (foundWords.count > 0){
            score.label.text = "Matches \(foundWords.count)"
        }
    }
    
    override public func didMove(to view: SKView) {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:   #selector(self.tap))
        tap.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(tap)
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        swipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipe)
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            dropLetter()
        }
    }
    
    func dropLetter(){
        currentLetter.removeAction(forKey: "moveDown")
        fallLetter(letter: currentLetter, waitMovDuration: 0.008)
    }
    
    
    @objc func tap(sender:UITapGestureRecognizer){
        if (sender.state == .ended) {
            var touchLocation: CGPoint = sender.location(in: sender.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            if (touchLocation.x > gameAreaSize.width/2){
                moveLetterRight()
            }else{
                moveLetterLeft()
            }
        }
    }
    
    func playSound(file: String , type: String){
        let audioURL = URL(fileURLWithPath: Bundle.main.path(forResource: file, ofType: type)!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        } catch {
            print("Audio error")
        }
    }
}
