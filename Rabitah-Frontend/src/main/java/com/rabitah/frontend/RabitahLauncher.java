package com.rabitah.frontend;

/**
 * Standard JVM entry point for jpackage. Keeping this separate from the
 * JavaFX Application subclass avoids the Java launcher treating the bundled
 * app as an unconfigured JavaFX launch.
 */
public final class RabitahLauncher {
    private RabitahLauncher() {}

    public static void main(String[] args) {
        RabitahApplication.main(args);
    }
}
