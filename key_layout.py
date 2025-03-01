import os
import json
from pathlib import Path
import tkinter.messagebox as msgbox
from keycodes import KeyCode as kc
import libs.inter as inter
from enum import IntEnum
import re
from keycodes import KeyCode 
from keycodes import MouseCode 
import sys

def get_key_button_code(key: str) -> int:
    if key == "One":
        return getattr(KeyCode, "KEY_1")
    elif key == "Two":
        return getattr(KeyCode, "KEY_2")
    elif key == "Three":
        return getattr(KeyCode, "KEY_3")
    elif key == "Four":
        return getattr(KeyCode, "KEY_4")
    elif key == "Five":
        return getattr(KeyCode, "KEY_5")
    elif key == "Six":
        return getattr(KeyCode, "KEY_6")
    elif key == "Seven":
        return getattr(KeyCode, "KEY_7")
    elif key == "Eight":
        return getattr(KeyCode, "KEY_8")
    elif key == "Nine":
        return getattr(KeyCode, "KEY_9")
    elif key == "Zero":
        return getattr(KeyCode, "KEY_0")
    elif key == "Tilde":
        return getattr(KeyCode, "KEY_GRAVE")
    elif key == "Space":
        enum_name = f"KEY_{key.upper()}"
        return getattr(KeyCode, enum_name)
    elif key.endswith("MouseButton"):
        position = key[:-len("MouseButton")]
        enum_name = f"MOUSE_{position.upper()}"
        return getattr(MouseCode, enum_name)
    else:
        parts = re.findall('[A-Z][a-z]*', key)
        substitutions = {"Control": "Ctrl"}
        processed_parts = [substitutions.get(part, part).upper() for part in parts]
        enum_name = "KEY_" + "".join(processed_parts)
        return getattr(KeyCode, enum_name)

def get_username():
    local_app_data = os.environ.get("LOCALAPPDATA")
    if not local_app_data:
        return None
    
    config_path = Path(local_app_data) / "Marvel" / "Saved" / "Saved" / "Config"
    latest_time = 0
    latest_dir = None
    
    if config_path.exists():
        for entry in config_path.iterdir():
            if entry.is_dir():
                ini_path = entry / "MarvelUserSetting.ini"
                if ini_path.exists():
                    file_time = ini_path.stat().st_mtime
                    if file_time > latest_time:
                        latest_time = file_time
                        latest_dir = entry.name
    return latest_dir if latest_dir else None

class default_key_name:
    secondary = "RightMouseButton"
    abil_1 = "E"
    abil_2 = "LeftShift"
    abil_3 = "F"
    ulti = "Q"
    space = "Space"

class id:
    secondary = r'\\\"11\\\"'
    abil_1 = r'\\\"15\\\"'
    abil_2 = r'\\\"16\\\"'
    abil_3 = r'\\\"20\\\"'  # Corrected from 20 to 48 based on the example
    ulti = r'\\\"19\\\"'
    all = r'\"0\"'
    hulk = r'\"1011\"'
    captain_america = r'\"1022\"'
    venom = r'\"1035\"'
    magneto = r'\"1037\"'
    thor = r'\"1039\"'
    scarlet_witch = r'\"1038\"'
    namor = r'\"1045\"'
    psylocke = r'\"1048\"'
    wolverine = r'\"1049\"'
    mister_fantastic = r'\"1040\"'
    loki = r'\"1016\"'
    mantis = r'\"1020\"'
    rocket_raccoon = r'\"1023\"'
    luna_snow = r'\"1031\"'
    adam_warlock = r'\"1046\"'
    jeff_the_land_shark = r'\"1047\"'
    invisible_woman = r'\"1050\"'

def is_game_installed():
    username = get_username()
    if not username:
        msgbox.showerror("Info", "Could not find user configuration directory")
        sys.exit()
        return
