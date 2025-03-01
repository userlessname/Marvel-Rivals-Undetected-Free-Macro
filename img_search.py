import cv2
import numpy as np
from mss import mss
import os
import libs.inter as inter
from keycodes import KeyCode as kc
import ctypes
from ctypes import wintypes
import pyperclip
import tooltip as tt
import pyautogui
import time
from enum import IntEnum
script_dir = os.path.dirname(os.path.abspath(__file__))

def move_mouse_relative(x_offset, y_offset):
    """Moves the mouse cursor relative to its current position.

    Args:
        x_offset: The amount to move the mouse horizontally (positive for right, negative for left).
        y_offset: The amount to move the mouse vertically (positive for down, negative for up).
    """
    try:
        current_x, current_y = pyautogui.position()  # Get the current mouse position
        new_x = current_x + x_offset
        new_y = current_y + y_offset

        # Optional: Add boundary checks to prevent going off-screen (highly recommended)
        screen_width, screen_height = pyautogui.size()
        new_x = max(0, min(new_x, screen_width - 1))  # Keep within screen bounds (left/right)
        new_y = max(0, min(new_y, screen_height - 1))  # Keep within screen bounds (top/bottom)
        
        pyautogui.moveTo(new_x, new_y, duration=0.25)  # Move the mouse,  duration adds smoothness (optional)
        # pyautogui.moveRel(x_offset, y_offset, duration = 0.25) could also be used instead of moveTo

    except pyautogui.FailSafeException:
        print("Fail-safe triggered! Mouse moved to a corner of the screen.")
        # You might want to add additional handling here, like exiting the program.
    except Exception as e:
        print(f"An error occurred: {e}")

def move_mouse_absolute(x, y):
    """Moves the mouse cursor to an absolute position on the screen.

    Args:
        x: The x-coordinate of the target position.
        y: The y-coordinate of the target position.
    """
    try:
        # Important:  Check if the coordinates are within the screen bounds.
        screen_width, screen_height = pyautogui.size()
        if 0 <= x < screen_width and 0 <= y < screen_height:
            pyautogui.moveTo(x, y, duration=0.25) # Duration makes the movement smoother (optional)
        else:
            print(f"Coordinates ({x}, {y}) are out of bounds. Screen size: {screen_width}x{screen_height}")

    except pyautogui.FailSafeException:
        print("Fail-safe triggered! Mouse moved to a corner of the screen.")
    except Exception as e:
        print(f"An error occurred: {e}")

def structural_similarity(img1, img2):
    """Simplified SSIM implementation for validation"""
    if img1.shape != img2.shape:
        img2 = cv2.resize(img2, (img1.shape[1], img1.shape[0]))
    
    # Calculate mean and variance
    mean1, mean2 = np.mean(img1), np.mean(img2)
    var1, var2 = np.var(img1), np.var(img2)
    covar = np.cov(img1.flatten(), img2.flatten())[0][1]
    
    C1 = (0.01 * 255) ** 2
    C2 = (0.03 * 255) ** 2
    
    numerator = (2 * mean1 * mean2 + C1) * (2 * covar + C2)
    denominator = (mean1**2 + mean2**2 + C1) * (var1 + var2 + C2)
    
    return np.clip(numerator / denominator, 0, 1)

def screenshot(x1, y1, x2, y2):
    left = min(x1, x2)
    top = min(y1, y2)
    width = abs(x2 - x1)
    height = abs(y2 - y1)

    search_region = {
        'left': left,
        'top': top,
        'width': width,
        'height': height
    }
    
    with mss() as sct:
        # Capture screen with proper region handling
        screen = sct.grab(search_region or sct.monitors[0])
        screen_img = cv2.cvtColor(np.array(screen), cv2.COLOR_BGRA2BGR)
        
        # lower_blue=(100, 50, 50)
        # upper_blue=(140, 255, 255)
        # Apply blue color filtering in HSV space
        # hsv = cv2.cvtColor(screen_img, cv2.COLOR_BGR2HSV)
        # color_mask = cv2.inRange(hsv, np.array(lower_blue), np.array(upper_blue))
        # screen_img = cv2.bitwise_and(screen_img, screen_img, mask=color_mask)

        cv2.imwrite('debug_screen.png', screen_img)

