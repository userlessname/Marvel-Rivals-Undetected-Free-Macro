import pyautogui
import time
from pathlib import Path
import libs.inter as inter
import defaults as d
from defaults import var as v
from defaults import HP as hp
from keycodes import KeyCode as kc
from keycodes import MouseCode as mc
import img_search as im_sr
import key_layout as kl
from key_layout import key_layout_ as kl_class
from key_layout import id as kl_id
import tooltip as tt

class Character:
    def __init__(self, char_name=""):
        self.char_name = char_name
        self.jump_key = "Space"

# Defence
class hulk(Character):
    def __init__(self):
        super().__init__(char_name="Hulk")
        self.abil_2_name = "Indestructible Guard"
        self.jump_name = "Jump"
        self.abil_2_img = "indestructible_guard.png"
        self.jump_img = "jump.png"
        self.punch_img = "punch.png"
        self.hulk_keys = kl_class(kl_id.hulk)

    def activate(self): 
        self.hulk_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.indestructible_guard()
        if d.mgui.is_ability_checked(self.char_name, self.jump_name):
            self.jump()

    def indestructible_guard(self):  
        if not im_sr.is_hand_img(self.char_name, self.punch_img):
            return
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.hulk_keys.abil_2)

    def jump(self): 
        if im_sr.is_other_img(self.char_name, self.jump_img, 1181, 568, 1295, 672):
            return
        sending(self.hulk_keys.space, 1)
class captain_america(Character):
    def __init__(self):
        super().__init__(char_name="Captain America")
        self.secondary_name = "Living Legend"
        self.secondary_img = "living_legend.png"
        self.arm_img = "arm.png"
        self.captain_america_keys = kl_class(kl_id.captain_america)

    def activate(self): 
        self.captain_america_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.secondary_name):
            self.living_legend()

    def living_legend(self):  
        if not im_sr.is_hand_img(self.char_name, self.arm_img):
            return
        if not im_sr.is_skill_img(self.char_name, self.secondary_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.secondary_name):
            return
        sending(self.captain_america_keys.secondary, 1)
class venom(Character):
    def __init__(self):
        super().__init__(char_name="Venom")
        self.abil_1_name = "Symbiotic Resilience"
        self.abil_1_img = "symbiotic_resilience.png"
        self.venom_keys = kl_class(kl_id.venom)

    def activate(self): 
        self.venom_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_1_name):
            self.symbiotic_resilience()

    def symbiotic_resilience(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_1_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_1_name):
            return
        sending(self.venom_keys.abil_1)
class magneto(Character):
    def __init__(self):
        super().__init__(char_name="Magneto")
        self.abil_2_name = "Metallic Curtain"
        self.abil_3_name = "Iron Bulwark"
        self.abil_2_img = "metallic_curtain.png"
        self.abil_3_img = "iron_bulwark.png"
        self.magneto_keys = kl_class(kl_id.magneto)

    def activate(self): 
        self.magneto_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.metallic_curtain()
        if d.mgui.is_ability_checked(self.char_name, self.abil_3_name):
            self.iron_bulwark()

    def metallic_curtain(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.magneto_keys.abil_2)
        time.sleep(2)
    def iron_bulwark(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_3_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_3_name):
            return
        sending(self.magneto_keys.abil_3)
class thor(Character):
    def __init__(self):
        super().__init__(char_name="Thor")
        self.abil_1_name = "Lightning Realm"
        self.abil_1_img = "lightning_realm.png"
        self.thor_keys = kl_class(kl_id.venom)

    def activate(self): 
        self.thor_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_1_name):
            self.lightning_realm()

    def lightning_realm(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_1_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_1_name):
            return
        sending(self.thor_keys.abil_1)
