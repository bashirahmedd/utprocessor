package com.tbc.services;

import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Rectangle;

public class ScreenDetail {

    private Rectangle rect;

    public   ScreenDetail() {

        int minx = 0, miny = 0, maxx = 0, maxy = 0;
        GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
        for (GraphicsDevice device : environment.getScreenDevices()) {
            Rectangle bounds = device.getDefaultConfiguration().getBounds();
            minx = Math.min(minx, bounds.x);
            miny = Math.min(miny, bounds.y);
            maxx = Math.max(maxx, bounds.x + bounds.width);
            maxy = Math.max(maxy, bounds.y + bounds.height);
        }
        rect = new Rectangle(minx, miny, maxx - minx, maxy - miny);
    }

    public Rectangle getRectangle(){
        return rect;
    }

}
