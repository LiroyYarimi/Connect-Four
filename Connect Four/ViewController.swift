//
//  ViewController.swift
//  Connect Four
//
//  Created by liroy yarimi on 25/03/2019.
//  Copyright © 2019 Liroy Yarimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARL:- Properties
    
    lazy var columnView = [UIView]()
    var allDiskView = [UIView]()
    lazy var overallStackView = UIStackView(arrangedSubviews: [columnView[0],columnView[1],columnView[2],columnView[3],columnView[4],columnView[5],columnView[6]])
    
    //UI view spaces
    let diskHorizontalSpaceFromCol:CGFloat = 2
    let colSapce:CGFloat = 6
    let diskVerticalSapce:CGFloat = 2*2 + 6
    
    var isYellowTurn = true
    var diskSize: CGFloat?
    
    let backgroundView: UIView = {
        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        return view1
    }()
    
    let gameControlView: UIView = {
        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = .yellow
        return view1
    }()
    
    let controlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Yellow Turn"
        label.font = label.font.withSize(25)
        return label
    }()
    
    var matrix = [["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"]]
    var diskColSum = [0,0,0,0,0,0,0]
    
    //MARK:- Main - viewDidLoad
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsConstraints()
        createColumn()
        backgroundView.addSubview(overallStackView)
        setupOverallStackViewConstraints()
        addTargetForCol()
    }
    
    
    
    
    //MARK:- and of the game and start over

    
    func endOfGame(winner: String){
        var winnerMessage = "Is A Tie!"
        if winner == "Y"{
            winnerMessage = "Yellow Win!"
        }else if winner == "R"{
            winnerMessage = "Red Win!"
        }
        
        let alert = UIAlertController(title: "\(winnerMessage)", message: "Would you like to start over?", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { (UIAelrtAction) in
            self.startOver()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    
    func startOver(){
        for i in 0...6{
            diskColSum[i]=0
        }
        matrix = [["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"],
                  ["X","X","X","X","X","X","X"]]
        
        allDiskView.forEach { (view) in
            view.removeFromSuperview()
        }
        allDiskView.removeAll()
        
        gameControlView.backgroundColor = .yellow
        controlLabel.textColor = .black
        controlLabel.text = "Yellow Turn"
        isYellowTurn = true
        
    }
    
    //MARK:- Is there a winner?
    
    func checkForVictory() {
        for row in 0...(matrix.count - 1) {
            for col in 0...(matrix[row].count - 1){
                if horizontalWin(row: row, col: col) || verticalWIn(row: row, col: col) || obliqueRightWin(row: row, col: col) || obliqueLeftWin(row: row, col: col){
                    endOfGame(winner: matrix[row][col])
                }
            }
        }
        if isATie(){
            endOfGame(winner: "X")
        }
    }
    
    func isATie()-> Bool{
        var sum = 0
        diskColSum.forEach({sum+=$0})
        if sum == 42{
            return true
        }
        return false
    }
    
    func horizontalWin(row:Int, col:Int) -> Bool{
        if col+3 >= matrix[row].count{
            return false
        }
        if(matrix[row][col] == matrix[row][col+1]) &&
            (matrix[row][col+1] == matrix[row][col+2]) &&
            (matrix[row][col+2] == matrix[row][col+3]) &&
            (matrix[row][col+3] != "X") {
            return true
        }
        return false
    }
    func verticalWIn(row:Int, col:Int) -> Bool{
        if row+3 >= matrix.count{
            return false
        }
        if(matrix[row][col] == matrix[row+1][col]) &&
            (matrix[row+1][col] == matrix[row+2][col]) &&
            (matrix[row+2][col] == matrix[row+3][col]) &&
            (matrix[row+3][col] != "X") {
            return true
        }
        return false
    }
    func obliqueRightWin(row:Int, col:Int)->Bool{
        if row+3 >= matrix.count || col+3 >= matrix[row].count{
            return false
        }
        if(matrix[row][col] == matrix[row+1][col+1]) &&
            (matrix[row+1][col+1] == matrix[row+2][col+2]) &&
            (matrix[row+2][col+2] == matrix[row+3][col+3]) &&
            (matrix[row+3][col+3] != "X") {
            return true
        }
        return false
        
    }
    func obliqueLeftWin(row:Int, col:Int)->Bool{
        if row+3 >= matrix.count || col-3 < 0{
            return false
        }
        if(matrix[row][col] == matrix[row+1][col-1]) &&
            (matrix[row+1][col-1] == matrix[row+2][col-2]) &&
            (matrix[row+2][col-2] == matrix[row+3][col-3]) &&
            (matrix[row+3][col-3] != "X") {
            return true
        }
        return false
    }
    
    //MARK:- Player move
    
    func printMatrix(){
        print("Matrix is:")
        for row in 0...(matrix.count - 1) {
            for col in 0...(matrix[row].count - 1){
                print("(\(row),\(col)) \(matrix[row][col]) ", terminator:"") //print all element in the same line
            }
            print("") // new line
        }
    }
    
    func addDiskToColumn(colIndex: Int){
        if diskSize == nil || colIndex<0 || colIndex>6{
            return
        }
        if diskColSum[colIndex] == 6{ //check if there is space for new disk in this column
            return
        }
        
        let numberOfDisk :CGFloat = CGFloat(diskColSum[colIndex])
        let bottomPlace = numberOfDisk * (diskVerticalSapce+diskSize!) + diskVerticalSapce
        
        diskColSum[colIndex] += 1

        let view1 = UIView()
        switchTurn(view1: view1, colIndex: colIndex)
        
        columnView[colIndex].addSubview(view1)
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.bottomAnchor.constraint(equalTo: columnView[colIndex].bottomAnchor, constant: -bottomPlace).isActive = true
        view1.leadingAnchor.constraint(equalTo: columnView[colIndex].leadingAnchor, constant: diskHorizontalSpaceFromCol).isActive = true
        view1.trailingAnchor.constraint(equalTo: columnView[colIndex].trailingAnchor, constant: -diskHorizontalSpaceFromCol).isActive = true
        view1.heightAnchor.constraint(equalToConstant: diskSize!).isActive = true
        view1.layer.cornerRadius = diskSize!/2
        view1.layer.masksToBounds = true
        
        allDiskView.append(view1)
        checkForVictory()
    }
    
    //switch the color order to the user turn
    func switchTurn(view1: UIView, colIndex: Int){
        if isYellowTurn{
            view1.backgroundColor = .yellow
            matrix[6-diskColSum[colIndex]][colIndex] = "Y"
            gameControlView.backgroundColor = .red
            controlLabel.textColor = .white
            controlLabel.text = "Red Turn"
        }else{
            view1.backgroundColor = .red
            matrix[6-diskColSum[colIndex]][colIndex] = "R"
            gameControlView.backgroundColor = .yellow
            controlLabel.textColor = .black
            controlLabel.text = "Yellow Turn"
        }
        isYellowTurn = !isYellowTurn
    }
    
    //MARK:- User tap hanle
    
    
    func addTargetForCol(){

        columnView.forEach { (view) in
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        }
    }

    @objc func handleTap(gesture: UITapGestureRecognizer){
       
        let tapLocation = (gesture.location(in: nil)).x

        let viewIndex = getViewIndexFromXLocation(tapLocation: tapLocation)
        addDiskToColumn(colIndex: viewIndex)

    }
    
    
    //retrun the view index that the user press on
    func getViewIndexFromXLocation(tapLocation: CGFloat) -> Int{

        diskSize = columnView[0].frame.size.width - 4 //get the right disk view size
        
        switch (tapLocation) {
            
        case columnView[0].frame.origin.x...columnView[1].frame.origin.x :
            return 0
            
        case columnView[1].frame.origin.x...columnView[2].frame.origin.x :
            return 1
            
        case columnView[2].frame.origin.x...columnView[3].frame.origin.x :
            return 2
            
        case columnView[3].frame.origin.x...columnView[4].frame.origin.x :
            return 3
            
        case columnView[4].frame.origin.x...columnView[5].frame.origin.x :
            return 4
            
        case columnView[5].frame.origin.x...columnView[6].frame.origin.x :
            return 5
            
        case columnView[6].frame.origin.x...:
            return 6
            
        default :
            print("Error: no view selected")
        }
        return -1
    }

    
    
    func createColumn(){
        for _ in 0...6{
            let view = UIView()
            view.backgroundColor = .blue
            columnView.append(view)
        }
        
    }
    
    
    //MARK:- Setup view
    
    
    func setupViewsConstraints(){
        
        view.backgroundColor = .lightGray
        
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .white
        //backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(gameControlView)
        gameControlView.addSubview(controlLabel)
        gameControlView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gameControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gameControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameControlView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        
        controlLabel.centerYAnchor.constraint(equalTo: gameControlView.centerYAnchor).isActive = true
        controlLabel.centerXAnchor.constraint(equalTo: gameControlView.centerXAnchor).isActive = true
    }
    
    
    func setupOverallStackViewConstraints(){
        
        //overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        overallStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true

        //edge space
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 10, left: 12, bottom: 10, right: 12)
        
        overallStackView.spacing = colSapce
        overallStackView.distribution = .fillEqually
        
    }

}

