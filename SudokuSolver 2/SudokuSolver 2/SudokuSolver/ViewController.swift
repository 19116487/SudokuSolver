

import UIKit

class ViewController: UIViewController, SudokuDelegate {
    
    var sudoku = Sudoku()

    @IBOutlet weak var sudokuContainer: UIStackView!
    var textFields = [[UITextField]]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextFields()
        sudoku.delegate = self

        
    }
    
    
    @IBAction func solveClicked(_ sender: Any) {
        if(sudoku.startSolvingSudoku(textFields : textFields)) {
           
    } else {
        print("invalid question")
    }
}
   
    func sudokuUpdate(cells: [[SudokuCell]]) {
        for row in 0..<9{
            for column in 0..<9{
                textFields[row][column].text = cells.isEmpty ? "" : "\(cells[row][column].value)"
            }
        }

    }
    
    @IBAction func resetClicked(_ sender: Any) {
        for tfRow in textFields{
            for tf in tfRow{
                tf.text = ""
            }
        }
    }
    
    
    
    
    func linkTextFields(){
        for row in 11...19{
            let rowContainer = sudokuContainer.viewWithTag(row)
            var textFieldRow = [UITextField]()
            for column in 1...9{
                let textField = rowContainer?.viewWithTag(column) as! UITextField
                textFieldRow.append(textField)
            }
            textFields.append(textFieldRow)
        }
    }
}