class key_layout_:
    def __init__(self, character_ID):
        self.secondary = default_key_name.secondary
        self.abil_1 = default_key_name.abil_1
        self.abil_2 = default_key_name.abil_2
        self.abil_3 = default_key_name.abil_3
        self.ulti = default_key_name.ulti
        self.space = default_key_name.space
        self.character_ID = character_ID

    def get_key_layout(self):
        username = get_username()
        if not username:
            msgbox.showerror("Info", "Could not find user configuration directory")
            sys.exit()
            return

        ini_path = (
            Path(os.environ["LOCALAPPDATA"]) 
            / "Marvel" / "Saved" / "Saved" / "Config" 
            / username / "MarvelUserSetting.ini"
        )

        try:
            with open(ini_path, 'r', encoding='utf-8') as f:
                ini_data = json.load(f)
        except Exception as e:
            msgbox.showerror("Info", f"Failed to read INI file: {e}")
            return

        user_control_str = ini_data.get("UserControl", "{}")
        try:
            user_control = json.loads(user_control_str)
        except json.JSONDecodeError as e:
            msgbox.showerror("Info", f"Failed to parse UserControl: {e}")
            return

        # Process character ID by stripping quotes and backslashes
        char_id = self.character_ID.replace('\\', '').strip('"')

        # ########################
        # variable_type = type(user_control)  # Get the type of the variable
        # print(variable_type)  # Print the type
        # ########################

        char_settings = user_control.get(char_id, {})
        global_settings = user_control.get("0", {})

        is_global_changed = False
        if "CharControlInputMappings" in global_settings:
            is_global_changed = True

        is_here_specific_changed = False
        if "SculptInputs" in char_settings:
            is_here_specific_changed = True


        # Process ability IDs
        def process_id(raw_id):
            return raw_id.replace('\\', '').replace('"', '')
        
        secondary_id = process_id(id.secondary)
        abil_1_id = process_id(id.abil_1)
        abil_2_id = process_id(id.abil_2)
        abil_3_id = process_id(id.abil_3)
        ulti_id = process_id(id.ulti)

        # Function to find key in SculptInputs
        def get_sculpt_key(ability_id):
            # ###############################
            char_settings_dic = json.loads(char_settings)
            # ###############################
            sculpt_inputs = char_settings_dic.get("SculptInputs", {})
            for sculpt in sculpt_inputs.values():
                if ability_id in sculpt:
                    return sculpt[ability_id].get("PrimaryKey", {}).get("Key", None)
            return None

        secondary_key = abil_1_key = abil_2_key = abil_3_key = ulti_key = None
        # Check SculptInputs for each ability
        if is_here_specific_changed:
            secondary_key = get_sculpt_key(secondary_id)
            abil_1_key = get_sculpt_key(abil_1_id)
            abil_2_key = get_sculpt_key(abil_2_id)
            abil_3_key = get_sculpt_key(abil_3_id)
            ulti_key = get_sculpt_key(ulti_id)

        # Function to find key in CharControlInputMappings
        def get_char_control_key(settings, ability_id):
            # ###############################
            settings_dic = json.loads(settings)
            char_control = settings_dic.get("CharControlInputMappings", {})
            char_control_key = char_control.get(ability_id, {}).get("PrimaryKey", {}).get("Key", None)
            # variable_type = type(char_control)  # Get the type of the variable
            # print(variable_type)  # Print the type
            # ###############################
            return char_control_key

        if is_global_changed:
            # If not found, check character's CharControlInputMappings
            if not secondary_key:
                secondary_key = get_char_control_key(char_settings, secondary_id)
            if not abil_1_key:
                abil_1_key = get_char_control_key(char_settings, abil_1_id)
            if not abil_2_key:
                abil_2_key = get_char_control_key(char_settings, abil_2_id)
            if not abil_3_key:
                abil_3_key = get_char_control_key(char_settings, abil_3_id)
            if not ulti_key:
                ulti_key = get_char_control_key(char_settings, ulti_id)

            # If still not found, check global CharControlInputMappings
            if not secondary_key:
                secondary_key = get_char_control_key(global_settings, secondary_id)
            if not abil_1_key:
                abil_1_key = get_char_control_key(global_settings, abil_1_id)
            if not abil_2_key:
                abil_2_key = get_char_control_key(global_settings, abil_2_id)
            if not abil_3_key:
                abil_3_key = get_char_control_key(global_settings, abil_3_id)
            if not ulti_key:
                ulti_key = get_char_control_key(global_settings, ulti_id)

        # Update instance variables with found keys or defaults
        # ###############################
        # asd = secondary_key if secondary_key else default_key_name.secondary
        # variable_type = type(secondary_key)  # Get the type of the variable
        # print(variable_type)  # Print the type
        # ###############################
        self.secondary = secondary_key if secondary_key else default_key_name.secondary
        self.abil_1 = abil_1_key if abil_1_key else default_key_name.abil_1
        self.abil_2 = abil_2_key if abil_2_key else default_key_name.abil_2
        self.abil_3 = abil_3_key if abil_3_key else default_key_name.abil_3
        self.ulti = ulti_key if ulti_key else default_key_name.ulti

def key_q_calling(state: int) -> None:
    if state:
        return
    hulk_keys = key_layout_(id.hulk)
    hulk_keys.get_key_layout()
    print("Secondary Attack:", hulk_keys.secondary)
    print("Ability 1:", hulk_keys.abil_1) 
    print("Ability 2:", hulk_keys.abil_2)
    print("Ability 3:", hulk_keys.abil_3)
    print("Ultimate:", hulk_keys.ulti)
if __name__ == "__main__":
    inter.set_device("HID\\VID_", False)
    inter.set_device("HID\\VID_", True)
    inter.sub_key(kc.KEY_Q, key_q_calling, 0)



    input("Press Enter to exit")