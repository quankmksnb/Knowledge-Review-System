package services;

import java.security.MessageDigest;
import java.util.Base64;

public class StringEncoder {
    public static String encodePassword(String password) {
        String salt = "abc@@@defgh;12345"; // Static salt for complexity
        String result = null;
        password = password + salt;
        try {
            byte[] dataBytes = password.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] hashBytes = md.digest(dataBytes);
            result = Base64.getEncoder().encodeToString(hashBytes);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
//        System.out.println("Password: " + password); // Debugging line
//        System.out.println("Hashed Password: " + result); // Debugging line
        return result;
    }

    public static boolean matches(String password, String hashPassword){
        //System.out.println(password + " " + hashPassword + " " + encodePassword(password));

        return hashPassword.equals(encodePassword(password));
    }
}
