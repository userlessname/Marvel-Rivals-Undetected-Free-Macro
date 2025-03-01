# inter.py
import os
import ctypes
from typing import Callable

# Determine the path to the DLL.
_dll_path = os.path.join(os.path.dirname(__file__), "inter.dll")
# _dll_path = os.path.join(os.path.dirname(__file__), "inter_with_move.dll")  #  Use if you have a different DLL
_dll = ctypes.CDLL(_dll_path)

# Define callback function types.
CALLBACK_FUNC_INT = ctypes.CFUNCTYPE(None, ctypes.c_int)
CALLBACK_FUNC_INT_INT = ctypes.CFUNCTYPE(None, ctypes.c_int, ctypes.c_int)
CALLBACK_FUNC_VOID = ctypes.CFUNCTYPE(None)

# Dictionary to hold callback references so they are not garbage collected.
_callback_refs = {}

# ---------------------------
# Setup DLL function prototypes
# ---------------------------

# Helper function for setting up function prototypes
def _setup_function(func, argtypes, restype):
    func.argtypes = argtypes
    func.restype = restype

# set_keyboard
_setup_function(_dll.set_keyboard, [ctypes.c_char_p], None)

def set_keyboard(device_id: str):
    _dll.set_keyboard(device_id.encode('utf-8'))

# set_mouse
_setup_function(_dll.set_mouse, [ctypes.c_char_p], None)

def set_mouse(device_id: str):
    _dll.set_mouse(device_id.encode('utf-8'))

# set_keyboard_wait
_setup_function(_dll.set_keyboard_wait, [], None)

def set_keyboard_wait():
    _dll.set_keyboard_wait()

# set_mouse_wait
_setup_function(_dll.set_mouse_wait, [], None)

def set_mouse_wait():
    _dll.set_mouse_wait()

# mouse_move
_setup_function(_dll.mouse_move, [ctypes.c_int, ctypes.c_int], None)

def mouse_move(x_amount: int, y_amount: int):
    _dll.mouse_move(x_amount, y_amount)

# mouse_move_coord
_setup_function(_dll.mouse_move_coord, [ctypes.c_int, ctypes.c_int], None)

def mouse_move_coord(x_location: int, y_location: int):
    _dll.mouse_move_coord(x_location, y_location)

# send_key
_setup_function(_dll.send_key, [ctypes.c_ushort], None)

def send_key(key_code: int):
    _dll.send_key(ctypes.c_ushort(key_code))

# send_key_state
_setup_function(_dll.send_key_state, [ctypes.c_ushort, ctypes.c_bool], None)

def send_key_state(key_code: int, state: bool):
    _dll.send_key_state(ctypes.c_ushort(key_code), state)

# send_button
_setup_function(_dll.send_button, [ctypes.c_ushort], None)

def send_button(button_code: int):
    _dll.send_button(ctypes.c_ushort(button_code))

# send_button_state
_setup_function(_dll.send_button_state, [ctypes.c_ushort, ctypes.c_bool], None)

def send_button_state(button_code: int, state: bool):
    _dll.send_button_state(ctypes.c_ushort(button_code), state)

# get_key_state
_setup_function(_dll.get_key_state, [ctypes.c_ushort], ctypes.c_bool)

def get_key_state(key_code: int) -> bool:
    return _dll.get_key_state(ctypes.c_ushort(key_code))

# get_button_state
_setup_function(_dll.get_button_state, [ctypes.c_ushort], ctypes.c_bool)

def get_button_state(button_code: int) -> bool:
    return _dll.get_button_state(ctypes.c_ushort(button_code))

# sub_key
_setup_function(_dll.sub_key, [ctypes.c_ushort, CALLBACK_FUNC_INT, ctypes.c_bool], None)

def sub_key(code: int, cb: Callable[[int], None], block: bool):
    c_callback = CALLBACK_FUNC_INT(cb)
    _callback_refs[f"key_{code}"] = c_callback  # Prevent garbage collection
    _dll.sub_key(ctypes.c_ushort(code), c_callback, block)

# un_sub_key
_setup_function(_dll.un_sub_key, [ctypes.c_ushort], None)

def un_sub_key(code: int):
    _dll.un_sub_key(ctypes.c_ushort(code))
    _callback_refs.pop(f"key_{code}", None)  # Remove reference

# sub_button
_setup_function(_dll.sub_button, [ctypes.c_ushort, CALLBACK_FUNC_INT, ctypes.c_bool], None)

def sub_button(btn: int, cb: Callable[[int], None], block: bool):
    c_callback = CALLBACK_FUNC_INT(cb)
    _callback_refs[f"button_{btn}"] = c_callback
    _dll.sub_button(ctypes.c_ushort(btn), c_callback, block)

# un_sub_button
_setup_function(_dll.un_sub_button, [ctypes.c_ushort], None)

def un_sub_button(btn: int):
    _dll.un_sub_button(ctypes.c_ushort(btn))
    _callback_refs.pop(f"button_{btn}", None)

# sub_mouse_move
_setup_function(_dll.sub_mouse_move, [CALLBACK_FUNC_INT_INT, ctypes.c_bool], None)
def sub_mouse_move(cb: Callable[[int, int], None], block: bool):
    c_callback = CALLBACK_FUNC_INT_INT(cb)
    _callback_refs["mouse_move"] = c_callback
    _dll.sub_mouse_move(c_callback, block)

# un_sub_mouse_move
_setup_function(_dll.un_sub_mouse_move, [], None)

def un_sub_mouse_move():
    _dll.un_sub_mouse_move()
    _callback_refs.pop("mouse_move", None)

# sub_mouse_move_amount
_setup_function(_dll.sub_mouse_move_amount, [CALLBACK_FUNC_VOID, ctypes.c_int, ctypes.c_int, ctypes.c_bool], None)

def sub_mouse_move_amount(cb: Callable[[], None], x: int, y: int, block: bool):
    c_callback = CALLBACK_FUNC_VOID(cb)
    _callback_refs[f"mouse_move_amount_{x}_{y}"] = c_callback
    _dll.sub_mouse_move_amount(c_callback, x, y, block)

# un_sub_mouse_move_amount
_setup_function(_dll.un_sub_mouse_move_amount, [], None)

def un_sub_mouse_move_amount():
    _dll.un_sub_mouse_move_amount()
    keys_to_remove = [key for key in _callback_refs if key.startswith("mouse_move_amount_")]
    for key in keys_to_remove:
        _callback_refs.pop(key, None)

# sub_mouse_move_coord
_setup_function(_dll.sub_mouse_move_coord, [CALLBACK_FUNC_VOID, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_bool], None)

def sub_mouse_move_coord(cb: Callable[[], None], x1: int, y1: int, x2: int, y2: int, block: bool):
    c_callback = CALLBACK_FUNC_VOID(cb)
    _callback_refs[f"mouse_move_coord_{x1}_{y1}_{x2}_{y2}"] = c_callback
    _dll.sub_mouse_move_coord(c_callback, x1, y1, x2, y2, block)

# un_sub_mouse_move_coord
_setup_function(_dll.un_sub_mouse_move_coord, [], None)

def un_sub_mouse_move_coord():
    _dll.un_sub_mouse_move_coord()
    keys_to_remove = [key for key in _callback_refs if key.startswith("mouse_move_coord_")]
    for key in keys_to_remove:
        _callback_refs.pop(key, None)