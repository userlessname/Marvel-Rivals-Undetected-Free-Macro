import ctypes
import time
import threading

# Constants and structures
WS_EX_TOPMOST = 0x00000008
WS_POPUP = 0x80000000
TTS_ALWAYSTIP = 0x01
TTF_TRACK = 0x0020
TTF_ABSOLUTE = 0x0080
TTM_ADDTOOLW = 0x0432
TTM_TRACKACTIVATE = 0x0411
TTM_TRACKPOSITION = 0x0412
TTM_SETMAXTIPWIDTH = 0x0418
SM_CXSCREEN = 0
SM_CYSCREEN = 1

class POINT(ctypes.Structure):
    _fields_ = [("x", ctypes.c_long), ("y", ctypes.c_long)]

class RECT(ctypes.Structure):
    _fields_ = [
        ("left", ctypes.c_long), ("top", ctypes.c_long),
        ("right", ctypes.c_long), ("bottom", ctypes.c_long)
    ]

class TOOLINFOW(ctypes.Structure):
    _fields_ = [
        ("cbSize", ctypes.c_uint), ("uFlags", ctypes.c_uint),
        ("hwnd", ctypes.c_void_p), ("uId", ctypes.c_void_p),
        ("rect", RECT), ("hinst", ctypes.c_void_p),
        ("lpszText", ctypes.c_wchar_p), ("lParam", ctypes.c_void_p),
        ("lpReserved", ctypes.c_void_p)
    ]

# Initialize Windows API
user32 = ctypes.WinDLL('user32')
kernel32 = ctypes.WinDLL('kernel32')
shcore = ctypes.WinDLL('shcore')

# Set DPI awareness
try:
    shcore.SetProcessDpiAwareness(1)  # PROCESS_SYSTEM_DPI_AWARE
except:
    user32.SetProcessDPIAware()

def get_scaling_factor():
    try:
        dpi = shcore.GetDpiForSystem()
        return dpi / 96.0
    except:
        return 1.0  # Fallback to 100% scaling

_tooltip_hwnd = None  # Global variable to store the tooltip window handle
_tooltip_thread = None # Global variable to store tooltip thread
_tooltip_stop_event = threading.Event() # Global variable to stop tooltip thread

def tooltip(
    text: str = None,
    display_time_ms: int = None,
    is_center: bool = None,
    x: int = None,
    y: int = None,
    width: int = 100,
    height: int = 100
):
    """
    Displays a tooltip window.

    Args:
        text (str, optional): The text to display in the tooltip. Defaults to None.
        display_time_ms (int, optional): The time in milliseconds to display the tooltip. 
                                        -1 for indefinite display. Defaults to None.
        is_center (bool, optional): Whether to center the tooltip on the screen. Defaults to None.
        x (int, optional): The x-coordinate of the tooltip. Defaults to None (cursor position).
        y (int, optional): The y-coordinate of the tooltip. Defaults to None (cursor position).
        width (int, optional): The width of the tooltip. Defaults to 100.
        height (int, optional): The height of the tooltip. Defaults to 100.

    If called with no arguments, closes any existing persistent tooltip.
    """
    global _tooltip_hwnd, _tooltip_thread, _tooltip_stop_event

    if _tooltip_hwnd:
        # Destroy the previous tooltip
        _tooltip_stop_event.set()  # Signal the thread to stop
        if _tooltip_thread and _tooltip_thread.is_alive():
            # Post a WM_NULL message to wake up the message loop
            user32.PostMessageW(_tooltip_hwnd, 0x0000, 0, 0)
            _tooltip_thread.join()  # Wait for the thread to finish
        user32.DestroyWindow(_tooltip_hwnd)
        _tooltip_hwnd = None
        _tooltip_stop_event.clear() # Reset the event

    if text is None and display_time_ms is None and is_center is None:  # Called with no arguments
        return # Just return after destroying any existing tooltip.

    if display_time_ms == -1: # if -1, create a new tooltip in a new thread
        _tooltip_thread = threading.Thread(target=_create_persistent_tooltip, args=(text, is_center, x, y, width, height))
        _tooltip_thread.start()

    elif display_time_ms is not None: # create normal tooltip (no thread, no persistent)
        _create_tooltip(text, display_time_ms, is_center, x, y, width, height)


