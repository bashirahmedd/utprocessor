package com.tbc.components;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import com.tbc.BashScriptExecutor;

public class ResetUnzipMerge {

    JButton resetBtn;
    JButton unzipBtn;
    JButton mergeAnsBtn;

    public ResetUnzipMerge(Properties properties, BashScriptExecutor parent, JPanel panel) {

        // Create buttons
        resetBtn = new JButton("Reset");
        unzipBtn = new JButton("Unzip");
        mergeAnsBtn = new JButton("Merge");

        ActionListener buttonClickListener = new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {

                JButton clickedButton = (JButton) e.getSource();
                clickedButton.setEnabled(false);

                if (e.getSource() == resetBtn) {
                    int result = JOptionPane.YES_OPTION;

                    if (parent.getCurrentNumber() > 0) {

                        // Display a confirmation dialog
                        result = JOptionPane.showConfirmDialog(
                                parent,
                                "Do you want to proceed?",
                                "Confirmation",
                                JOptionPane.YES_NO_OPTION);

                        if (result == JOptionPane.NO_OPTION) {
                            ((JButton)e.getSource()).setEnabled(true);
                            return;
                        }
                    }
                    parent.updateNumberField(0);
                }

                if (parent.getCurrentNumber() > 0) {
                    if (e.getSource() == unzipBtn || e.getSource() == mergeAnsBtn) {
                        ((JButton) e.getSource()).setEnabled(true);
                        return; // don't execute script
                    }
                }

                String scriptFileName = properties.getProperty(clickedButton.getActionCommand());
                executeBashScript(scriptFileName, clickedButton);
            }
        };

        resetBtn.setActionCommand("bash.reset");
        unzipBtn.setActionCommand("bash.unzip");
        mergeAnsBtn.setActionCommand("bash.merge_answers");

        resetBtn.addActionListener(buttonClickListener);
        unzipBtn.addActionListener(buttonClickListener);
        mergeAnsBtn.addActionListener(buttonClickListener);

        panel.add(resetBtn);
        panel.add(unzipBtn);
        panel.add(mergeAnsBtn);
    }

    private void executeBashScript(String scriptFileName, JButton button) {

        try {
            System.out.println("Executing :" + scriptFileName);

            // Set the script file path
            String scriptFilePath = new File(scriptFileName).getAbsolutePath();

            // Create process builder for the Bash script
            ProcessBuilder processBuilder = new ProcessBuilder("bash", scriptFilePath);

            // Start the process
            Process process = processBuilder.start();

            // Wait for the process to finish
            int exitCode = process.waitFor();

            // Read the output of the script
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            // Display the exit code
            System.out.println("Script exited with code: " + exitCode);
            // Enable the button after script execution
            button.setEnabled(true);
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            // Enable the button in case of an exception
            button.setEnabled(true);
        }
    }

    public JButton getResetButton() {
        return resetBtn;
    };

    public JButton getUnzipButton() {
        return unzipBtn;
    };

    public JButton getMergeAnsButton() {
        return mergeAnsBtn;
    };

}
