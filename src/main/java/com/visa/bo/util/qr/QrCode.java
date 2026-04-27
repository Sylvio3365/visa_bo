package com.visa.bo.util.qr;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

public class QrCode {

    private static final int DEFAULT_SIZE = 300;

    private QrCode() {
        // Utility class
    }

    public static BufferedImage generateFromUrl(String url) throws WriterException {
        return generateFromUrl(url, DEFAULT_SIZE, DEFAULT_SIZE);
    }

    public static BufferedImage generateFromUrl(String url, int width, int height) throws WriterException {
        validateUrl(url);
        validateSize(width, height);
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(url, BarcodeFormat.QR_CODE, width, height);
        return MatrixToImageWriter.toBufferedImage(bitMatrix);
    }

    public static Path exportToImage(String url, String outputFile) throws IOException, WriterException {
        return exportToImage(url, Path.of(outputFile), DEFAULT_SIZE, DEFAULT_SIZE);
    }

    public static Path exportToImage(String url, Path outputPath, int width, int height)
            throws IOException, WriterException {
        Objects.requireNonNull(outputPath, "outputPath ne doit pas etre null");

        BufferedImage qrImage = generateFromUrl(url, width, height);
        Path parent = outputPath.toAbsolutePath().getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        ImageIO.write(qrImage, "PNG", outputPath.toFile());
        return outputPath;
    }

    private static void validateUrl(String url) {
        if (url == null || url.isBlank()) {
            throw new IllegalArgumentException("L'URL du QR code est obligatoire");
        }
    }

    private static void validateSize(int width, int height) {
        if (width <= 0 || height <= 0) {
            throw new IllegalArgumentException("La taille du QR code doit etre positive");
        }
    }
}