package services;

import java.util.regex.Pattern;

public class Utils {
    /**
     * Validates the subject code.
     *
     * @param code The subject code to validate
     * @return true if the code is valid (exactly 3 alphabetic characters), false otherwise
     */
    public static boolean isValidCode(String code) {
        // Check if code is null or not exactly 3 characters long
        if (code == null || code.length() != 3) {
            return false;
        }

        // Check if code contains only alphabetic characters
        return Pattern.matches("^[a-zA-Z]{3}$", code);
    }

    /**
     * Validates the subject name.
     *
     * @param name The subject name to validate
     * @return true if the name is valid (contains only letters, spaces, and numbers), false otherwise
     */
    public static boolean isValidName(String name) {
        // Check if name is null or empty
        if (name == null || name.trim().isEmpty()) {
            return false;
        }

        // Check if name contains only letters, spaces, and numbers
        return Pattern.matches("^[a-zA-Z0-9 ]+$", name);
    }

    /**
     * Throws an exception if the code is invalid.
     *
     * @param code The subject code to validate
     * @throws IllegalArgumentException if the code is invalid
     */
    public static void validateCode(String code) {
        if (!isValidCode(code)) {
            throw new IllegalArgumentException("Invalid subject code. Code must be exactly 3 alphabetic characters.");
        }
    }

    /**
     * Throws an exception if the name is invalid.
     *
     * @param name The subject name to validate
     * @throws IllegalArgumentException if the name is invalid
     */
    public static void validateName(String name) {
        if (!isValidName(name)) {
            throw new IllegalArgumentException("Invalid subject name. Name must contain only letters, numbers, and spaces.");
        }
    }

    /**
     * Main method to test validation methods
     *
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {
        // Test valid codes
        System.out.println("--- Testing Valid Codes ---");
        testCode("ABC", true);
        testCode("XYZ", true);
        testCode("qwe", true);

        // Test invalid codes
        System.out.println("\n--- Testing Invalid Codes ---");
        testCode("A1C", false);
        testCode("AB", false);
        testCode("ABCD", false);
        testCode("123", false);
        testCode("A B", false);
        testCode(null, false);

        // Test valid names
        System.out.println("\n--- Testing Valid Names ---");
        testName("Mathematics 101", true);
        testName("Physics Basic", true);
        testName("Computer Science", true);

        // Test invalid names
        System.out.println("\n--- Testing Invalid Names ---");
        testName("Math!", false);
        testName("Science@", false);
        testName("", false);
        testName(null, false);
        testName("Programming-Language", false);

        // Test validation methods with exceptions
        System.out.println("\n--- Testing Validation Methods ---");
        testValidationMethods();
    }

    /**
     * Helper method to test code validation
     *
     * @param code Code to test
     * @param expectedResult Expected validation result
     */
    private static void testCode(String code, boolean expectedResult) {
        boolean result = isValidCode(code);
        System.out.printf("Code: %-10s | Valid: %-6s | Expected: %-6s | %s%n",
                code == null ? "null" : code,
                result,
                expectedResult,
                result == expectedResult ? "PASS" : "FAIL");
    }

    /**
     * Helper method to test name validation
     *
     * @param name Name to test
     * @param expectedResult Expected validation result
     */
    private static void testName(String name, boolean expectedResult) {
        boolean result = isValidName(name);
        System.out.printf("Name: %-20s | Valid: %-6s | Expected: %-6s | %s%n",
                name == null ? "null" : name,
                result,
                expectedResult,
                result == expectedResult ? "PASS" : "FAIL");
    }

    /**
     * Helper method to test validation methods with exceptions
     */
    private static void testValidationMethods() {
        // Test valid scenarios
        try {
            validateCode("ABC");
            System.out.println("validateCode('ABC'): PASS");
        } catch (Exception e) {
            System.out.println("validateCode('ABC'): FAIL");
        }

        try {
            validateName("Mathematics 101");
            System.out.println("validateName('Mathematics 101'): PASS");
        } catch (Exception e) {
            System.out.println("validateName('Mathematics 101'): FAIL");
        }

        // Test invalid scenarios
        try {
            validateCode("A1C");
            System.out.println("validateCode('A1C'): FAIL - Should throw exception");
        } catch (IllegalArgumentException e) {
            System.out.println("validateCode('A1C'): PASS - Exception thrown");
        }

        try {
            validateName("Math!");
            System.out.println("validateName('Math!'): FAIL - Should throw exception");
        } catch (IllegalArgumentException e) {
            System.out.println("validateName('Math!'): PASS - Exception thrown");
        }
    }
}