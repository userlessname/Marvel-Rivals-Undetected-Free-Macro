# main.py
import libs.inter as inter
import time
import gui as g
import characters as c
import defaults as d
from defaults import var as v
from defaults import HP as hp
import tkinter as tk
from tkinter import ttk
import threading 
from keycodes import KeyCode as kc
from keycodes import MouseCode as mc
import img_search as im_sr
import libs.inter as inter
import ctypes
from ctypes import wintypes
import pyperclip
import tooltip as tt
import time
import key_layout as kl

def activates():
    # Defence
    c.m_hulk.activate() 
    c.m_ca.activate() 
    c.m_venom.activate() 
    c.m_magneto.activate() 
    c.m_thor.activate() 
    # Attack
    c.m_scarlet_witch.activate() 
    c.m_namor.activate() 
    c.m_psylocke.activate() 
    c.m_wolverine.activate() 
    c.m_mister_fantastic.activate() 
    # Healing
    c.m_loki.activate() 
    c.m_mantis.activate() 
    c.m_rocket_raccoon.activate() 
    c.m_luna_snow.activate() 
    c.m_adam_warlock.activate() 
    c.m_jeff_the_land_shark.activate() 
    c.m_invisible_woman.activate() 

### **Main**  
def my_infinite_loop_function():
    """This function will run in an infinite loop in a separate thread."""
    while True:                                                                                    
        activates()
        # *********                         
                                                                                  
        time.sleep(0.2)  

def key_f12_calling(state: int) -> None:
    if not state:
        return
    pt = wintypes.POINT()
    ctypes.windll.user32.GetCursorPos(ctypes.byref(pt))
    position_str = f"{pt.x}, {pt.y}"
    pyperclip.copy(position_str)
    tt.tooltip(f"Copied: {position_str}", 1000, 1)
if __name__ == "__main__":
    # #################################################################
    # print("Press a key and move mouse to get devices\n")
    # tt.tooltip(f"Copied: {position_str}", 1000, 1)
    kl.is_game_installed()

    tt.tooltip("Please move your mose get mouse handle(if not detected please install driver)", -1, 1)
    inter.set_mouse_wait()

    tt.tooltip("Please send key get keyboard handle", -1, 1)
    inter.set_keyboard_wait()

    tt.tooltip()

    inter.sub_key(kc.KEY_F12, key_f12_calling, 1)
    # #################################################################
    infinite_loop_thread = threading.Thread(target=my_infinite_loop_function)
    infinite_loop_thread.daemon = True  # Important: Make it a daemon thread
    infinite_loop_thread.start()       # Start the thread

    d.mgui.root.mainloop()  