def _create_tooltip(text: str, 
    display_time_ms: int, 
    is_center: bool, 
    x: int = None, 
    y: int = None,
    width: int = 100,
    height: int = 100
):
    """Creates a standard (non-persistent) tooltip."""
    scaling_factor = get_scaling_factor()
    scaled_width = int(width * scaling_factor)
    scaled_height = int(height * scaling_factor)

    if is_center:
        # Get physical screen dimensions
        screen_width = user32.GetSystemMetrics(SM_CXSCREEN)
        screen_height = user32.GetSystemMetrics(SM_CYSCREEN)
        x = (screen_width - scaled_width) // 2
        y = (screen_height - scaled_height) // 2
    else:
        # Get cursor position if coordinates not provided
        if x is None or y is None:
            pt = POINT()
            user32.GetCursorPos(ctypes.byref(pt))
            x = pt.x if x is None else x
            y = pt.y if y is None else y

    # Create tooltip window
    h_instance = kernel32.GetModuleHandleW(None)
    hwnd = user32.CreateWindowExW(
        WS_EX_TOPMOST, "tooltips_class32", None, 
        WS_POPUP | TTS_ALWAYSTIP, 
        x, y, scaled_width, scaled_height,
        None, None, h_instance, None
    )
    if not hwnd:
        raise RuntimeError("Failed to create tooltip window")

    # Configure tool information
    user32.SendMessageW(hwnd, TTM_SETMAXTIPWIDTH, 0, scaled_width)
    
    ti = TOOLINFOW()
    ti.cbSize = ctypes.sizeof(TOOLINFOW)
    ti.uFlags = TTF_TRACK | TTF_ABSOLUTE
    ti.hwnd = user32.GetDesktopWindow()
    ti.lpszText = text

    # Add tool and activate
    user32.SendMessageW(hwnd, TTM_ADDTOOLW, 0, ctypes.byref(ti))
    user32.SendMessageW(hwnd, TTM_TRACKACTIVATE, True, ctypes.byref(ti))

    # Set position
    pos = (y << 16) | (x & 0xFFFF)
    user32.SendMessageW(hwnd, TTM_TRACKPOSITION, 0, pos)

    # Maintain window
    time.sleep(display_time_ms / 1000)
    user32.DestroyWindow(hwnd)

def _create_persistent_tooltip(text, is_center, x, y, width, height):
    """Creates a persistent tooltip that remains until explicitly closed."""
    global _tooltip_hwnd, _tooltip_stop_event

    scaling_factor = get_scaling_factor()
    scaled_width = int(width * scaling_factor)
    scaled_height = int(height * scaling_factor)

    if is_center:
        # Get physical screen dimensions
        screen_width = user32.GetSystemMetrics(SM_CXSCREEN)
        screen_height = user32.GetSystemMetrics(SM_CYSCREEN)
        x = (screen_width - scaled_width) // 2
        y = (screen_height - scaled_height) // 2
    else:
        # Get cursor position if coordinates not provided
        if x is None or y is None:
            pt = POINT()
            user32.GetCursorPos(ctypes.byref(pt))
            x = pt.x if x is None else int(x * scaling_factor) # Scale user provided coords
            y = pt.y if y is None else int(y * scaling_factor)


    # Create tooltip window
    h_instance = kernel32.GetModuleHandleW(None)
    _tooltip_hwnd = user32.CreateWindowExW(
        WS_EX_TOPMOST, "tooltips_class32", None,
        WS_POPUP | TTS_ALWAYSTIP,
        x, y, scaled_width, scaled_height,
        None, None, h_instance, None
    )
    if not _tooltip_hwnd:
        raise RuntimeError("Failed to create tooltip window")

    # Configure tool information
    user32.SendMessageW(_tooltip_hwnd, TTM_SETMAXTIPWIDTH, 0, scaled_width)

    ti = TOOLINFOW()
    ti.cbSize = ctypes.sizeof(TOOLINFOW)
    ti.uFlags = TTF_TRACK | TTF_ABSOLUTE
    ti.hwnd = user32.GetDesktopWindow()
    ti.lpszText = text

    # Add tool and activate
    user32.SendMessageW(_tooltip_hwnd, TTM_ADDTOOLW, 0, ctypes.byref(ti))
    user32.SendMessageW(_tooltip_hwnd, TTM_TRACKACTIVATE, True, ctypes.byref(ti))

    # Set position
    pos = (y << 16) | (x & 0xFFFF)
    user32.SendMessageW(_tooltip_hwnd, TTM_TRACKPOSITION, 0, pos)

    # Message loop to keep the window alive
    msg = ctypes.wintypes.MSG()
    while not _tooltip_stop_event.is_set():
        # Check for messages with a timeout to periodically check the stop event
        if user32.PeekMessageW(ctypes.byref(msg), _tooltip_hwnd, 0, 0, 0x0001):  # PM_REMOVE
            user32.TranslateMessage(ctypes.byref(msg))
            user32.DispatchMessageW(ctypes.byref(msg))
        else:
            # Sleep briefly to reduce CPU usage
            time.sleep(0.01)

    # Explicit cleanup when stopping.
    if _tooltip_hwnd:
        user32.DestroyWindow(_tooltip_hwnd)
        _tooltip_hwnd = None


# Usage examples
if __name__ == "__main__":
    # Indefinite tooltip
    tooltip("Indefinite Tooltip", -1, True)
    time.sleep(3)

    # Close the tooltip by calling tooltip() with no arguments
    tooltip()