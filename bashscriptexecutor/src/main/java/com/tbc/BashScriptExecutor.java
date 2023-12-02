package com.tbc;

import java.awt.GridLayout;
import java.awt.Rectangle;

import java.util.Properties;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

import com.tbc.components.MarksCounter;
import com.tbc.components.ResetUnzipMerge;
import com.tbc.config.AppProperties;
import com.tbc.services.ScreenDetail;

public class BashScriptExecutor extends JFrame {

    private int initW = 270;
    private int initH = 140;

    public static void main(String[] args) {

        // Create an instance of the BashScriptExecutor class
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                new BashScriptExecutor();
            }
        });
    }

    private AppProperties appProperties;
    private JTextField numberField;
    private MarksCounter marksCounter;

    public BashScriptExecutor() {
        
        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout(2, 3));
        
        appProperties = AppProperties.getInstance();
        Properties properties = appProperties.getProperties();
        ScreenDetail screenDetail = new ScreenDetail();
        new ResetUnzipMerge(properties, this,  panel);
        marksCounter = new MarksCounter(panel);
        numberField = marksCounter.getMarksField();
        
        setTitle("Bash Script Executor");
        setSize(initW, initH);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        add(panel);

        Rectangle recScreen = screenDetail.getRectangle();
        setLocation((int) recScreen.getWidth() - initW, 0);
        setVisible(true);
    }

    public void updateNumberField(float currentNumber) {
        marksCounter.setCurrentNumber(currentNumber);
        numberField.setText(String.valueOf(currentNumber));
    }
}