# Attack
class scarlet_witch(Character):
    def __init__(self):
        super().__init__(char_name="Scarlet Witch")
        self.abil_2_name = "Mystic Projection"
        self.abil_2_img = "mystic_projection.png"
        self.scarlet_witch_keys = kl_class(kl_id.scarlet_witch)

    def activate(self): 
        self.scarlet_witch_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.mystic_projection()

    def mystic_projection(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.scarlet_witch_keys.abil_2)
        time.sleep(5)
class namor(Character):
    def __init__(self):
        super().__init__(char_name="Namor")
        self.abil_2_name = "Blessing of The Deep"
        self.abil_2_img = "blessing_of_the_deep.png"
        self.namor_keys = kl_class(kl_id.namor)

    def activate(self): 
        self.namor_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.blessing_of_the_deep()

    def blessing_of_the_deep(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.namor_keys.abil_2)
        time.sleep(5)
class psylocke(Character):
    def __init__(self):
        super().__init__(char_name="Psylocke")
        self.abil_1_name = "Psychic Stealth"
        self.abil_1_img = "psychic_stealth.png"
        self.psylocke_keys = kl_class(kl_id.psylocke)

    def activate(self): 
        self.psylocke_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_1_name):
            self.psychic_stealth()

    def psychic_stealth(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_1_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_1_name):
            return
        sending(self.psylocke_keys.abil_1)
        time.sleep(5)
class wolverine(Character):
    def __init__(self):
        super().__init__(char_name="Wolverine")
        self.abil_1_name = "Undying Animal"
        self.abil_1_img = "undying_animal.png"
        self.wolverine_keys = kl_class(kl_id.wolverine)

    def activate(self): 
        self.wolverine_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_1_name):
            self.undying_animal()

    def undying_animal(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_1_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_1_name):
            return
        sending(self.wolverine_keys.abil_1)
        # time.sleep(5)
class mister_fantastic(Character):
    def __init__(self):
        super().__init__(char_name="Mister Fantastic")
        self.abil_2_name = "Reflexive Rubber"
        self.abil_2_img = "reflexive_rubber.png"
        self.mister_fantastic_keys = kl_class(kl_id.mister_fantastic)

    def activate(self): 
        self.mister_fantastic_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.reflexive_rubber()

    def reflexive_rubber(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.mister_fantastic_keys.abil_2)
        time.sleep(5)
# Healing
class loki(Character):
    def __init__(self):
        super().__init__(char_name="Loki")
        self.secondary_name = "Deception"
        self.secondary_img = "deception.png"
        self.loki_keys = kl_class(kl_id.loki)

    def activate(self): 
        self.loki_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.secondary_name):
            self.deception()

    def deception(self):  
        if not im_sr.is_skill_img(self.char_name, self.secondary_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.secondary_name):
            return
        sending(self.loki_keys.secondary)
        time.sleep(5)
class mantis(Character):
    def __init__(self):
        super().__init__(char_name="Mantis")
        self.abil_3_name = "Natural Anger"
        self.abil_3_img = "natural_anger.png"
        self.mantis_keys = kl_class(kl_id.mantis)

    def activate(self): 
        self.mantis_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_3_name):
            self.natural_anger()

    def natural_anger(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_3_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_3_name):
            return
        sending(self.mantis_keys.abil_3)
        time.sleep(8)
class rocket_raccoon(Character):
    def __init__(self):
        super().__init__(char_name="Rocket Raccoon")
        self.secondary_name = "Repair Mode" # repair_mode
        self.gun_img = "gun.png"
        self.rocket_raccoon_keys = kl_class(kl_id.rocket_raccoon)

    def activate(self): 
        self.rocket_raccoon_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.secondary_name):
            self.repair_mode()

    def repair_mode(self):  
        if not im_sr.is_hand_img(self.char_name, self.gun_img):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.secondary_name):
            return
        sending(self.rocket_raccoon_keys.secondary)
        time.sleep(2)