def search_image(template_path, threshold=0.7, debug=False, region=None):
    """
    Basic template matching without blue filter and reverse search.
    """
    with mss() as sct:
        # Capture screen image
        screen = sct.grab(region or sct.monitors[0])
        screen_img = cv2.cvtColor(np.array(screen), cv2.COLOR_BGRA2BGR)

        # if debug:
        #     cv2.imwrite('debug_screen.png', screen_img)

        # Load template
        template = cv2.imread(template_path, cv2.IMREAD_UNCHANGED)
        if template is None:
            raise FileNotFoundError(f"Template not found at {template_path}")

        template_bgr = template[:, :, :3]
        template_alpha = template[:, :, 3] if template.shape[2] == 4 else None

        best_match = {'confidence': 0, 'location': None, 'scale': 1.0, 'size': (0, 0)}
        scales = [x * 0.1 + 0.5 for x in range(8)]  # 0.5 to 1.2 scales

        for scale in scales:
            # Scale template
            scaled_w = int(template_bgr.shape[1] * scale)
            scaled_h = int(template_bgr.shape[0] * scale)
            if scaled_w < 5 or scaled_h < 5:
                continue

            resized_template = cv2.resize(template_bgr, (scaled_w, scaled_h))
            mask = None
            
            if template_alpha is not None:
                resized_alpha = cv2.resize(template_alpha, (scaled_w, scaled_h))
                _, mask = cv2.threshold(resized_alpha, 50, 255, cv2.THRESH_BINARY)

            if resized_template.shape[0] > screen_img.shape[0] or resized_template.shape[1] > screen_img.shape[1]:
                continue

            # Perform template matching
            result = cv2.matchTemplate(screen_img, resized_template, cv2.TM_CCOEFF_NORMED, mask=mask)
            
            # Original forward search logic
            min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
            if max_val > best_match['confidence']:
                best_match.update({
                    'confidence': max_val,
                    'location': max_loc,
                    'scale': scale,
                    'size': (scaled_w, scaled_h)
                })

        # Final threshold check
        if best_match['confidence'] >= threshold:
            x = best_match['location'][0] + (region['left'] if region else 0)
            y = best_match['location'][1] + (region['top'] if region else 0)
            return (x, y), best_match['confidence']
        
        return None, best_match['confidence']

