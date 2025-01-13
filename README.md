# Marvel Rivals Macro - Enhance Your Gameplay!

A quality-of-life improvement macro for Marvel Rivals, built with Autohotkey v2 and AutoHotInterception.

**Disclaimer:** This macro interacts with the game by simulating keyboard and mouse inputs and analyzing the screen visually. It does **not** access game memory, files, or any sensitive data, aiming for the safest possible interaction method. However, use it at your own discretion. The developer is not responsible for any consequences arising from its use.

---

## Key Features:

* **No RAM, Window, or File Detection:** Operates purely through simulated inputs and screen analysis.
* **Quality of Life Enhancement:** Not a "one-click win," but significantly improves gameplay, especially for certain heroes.
* **Configurable Minimum HP Threshold:**  Customize when abilities are triggered based on your hero's health.
* **Hero-Specific Macros:**  Tailored functionality for individual characters.
* **Easy On/Off Switch:** Toggle the macro with a simple hotkey (`Ctrl + 1` by default).

---

## How It Works:

This macro utilizes your mouse and keyboard handles to send inputs and performs image searches on your screen. Because of this, there are specific setup requirements to ensure it functions correctly.

---

## Setup Instructions:

**1. Extraction:**

   * Extract the contents of the downloaded zip file to a folder of your choice.

**2. Install Interception Driver (if needed):**

   * Navigate to the "interception installation" folder.
   * Run `Run As Admin - Install.bat` **as administrator**.
   * **Restart your computer** after installation.

**3. Screen Resolution:**

   * Your primary monitor's resolution **must be 1920x1080**. (Support for other resolutions may be added in the future).

**4. Game Display Mode:**

   * Set your game to **Borderless Window** mode.

**5. In-Game Accessibility Settings:**

   * Go to **Settings > Accessibility**.
   * Set **HP Bar Color** to **Blue**.
   * Setting **Shield HP Bar Color** to **Blue** is also recommended for optimal performance. (Support for other colors may be added in the future).

**6. Keybind Layout (Required for now):**

   * Navigate to **Settings > Keyboard > Combat**.
   * Configure your keybinds as follows:
     * **Secondary Attack:** Right Mouse Button
     * **Ability 1:** Middle Mouse Button
     * **Ability 2:** E
     * **Ability 3:** F
     * **(Optional)** Ultimate: Left Shift (LShift)
     * **(Optional)** Ping: Q
     * **(Optional)** Melee: V
   * (Support for custom key layouts may be added in the future).

**7. Hero-Specific Settings:**

   * **Hulk:** Ensure "Hold to activate Incredible Leap" is **ON** (default).
   * **Captain America:** Ensure "Hold to Raise Shield" is **ON** (default). It is also suggested to turn **OFF** "Hold to Dash."

**8. Initial Program Start:**

   * Upon the first launch of the macro script, you need to **move your mouse and press a key** on your keyboard. This allows the script to capture the necessary input handles.

**9. Toggling the Macro:**

   * The macro has an **on/off switch** controlled by pressing **`Ctrl + 1`**.
   * The default state is "on." Pressing the hotkey will toggle it.
   * You should see an **on-screen notification** in the center of your screen indicating the current state.
   * **If you don't see the notification:** The DLL might be blocked by your system.
     * Navigate to the "Lib" folder.
     * Run `Unblocker.ps1` **as administrator**.
     * **Restart your computer** to ensure the changes are applied.

**10. Running the Macro:**

   * After completing all the steps, open the macro program and launch Marvel Rivals.
   * In the macro interface:
     * **Select the hero** you want to use the macro with.
     * **Choose the specific ability** for the macro.
     * **Adjust the slider** to set the **minimum HP percentage** at which the ability will be automatically activated.
     * Ensure the **"Auto send"** option is enabled.

---

## Best Use Cases and Supported Heroes:

This macro provides significant improvements for specific heroes and abilities:

**Defense:**

* **Hulk (Indestructible Guard):** Makes Hulk significantly more playable and powerful. The Jump macro does not require an HP check.
* **Captain America (Living Legend)**
* **Venom (Symbiotic Resilience)**
* **Magneto (Iron Bulwark / Metallic Curtain)**
* **Thor (Lightning Realm)**

**Attack:**

* **Scarlet Witch (Mystic Projection)**
* **Namor (Blessing of The Deep)**
* **Psylocke (Psychic Stealth)**
* **Wolverine (Undying Animal)**
* **Mister Fantastic (Reflexive Rubber)**

**Healer:**

* **Loki (Deception)**
* **Mantis (Natural Anger)**
* **Rocket Raccoon (Repair Mode)**
* **Luna Snow (Ice Arts)**
* **Adam Warlock (Avatar Life Stream)**
* **Jeff The Land Shark (Hide and Seek)**
* **Invisible Woman (Double Jump (Invisible (Heal)))**

**Image:**
![Placeholder for a screenshot or GIF demonstrating the macro in action](placeholder_image_url_here.png)
*(Replace `placeholder_image_url_here.png` with a link to an actual image if available)*

---

## Download:

**Download**

* **Status:** Stable versions are in the 'Releases Section". Please download from there.

---

## Feedback and Support:

If you encounter any issues, have suggestions for improvements, or would like to see support for more heroes or features, please don't hesitate to reply to the relevant post and provide details.

---

## Support the Project:

I hope you enjoy using this macro! If you find it helpful and would like to support further development of this and other undetected macro projects, consider sending a small donation:

**mBTC Address:** `bc1qu5x7rznj7fll7z23n8nl2v3ezz34c5cfc962h0`

Every contribution, no matter the size, is greatly appreciated and motivates me to continue creating!

---

Thank you, and happy gaming!