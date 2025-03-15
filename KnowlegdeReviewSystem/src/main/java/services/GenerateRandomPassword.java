package services;

import java.security.SecureRandom;

public class GenerateRandomPassword {
    private static final String LOWER_CASE_CHARS = "abcdefghijklmnopqrstuvwxyz";
    private static final String UPPER_CASE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String DIGITS = "0123456789";
    private static final String ALL_CHARS = LOWER_CASE_CHARS + UPPER_CASE_CHARS + DIGITS;

    // Hàm tạo mật khẩu ngẫu nhiên
    public static String generateRandomPassword(int length) {
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(length);

        // Đảm bảo ít nhất có một chữ cái viết hoa
        password.append(UPPER_CASE_CHARS.charAt(random.nextInt(UPPER_CASE_CHARS.length())));

        // Tạo các ký tự ngẫu nhiên còn lại
        for (int i = 1; i < length; i++) {
            password.append(ALL_CHARS.charAt(random.nextInt(ALL_CHARS.length())));
        }

        return password.toString();
    }
}
