package com.visa.bo.util.wifi;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;

public class WifiManager {

    private WifiManager() {
        // Utility class
    }

    public static String getCurrentIpAddress() throws Exception {
        Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();

        while (interfaces.hasMoreElements()) {
            NetworkInterface networkInterface = interfaces.nextElement();

            if (!networkInterface.isUp() || networkInterface.isLoopback() || networkInterface.isVirtual()) {
                continue;
            }

            String displayName = networkInterface.getDisplayName().toLowerCase();
            String name = networkInterface.getName().toLowerCase();

            // Patterns pour Windows, Linux, Mac
            boolean isWifi =
                    // Windows
                    displayName.contains("wifi") ||
                            displayName.contains("wi-fi") ||
                            displayName.contains("wireless") ||
                            displayName.contains("sans fil") || // Français
                            // Linux
                            name.startsWith("wlan") ||
                            name.startsWith("wl") ||
                            name.startsWith("wlp") ||
                            // Mac
                            name.startsWith("en") && displayName.contains("airport") ||
                            displayName.contains("wi-fi");

            System.out.println("Interface: " + name + " (" + displayName + ") - WiFi: " + isWifi);

            if (!isWifi) {
                continue;
            }

            Enumeration<InetAddress> addresses = networkInterface.getInetAddresses();
            while (addresses.hasMoreElements()) {
                InetAddress address = addresses.nextElement();
                if (address instanceof Inet4Address && !address.isLoopbackAddress()) {
                    return address.getHostAddress();
                }
            }
        }
        return getIpLocal();
    }

    private static String getIpLocal() throws Exception {
        return "127.0.0.1";
    }
}