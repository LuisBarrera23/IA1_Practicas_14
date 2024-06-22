package IA1S2024;

import robocode.AdvancedRobot;
import robocode.ScannedRobotEvent;
import robocode.HitByBulletEvent;
import robocode.HitWallEvent;
import java.awt.Color;

public class Grupo14 extends AdvancedRobot {

    boolean movingForward;

    public void run() {
        setColors(Color.red, Color.blue, Color.green);

        while (true) {
            if (movingForward) {
                setAhead(100);
            } else {
                setBack(100);
            }
            movingForward = !movingForward;

            turnGunRight(360);
        }
    }

    public void onScannedRobot(ScannedRobotEvent e) {
        double bearing = e.getBearing();
        turnRight(bearing);
        if (e.getDistance() < 150) {
            fire(2);
        } else {
            fire(1);
        }
        ahead(50);
    }

    public void onHitByBullet(HitByBulletEvent e) {
        back(20);
    }

    public void onHitWall(HitWallEvent e) {
        back(30);
        turnRight(90);
    }
}
