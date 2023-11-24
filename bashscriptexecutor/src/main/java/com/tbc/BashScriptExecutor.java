package com.tbc;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class BashScriptExecutor extends JFrame {
    public static void main(String[] args) {
        // Create an instance of the BashScriptExecutor class
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                new BashScriptExecutor();
            }
        });
    }
    public BashScriptExecutor() {
        // Set up the frame
        setTitle("Bash Script Executor");
        setSize(350, 70);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Create buttons
        JButton resetBtn = new JButton("Reset");
        JButton unzipBtn = new JButton("Unzip");

        // Add action listeners to the buttons
        resetBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                executeBashScript("reset_for_assignment.sh");
            }
        });

        unzipBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                executeBashScript("unzip_newfile.sh");
            }
        });

        // Create a panel and add buttons to it
        JPanel panel = new JPanel();
        panel.setLayout(new FlowLayout());
        panel.add(resetBtn);
        panel.add(unzipBtn);

        // Add the panel to the frame
        add(panel);

        // Set the frame visible
        setVisible(true);
    }

    private void executeBashScript(String scriptFileName) {
        try {
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

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
