package com.tbc.config;

import java.io.IOException;
import java.util.Properties;

public class AppProperties {

    private static AppProperties instance;
    private Properties properties;

    private AppProperties() {
        // Load properties from the resources folder
        properties = new Properties();
        try {
            properties.load(getClass().getClassLoader().getResourceAsStream("application.properties"));
        } catch (IOException e) {
            e.printStackTrace();
            // Handle the exception as needed
        }
    }

    public static synchronized AppProperties getInstance() {
        if (instance == null) {
            instance = new AppProperties();
        }
        return instance;
    }

    public Properties getProperties() {
        return properties;
    }
}
