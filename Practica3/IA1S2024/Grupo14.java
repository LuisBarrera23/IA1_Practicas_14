package IA1S2024;
import robocode.*;
import java.awt.Color;
import java.awt.geom.Point2D;
import java.util.ArrayList;

public class Grupo14 extends AdvancedRobot {

    private byte direccionMovimiento = 1;
    private boolean escaneadoReciente = false;
    private ArrayList<double[]> waves = new ArrayList<>();
    private double[] surfStats = new double[47];

    public void run() {
        setColors(Color.red, Color.blue, Color.green); // Colores del robot
        setAdjustGunForRobotTurn(true); // Permite que el cañón gire independientemente del cuerpo del robot
        setAdjustRadarForGunTurn(true); // Permite que el radar gire independientemente del cañón del robot

        // Bucle principal del robot
        while (true) {
            if (!escaneadoReciente) {
                setTurnRadarRight(360); // Gira el radar 360 grados continuamente para escanear el entorno
            }
            execute(); // Ejecuta todas las acciones pendientes
            escaneadoReciente = false; // Resetea el estado de escaneo
        }
    }

    public void onScannedRobot(ScannedRobotEvent e) {
        escaneadoReciente = true; // Marca que un robot fue escaneado recientemente
        double direccionAbsoluta = getHeading() + e.getBearing(); // Calcula la dirección absoluta hacia el robot enemigo
        double direccionDesdeCañon = normalRelativeAngleDegrees(direccionAbsoluta - getGunHeading()); // Calcula el ángulo relativo desde el cañón hacia el enemigo

        // Movimiento oscilante para hacer más difícil que el robot sea alcanzado
        setAhead(150 * direccionMovimiento); // Movimiento más largo
        setTurnRight(e.getBearing() + 90 - (20 * direccionMovimiento)); // Aumenta el cambio de dirección
        
        // Cambia la dirección de movimiento aleatoriamente para evitar predecibilidad
        if (Math.random() > 0.8) {
            direccionMovimiento *= -1;
        }

        // Mejora en el bloqueo del radar
        setTurnRadarRight(normalRelativeAngleDegrees(direccionAbsoluta - getRadarHeading()));

        // Disparo predictivo mejorado
        if (Math.abs(direccionDesdeCañon) <= 2) { // Ajuste más fino
            setTurnGunRight(direccionDesdeCañon); // Ajusta la dirección del cañón
            if (getGunHeat() == 0 && getEnergy() > 10) { // Dispara solo si el cañón no está sobrecalentado y hay suficiente energía
                setFire(Math.min(400 / e.getDistance(), 3)); // Dispara con una potencia proporcional a la distancia
            }
        } else {
            setTurnGunRight(direccionDesdeCañon); // Ajusta la dirección del cañón si no está alineado
        }

        // Crear una ola para el wave surfing
        double bulletPower = Math.min(3, Math.max(0.1, 400 / e.getDistance()));
        double bulletSpeed = 20 - 3 * bulletPower;
        waves.add(new double[]{getTime(), e.getDistance(), bulletSpeed, direccionAbsoluta});
        
        scan(); // Continúa escaneando después de realizar las acciones
    }

    // Método llamado cuando el robot es golpeado por una bala
    public void onHitByBullet(HitByBulletEvent e) {
        direccionMovimiento *= -1; // Invierte la dirección de movimiento para evadir
        setAhead(150 * direccionMovimiento); // Movimiento más largo
    }

    // Método llamado cuando el robot choca con una pared
    public void onHitWall(HitWallEvent e) {
        direccionMovimiento *= -1; // Invierte la dirección de movimiento para alejarse de la pared
        setAhead(150 * direccionMovimiento); // Movimiento más largo
    }

    // Método llamado cuando el robot choca con otro robot
    public void onHitRobot(HitRobotEvent e) {
        direccionMovimiento *= -1; // Invierte la dirección de movimiento para evitar quedarse atascado
        setAhead(150 * direccionMovimiento); // Movimiento más largo
        setTurnRight(90 - (30 * direccionMovimiento)); // Gira en un ángulo más amplio
    }

    // Método para normalizar un ángulo entre -180 y 180 grados
    private double normalRelativeAngleDegrees(double angulo) {
        double anguloNormalizado = angulo;

        while (anguloNormalizado > 180) {
            anguloNormalizado -= 360;
        }
        while (anguloNormalizado < -180) {
            anguloNormalizado += 360;
        }

        return anguloNormalizado;
    }
}