def search_hp(template_path, threshold=0.7, debug=False, region=None, reverse=False):
    """
    Template matching with blue filter and reverse search capability.
    """
    lower_blue = (100, 50, 50)
    upper_blue = (140, 255, 255)

    with mss() as sct:
        # Capture and process screen image with blue filter
        screen = sct.grab(region or sct.monitors[0])
        screen_img = cv2.cvtColor(np.array(screen), cv2.COLOR_BGRA2BGR)
        hsv = cv2.cvtColor(screen_img, cv2.COLOR_BGR2HSV)
        color_mask = cv2.inRange(hsv, np.array(lower_blue), np.array(upper_blue))
        screen_img = cv2.bitwise_and(screen_img, screen_img, mask=color_mask)

        # if debug:
        #     cv2.imwrite('debug_screen.png', screen_img)

        # Load and process template with blue filter
        template = cv2.imread(template_path, cv2.IMREAD_UNCHANGED)
        if template is None:
            raise FileNotFoundError(f"Template not found at {template_path}")

        template_bgr = template[:, :, :3]
        hsv_template = cv2.cvtColor(template_bgr, cv2.COLOR_BGR2HSV)
        color_mask_template = cv2.inRange(hsv_template, np.array(lower_blue), np.array(upper_blue))
        template_bgr = cv2.bitwise_and(template_bgr, template_bgr, mask=color_mask_template)
        template_alpha = template[:, :, 3] if template.shape[2] == 4 else None

        best_match = {'confidence': 0, 'location': None, 'scale': 1.0, 'size': (0, 0)}
        reverse_candidates = []
        scales = [x * 0.1 + 0.5 for x in range(8)]  # 0.5 to 1.2 scales

        for scale in scales:
            # Scale template
            scaled_w = int(template_bgr.shape[1] * scale)
            scaled_h = int(template_bgr.shape[0] * scale)
            if scaled_w < 5 or scaled_h < 5:
                continue

            resized_template = cv2.resize(template_bgr, (scaled_w, scaled_h))
            mask = None
            
            if template_alpha is not None:
                resized_alpha = cv2.resize(template_alpha, (scaled_w, scaled_h))
                _, mask = cv2.threshold(resized_alpha, 50, 255, cv2.THRESH_BINARY)

            if resized_template.shape[0] > screen_img.shape[0] or resized_template.shape[1] > screen_img.shape[1]:
                continue

            # Perform template matching
            result = cv2.matchTemplate(screen_img, resized_template, cv2.TM_CCOEFF_NORMED, mask=mask)
            
            if reverse:
                # Collect all valid matches for reverse search
                ys, xs = np.where(result >= threshold)
                for x, y in zip(xs, ys):
                    confidence = result[y, x]
                    right_edge = x + scaled_w
                    reverse_candidates.append((
                        right_edge, 
                        confidence,
                        (x, y),
                        scale,
                        (scaled_w, scaled_h)
                    ))
            else:
                # Original forward search logic
                min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
                if max_val > best_match['confidence']:
                    best_match.update({
                        'confidence': max_val,
                        'location': max_loc,
                        'scale': scale,
                        'size': (scaled_w, scaled_h)
                    })

        # Handle reverse search candidates
        if reverse:
            if reverse_candidates:
                # Sort by right edge (descending), then confidence (descending)
                reverse_candidates.sort(key=lambda c: (-c[0], -c[1]))
                best_candidate = reverse_candidates[0]
                best_match.update({
                    'confidence': best_candidate[1],
                    'location': best_candidate[2],
                    'scale': best_candidate[3],
                    'size': best_candidate[4]
                })

        # Final threshold check
        if best_match['confidence'] >= threshold:
            x = best_match['location'][0] + (region['left'] if region else 0)
            y = best_match['location'][1] + (region['top'] if region else 0)
            return (x, y), best_match['confidence']
        
        return None, best_match['confidence']

def is_image_there(template_image_path, x1, y1, x2, y2, threshold=0.85, reverse_search=False) -> tuple[bool, int, int, float]:
    try:
        # Handle coordinate ordering to ensure positive dimensions
        left = min(x1, x2)
        top = min(y1, y2)
        width = abs(x2 - x1)
        height = abs(y2 - y1)

        # Validate region dimensions
        if width < 1 or height < 1:
            raise ValueError(f"Invalid search region: {width}x{height} (must be ≥1x1)")

        search_region = {
            'left': left,
            'top': top,
            'width': width,
            'height': height
        }
        if reverse_search:
            location, confidence = search_hp(  
                template_image_path,
                threshold=threshold,
                debug=False,
                region=search_region,
                reverse=reverse_search
            )
        else:
            location, confidence = search_image(  
                template_image_path,
                threshold=threshold,
                debug=True,
                region=search_region
            )

        if location:
            return (True, location[0], location[1], confidence)
        else:
            return (False, 0, 0, confidence)
    except Exception as e:
        print(f"Error: {str(e)}")
        return (False, 0, 0, 0.0)

def debug_result(result):
    print(f"Found, \nx: {result[1]}, \ny: {result[2]}, \nconfidence: {result[3]:.2%}")
    if result[0]:
        tt.tooltip(f"Found, \nx: {result[1]}, \ny: {result[2]}, \nconfidence: {result[3]:.2%}", 1000, 1)
        # move_mouse_absolute(result[1], result[2])
    else:
        tt.tooltip(f"not found confidence: {result[3]:.2%}", 1000, 1)

class search_defs(IntEnum):
    hpbar_x1 = 751
    hpbar_y1 = 991
    hpbar_x2 = 1153
    hpbar_y2 = 1041

    hand_x1 = 217
    hand_y1 = 975
    hand_x2 = 337
    hand_y2 = 1025
    # 1473, 952
    skillbar_x1 = 1325
    skillbar_y1 = 952
    skillbar_x2 = 1717
    skillbar_y2 = 1026

