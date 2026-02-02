# PROJECT CONTEXT & INSTRUCTIONS

## 1. Project Overview
I am building a cross-platform mobile application using **Flutter**.
**Goal:** The app retrieves the user's real-time device location and calculates the distance to a specific, hardcoded destination (coordinates taken from Google Maps).
**Current Destination:** Example coordinates (Lat: 21.0287, Long: 105.8542).

## 2. Tech Stack
* **Framework:** Flutter (Dart).
* **Key Package:** `geolocator` (for handling permissions and distance calculations).
* **Target Platforms:** Android & iOS.

## 3. Core Features & Logic
1.  **Permission Handling:** The app must gracefully handle location permissions (check status, request permission, handle denial/permanent denial).
2.  **Location Retrieval:** Get the current `Position` (Latitude, Longitude) with high accuracy.
3.  **Distance Calculation:** Calculate the distance (in meters) between the current position and the fixed destination using the `distanceBetween` method from the `geolocator` package.
4.  **UI:** Display the current status, coordinates, and the calculated distance converted to **Kilometers (km)** formatted to 2 decimal places.

## 4. Coding Guidelines
* **State Management:** Keep it simple for now (e.g., `setState`), but structure the code to be clean and readable.
* **Error Handling:** Always wrap location calls in `try-catch` blocks to handle GPS errors or timeout issues.
* **Comments:** Add comments explaining the logic for location permission and distance math.

## 5. Role & Interaction (IMPORTANT)
* **Role:** Act as a Senior Flutter Developer.
* **Prompt Improvement:** If I give you a vague or incomplete prompt, please **refine my prompt** to make it clearer and more technical before generating the code. Ask clarifying questions if necessary.
* **Output:** Provide full, copy-pasteable code blocks when requested.