class luna_snow(Character):
    def __init__(self):
        super().__init__(char_name="Luna Snow")
        self.abil_2_name = "Ice Arts"
        self.abil_2_img = "ice_arts.png"
        self.luna_snow_keys = kl_class(kl_id.luna_snow)

    def activate(self): 
        self.luna_snow_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.ice_arts()

    def ice_arts(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.luna_snow_keys.abil_2)
        # time.sleep(5)
class adam_warlock(Character):
    def __init__(self):
        super().__init__(char_name="Adam Warlock")
        self.abil_1_name = "Avatar Life Stream"
        self.abil_1_img = "avatar_life_stream.png"
        self.abil_2_name = "Soul Bound"
        self.abil_2_img = "soul_bound.png"
        self.adam_warlock_keys = kl_class(kl_id.adam_warlock)

    def activate(self): 
        self.adam_warlock_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_1_name):
            self.avatar_life_stream()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.soul_bound()

    def avatar_life_stream(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_1_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_1_name):
            return
        sending(self.adam_warlock_keys.abil_1)
        time.sleep(1)

    def soul_bound(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.adam_warlock_keys.abil_2)
        # time.sleep(5)
class jeff_the_land_shark(Character):
    def __init__(self):
        super().__init__(char_name="Jeff The Land Shark")
        self.abil_2_name = "Hide and Seek"
        self.abil_2_img = "hide_and_seek.png"
        self.jeff_the_land_shark_keys = kl_class(kl_id.jeff_the_land_shark)

    def activate(self): 
        self.jeff_the_land_shark_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.abil_2_name):
            self.hide_and_seek()

    def hide_and_seek(self):  
        if not im_sr.is_skill_img(self.char_name, self.abil_2_img, 0.89):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.abil_2_name):
            return
        sending(self.jeff_the_land_shark_keys.abil_2)
        time.sleep(3)
class invisible_woman(Character):
    def __init__(self):
        super().__init__(char_name="Invisible Woman")
        self.abil_2_name = "Indestructible Guard"
        self.other_skill_name = "Double Jump"
        self.jump1_img = "jump1.png"
        self.arrow_img = "arrow.png"
        self.invisible_woman_keys = kl_class(kl_id.invisible_woman)

    def activate(self): 
        self.invisible_woman_keys.get_key_layout()
        if d.mgui.is_ability_checked(self.char_name, self.other_skill_name):
            self.jump()

    def jump(self):  
        if not im_sr.is_hand_img(self.char_name, self.arrow_img, 0.8):
            return
        if not im_sr.is_skill_img(self.char_name, self.jump1_img, 0.6):
            return
        if not im_sr.get_hp_percentage() < d.mgui.get_slider_number(self.char_name, self.other_skill_name):
            return
        sending(self.invisible_woman_keys.space)
        sending(self.invisible_woman_keys.space)
        sending(self.invisible_woman_keys.space)

# Defence
m_hulk = hulk()
m_ca = captain_america()
m_venom = venom()
m_magneto = magneto()
m_thor = thor()
# Attack
m_scarlet_witch = scarlet_witch()
m_namor = namor()
m_psylocke = psylocke()
m_wolverine = wolverine()
m_mister_fantastic = mister_fantastic()
# Healing
m_loki = loki()
m_mantis = mantis()
m_rocket_raccoon = rocket_raccoon()
m_luna_snow = luna_snow()
m_adam_warlock = adam_warlock()
m_jeff_the_land_shark = jeff_the_land_shark()
m_invisible_woman = invisible_woman()


def sending(key_name, ishold=None):
    if not (ishold == None or ishold == True or ishold == False or ishold == 1 or ishold == 0):
        return
    if key_name == "RightMouseButton" or key_name == "MiddleMouseButton":
        if ishold == None:
            inter.send_button(kl.get_key_button_code(key_name))
        else:
            inter.send_button_state(kl.get_key_button_code(key_name), ishold)
    else:
        if ishold == None:
            inter.send_key(kl.get_key_button_code(key_name))
        else:
            inter.send_key_state(kl.get_key_button_code(key_name), ishold)

    print("")
    