def get_hp_percentage() -> int:
    hpbar_x1 = search_defs.hpbar_x1
    hpbar_y1 = search_defs.hpbar_y1
    hpbar_x2 = search_defs.hpbar_x2
    hpbar_y2 = search_defs.hpbar_y2
    # screenshot(hpbar_x1, hpbar_y1, hpbar_x2, hpbar_y2)
    jump_image_path = os.path.join(script_dir, "images", "HP", "hp_pic.png")
    hp_result = is_image_there(jump_image_path, hpbar_x1, hpbar_y1, hpbar_x2, hpbar_y2, 0.9, True)
    found_x = hp_result[1]

    if hp_result[0]:
        one_to_100 = hpbar_x2 - hpbar_x1
        one_percentage_value = one_to_100 / 100
        overload = found_x - hpbar_x1
        percentage = int(overload / one_percentage_value)
        # print(f"{hp_result[0]}, Hp percentage, {percentage}, confidance: {hp_result[3]:.2%}")
    else:
        percentage = False
        # print(f"False, confidance: {hp_result[3]:.2%}")
    return percentage

def is_hand_img(char, hand) -> bool:
    hand_x1 = search_defs.hand_x1
    hand_y1 = search_defs.hand_y1
    hand_x2 = search_defs.hand_x2
    hand_y2 = search_defs.hand_y2
    # screenshot(hand_x1, hand_y1, hand_x2, hand_y2)
    punch_image_path = os.path.join(script_dir, "images", char, hand)
    result = is_image_there(punch_image_path, hand_x1, hand_y1, hand_x2, hand_y2)
    # print(f"is_hand_img: {result[0]}, {result[1]}, {result[2]}, {result[3]:.2%}")
    return result[0]

def is_skill_img(char, skill, confidance = 0.85) -> bool:
    skillbar_x1 = search_defs.skillbar_x1
    skillbar_y1 = search_defs.skillbar_y1
    skillbar_x2 = search_defs.skillbar_x2
    skillbar_y2 = search_defs.skillbar_y2
    # screenshot(skillbar_x1, skillbar_y1, skillbar_x2, skillbar_y2)
    jump_image_path = os.path.join(script_dir, "images", char, skill)
    result = is_image_there(jump_image_path, skillbar_x1, skillbar_y1, skillbar_x2, skillbar_y2, confidance)
    # print(f"is_skill_img: {result[0]}, {result[1]}, {result[2]}, {result[3]:.2%}")
    return result[0]

def is_other_img(char, img, x1, y1, x2, y2):
    jump_image_path = os.path.join(script_dir, "images", char, img)
    result = is_image_there(jump_image_path, x1, y1, x2, y2)
    return result[0]
 
def key_f12_calling(state: int) -> None:
    if not state:
        return
    pt = wintypes.POINT()
    ctypes.windll.user32.GetCursorPos(ctypes.byref(pt))
    position_str = f"{pt.x}, {pt.y}"
    pyperclip.copy(position_str)
    tt.tooltip(f"Copied: {position_str}", 1000, 1)

def key_q_calling(state: int) -> None:
    if state:
        return
    
    ishand = is_hand_img("Hulk", "punch.png")
    iskill = is_skill_img("Hulk", "indestructible_guard.png")
    isother = is_other_img("Hulk", "jump.png", 1181, 568, 1295, 672)
    # tt.tooltip(str(ishand), 1000, 1)
    # HP
    # print(f"hp {get_hp_percentage()}")
    # print(f"ishand {ishand}")
    # print(f"isskill {iskill}")
    # print(str(iskill))
   
if __name__ == "__main__":
    inter.set_device("HID\\VID_", False)
    inter.set_device("HID\\VID_", True)
    inter.sub_key(kc.KEY_Q, key_q_calling, 1)
    inter.sub_key(kc.KEY_F12, key_f12_calling, 1)
    print("Press Enter to exit")
    input()