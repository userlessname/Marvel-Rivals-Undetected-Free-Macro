import gui
from pathlib import Path
import libs.inter as inter
import gui
import pyautogui
import time

mgui = gui.MarvelRivalsGUI()

class HP:
    location_ = r"\\images\\Hp"
    hpPic = str(Path(location_) / "hpPic.png")
    move_x = 20
    
    # HP regions
    hp_regions = {
        "0_10": (779 + move_x, 1008, 813 + move_x, 1017),
        "10_20": (814 + move_x, 1008, 849 + move_x, 1017),
        # Add all other HP regions
    }

    @classmethod
    def check(cls, char_name, func_name):
        hp_value = mgui.get_slider_hp_number(char_name, func_name)
        if hp_value == 100:
            return False
        if hp_value == 0:
            return True
            
        hp_range = cls.get_slider_hp(char_name, func_name)
        if hp_range == "invalid":
            return False
            
        return cls.hp_image_search(char_name, hp_range)

    @classmethod
    def hp_image_search(cls, char_name, level):
        if level not in cls.hp_regions:
            return False
            
        region = cls.hp_regions[level]
        try:
            return pyautogui.locateOnScreen(cls.hpPic, region=region, confidence=0.7) is not None
        except:
            return False

    @classmethod
    def get_slider_hp(cls, char_name, func_name):
        hp_value = mgui.get_slider_hp_number(char_name, func_name)
        ranges = [
            (0, 10, "0_10"),
            (10, 20, "10_20"),
            # Add all other ranges
        ]
        for low, high, label in ranges:
            if low <= hp_value < high:
                return label
        return "invalid"
    
class var:
    skill_bar_x1 = 0
    skill_bar_y1 = 0
    skill_bar_x2 = 1920
    skill_bar_y2 = 1080
    ability_1 = '1'
    ability_2 = '2'
    ability_3 = '3'
    secondary_attack = 'q'
    jump = 'space'

