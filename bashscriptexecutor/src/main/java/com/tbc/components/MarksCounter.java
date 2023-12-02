package com.tbc.components;

import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class MarksCounter {

    private float currentNumber = 0;
    private JTextField numberField;
    
    public MarksCounter(JPanel panel){

        // Create components
        numberField = new JTextField(10);
        numberField.setText(String.valueOf(currentNumber));
        numberField.setEditable(false); // Make the field read-only

        Font boldFont = new Font(numberField.getFont().getName(), Font.BOLD, 30);
        numberField.setFont(boldFont);
        numberField.setHorizontalAlignment(JTextField.CENTER);

        JButton incrementButton = new JButton("+Incr");
        JButton decrementButton = new JButton("-Decr");

        panel.add(numberField);
        panel.add(incrementButton);
        panel.add(decrementButton);

        ActionListener buttonListener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (e.getSource() == incrementButton) {
                    currentNumber += 0.5;
                } else if (e.getSource() == decrementButton) {
                    if (currentNumber > 0) {
                        currentNumber -= 0.5;
                    }
                }
                updateNumberField(currentNumber);
            }
        };
        incrementButton.addActionListener(buttonListener);
        decrementButton.addActionListener(buttonListener);
    }

    private void updateNumberField(float currentNumber) {
        numberField.setText(String.valueOf(currentNumber));
    }

    public void setCurrentNumber(float num){
        currentNumber=num;
    }
    public JTextField getMarksField(){
        return numberField;
    }
}
