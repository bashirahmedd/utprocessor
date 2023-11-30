package com.tbc;

import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.GridLayout;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;

public class BashScriptExecutor extends JFrame {

    private int initW = 270;
    private int initH = 70;
    private Properties properties;

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

        // Load properties from the resources folder
        properties = new Properties();
        try {
            properties.load(getClass().getClassLoader().getResourceAsStream("application.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Set up the frame
        setTitle("Bash Script Executor");
        setSize(initW, initH);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Create buttons
        JButton resetBtn = new JButton("Reset");
        JButton unzipBtn = new JButton("Unzip");
        JButton mergeAnsBtn = new JButton("Merge");

        // Add a single ActionListener for all buttons
        ActionListener buttonClickListener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JButton clickedButton = (JButton) e.getSource();

                // Disable the clicked button
                clickedButton.setEnabled(false);

                // Get the script file path based on the button's action command
                String scriptFileName = properties.getProperty(clickedButton.getActionCommand());
                executeBashScript(scriptFileName, clickedButton);
            }
        };

        // Set the action command for each button
        resetBtn.setActionCommand("bash.reset");
        unzipBtn.setActionCommand("bash.unzip");
        mergeAnsBtn.setActionCommand("bash.merge_answers");

        // Add the common ActionListener to all buttons
        resetBtn.addActionListener(buttonClickListener);
        unzipBtn.addActionListener(buttonClickListener);
        mergeAnsBtn.addActionListener(buttonClickListener);

        // Create a panel and add buttons to it
        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout());
        panel.add(resetBtn);
        panel.add(unzipBtn);
        panel.add(mergeAnsBtn);

        // Add the panel to the frame
        add(panel);

        // display frame in the right top corner
        Rectangle recScreen = getMaximumScreenBounds();
        setLocation((int) recScreen.getWidth() - initW, 0);

        // Set the frame visible
        setVisible(true);
    }

    private void executeBashScript(String scriptFileName, JButton button) {

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
            // Enable the button after script execution
            button.setEnabled(true);
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            // Enable the button in case of an exception
            button.setEnabled(true);
        }
    }

    private Rectangle getMaximumScreenBounds() {

        int minx = 0, miny = 0, maxx = 0, maxy = 0;
        GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
        for (GraphicsDevice device : environment.getScreenDevices()) {
            Rectangle bounds = device.getDefaultConfiguration().getBounds();
            minx = Math.min(minx, bounds.x);
            miny = Math.min(miny, bounds.y);
            maxx = Math.max(maxx, bounds.x + bounds.width);
            maxy = Math.max(maxy, bounds.y + bounds.height);
        }
        return new Rectangle(minx, miny, maxx - minx, maxy - miny);
    }
}
