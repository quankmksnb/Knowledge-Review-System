package com.example.servlets;

import controllers.WebManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.Files;

@WebServlet("/UploadAvatarServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AvatarUpload extends HttpServlet {
    private static final String UPLOAD_DIR = "images"; // Save inside webapp/images

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("profile?error=No file selected");
            return;
        }

        // Extract the original filename from the uploaded file
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Define the upload directory (relative to the web app root)
        String uploadDirPath = "uploads"; // Define this as a constant somewhere, e.g., UPLOAD_DIR
        String absoluteUploadPath = getServletContext().getRealPath("") + File.separator + uploadDirPath;
        File uploadDir = new File(absoluteUploadPath);

        // Create the directory if it doesn’t exist
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Save the file to the upload directory
        File file = new File(absoluteUploadPath, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        // Construct a relative path for the avatar (e.g., "/uploads/image.jpg")
        String avatarPath = "/" + uploadDirPath + "/" + fileName;

        // Update the user's avatar with the relative path
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                user.setAvatar(avatarPath); // Save the relative path as the avatar "link"
                WebManager.getInstance().getUserDAO().update(user);
            }
        }

        // Redirect to the profile page with the avatar filename as a parameter
        response.sendRedirect("profile");
    }
}
