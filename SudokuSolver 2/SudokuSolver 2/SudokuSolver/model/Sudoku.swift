

import Foundation
import UIKit

protocol SudokuDelegate {
    func sudokuUpdate(cells : [[SudokuCell]])
}

struct SudokuCell {
    var value = 0
    var isQuestion = false
    var isEmpty : Bool{
        return (value == 0)
    }
}

struct SudokuCursor {
    var row = 0
    var column = 0
    var direction = 1
    mutating func move(){
        if direction == 1{
            if row == 8 && column == 8{
                return
            }
            //move forward
            column = column + 1
            if column > 8 {
                column = 0
                row = row + 1
            }
        }else{
            //move backward
            if row == 0 && column == 0 {
                return
            }
            column = column - 1
            if column < 0 {
                column = 8
                row = row - 1
            }
            
        }
    }
}

class Sudoku {
    var cells:[[SudokuCell]]
    var delegate : SudokuDelegate?
    var timer : Timer?
    var cursor = SudokuCursor()
    
    init() {
        cells = [[SudokuCell]]()
        resetSudoku()
    }
    
     func resetSudoku() {
        cursor.direction = 1
        cursor.column = 0
        cursor.row = 0
        for _ in 0..<9{
            var row = [SudokuCell]()
            
            for _ in 0..<9{
                row.append(SudokuCell())
            }
            cells.append(row)
        }
    }
     func startSolvingSudoku( textFields : [[UITextField]] ) -> Bool{
//        //step1 - reset
//        resetSudoku()
//        //step2 - copy question
//        copySudoku(textFields: textFields)
//        printSudoku()
//        //step3 - vaildate question
//        if vaildate() == false{
//            return false
//        }
//        //step4 - solve
//        self.solve()
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {
            t in
            if (self.cursor.column == 8 && self.cursor.row == 8){
                t.invalidate()
                self.timer = nil
                //step1 - reset
                self.resetSudoku()
                //step2 - copy question
                self.copySudoku(textFields: textFields)
                self.printSudoku()
                //step3 - vaildate question
                if self.vaildate() == false{
                    return
                }
                //step4 - solve
                self.solve()
            }else{
                self.cells[self.cursor.row][self.cursor.column].value = 2
                self.delegate?.sudokuUpdate(cells: self.cells)
                self.cursor.move()
            }
            t.invalidate()
        })

        return true
    }
    
    
     func solve(){
        
        while(!solved()){
            let cell = cells[cursor.row][cursor.column]
            if cell.isQuestion{
                //move forward or backward
                cursor.move()
                
            }else{
                let start = cell.value + 1
                if start > 9 {
                    cells[cursor.row][cursor.column] = SudokuCell(value: 0, isQuestion: false)
                    //backward
                    cursor.direction = -1
                }else{
                    for value in start...9 {
                    //forward
                    
                        if checkRow(cursor, valueToCheck: value) && checkColumn(cursor, valueToCheck: value) && check3x3(cursor, valueToCheck: value){
                            cells[cursor.row][cursor.column] = SudokuCell(value: value, isQuestion: false)
                            
                            // forward
                            cursor.direction = 1
                            break
                        }else{
                            cells[cursor.row][cursor.column] = SudokuCell(value: 0, isQuestion: false)
                            
                            //move backward
                            cursor.direction = -1
                        }
                    }
                    
                }
                cursor.move()
            }
            
        }
        delegate?.sudokuUpdate(cells: cells)
        printSudoku()
        
    }
    
    func solved() -> Bool{
        for x in 0...8 {
            for y in 0...8{
                if cells[x][y].isEmpty{
                    
                    return false
                    
                }
            }
        }
        return true
    }
    
     func copySudoku(textFields : [[UITextField]]) {
        for row in 0..<9{
            for column in 0..<9{
                let value = Int(textFields[row][column].text!) ?? 0
                if value > 0 && value < 10 {
                    cells[row][column] = SudokuCell(value: value, isQuestion: true)
                }else{
                    cells[row][column] = SudokuCell()
                }
            }
        }
    }
    
    func vaildate() -> Bool{
        for row in 0..<9{
            for column in 0..<9{
                if !cells[row][column].isEmpty{
                    let cursor = SudokuCursor(row: row, column: column)
                    let value = cells[row][column].value
                    if checkRow(cursor, valueToCheck: value) == false ||  checkColumn(cursor, valueToCheck: value) == false || check3x3(cursor, valueToCheck: value) == false{
                        return false
                    }
                    
                }
            }
        }
        return true
    }
    
    
    func checkColumn(_ cursor : SudokuCursor, valueToCheck : Int) -> Bool {
        let cursorRow = cursor.row
        let cursorColumn = cursor.column
        for row in 0..<9 {
            if cells[row][cursorColumn].value == valueToCheck && cursorRow != row{
                return false
            }
        }
        return true
    }
    
    func checkRow(_ cursor : SudokuCursor, valueToCheck : Int) -> Bool {
        let cursorRow = cursor.row
        let cursorColumn = cursor.column
        for column in 0..<9 {
            if cells[cursorRow][column].value == valueToCheck && cursorColumn != column{
                return false
            }
        }
        return true
    }
    
    func check3x3(_ cursor : SudokuCursor, valueToCheck : Int) -> Bool {
        let cursorRow = cursor.row
        let cursorColumn = cursor.column
        let rowOffset = get3x3Offset(pos: cursorRow)
        let columnOffset = get3x3Offset(pos: cursorColumn)
        
        for row in (0 + rowOffset)...(2 + rowOffset){
            for column in (0 + columnOffset)...(2 + columnOffset){
                if cells[row][column].value == valueToCheck && cursorRow != row && cursorColumn != column{
                    return false
                }
            }
        }
        return true
    }
    
    func get3x3Offset(pos: Int) -> Int {
        switch pos {
        case 0...2: return 0
        case 3...5: return 3
        default: return 6
        }
    }
    
    
    func printSudoku(){
        var text = ""
        for row in 0..<9{
            for column in 0..<9 {
                text = "\(text) \(cells[row][column].value)"
            }
            text = "\(text) \n"
        }
        
        print(text)
    }
}
