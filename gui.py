import tkinter as tk
from tkinter import ttk
import sys
import libs.inter as inter

def get_scale_factor(root):
    """Calculates the scaling factor based on the current display."""
    current_scaling = root.tk.call('tk', 'scaling')
    default_scaling = 96 / 72  # Default DPI scaling (96 DPI / 72 points per inch)
    return current_scaling / default_scaling

def calculate_initial_geometry(root, gui_width, y_margin_top, button_width, button_height,
                                 checkbox_spacing, slider_spacing, scale_factor, y_margin_bottom):
    """Calculates the initial geometry of the window, centering it on the screen."""
    # Dummy layout to determine maximum height, placed off-screen
    dummy_y = -1000
    x_defence = 10 * scale_factor
    x_attack = x_defence + 300 * scale_factor + 20 * scale_factor
    x_healer = x_attack + 300 * scale_factor + 20 * scale_factor
    for group_name in ["Defence", "Attack", "Healer"]:
        dummy_x = x_defence if group_name == "Defence" else x_attack if group_name == "Attack" else x_healer
        dummy_y = y_margin_top #reset for new collumn
        for char, funcs, _ in [
            ("Hulk", [
                {"name": "Indestructible Guard", "margin": {}, "defaultSliderValue": 70},
                {"name": "Jump", "margin": {}, "defaultSliderValue": -1}
            ], 20*scale_factor),
            ("Captain America", [{"name": "Living Legend", "margin": {}, "defaultSliderValue": 100}], 20*scale_factor),
            ("Venom", [{"name": "Symbiotic Resilience", "margin": {}, "defaultSliderValue": 70}], 20*scale_factor)
        ]:

            dummy_button = tk.Button(root, text=char)
            dummy_button.place(x=dummy_x, y=dummy_y, width=button_width, height=button_height)
            dummy_y += button_height + 15 * scale_factor

            for func in funcs:
                dummy_cb = tk.Checkbutton(root, text=func["name"])
                dummy_cb.place(x=dummy_x + 20 * scale_factor, y=dummy_y)
                dummy_y += checkbox_spacing

                if func["defaultSliderValue"] != -1:
                    dummy_slider = ttk.Scale(root)
                    dummy_slider.place(x=dummy_x, y=dummy_y + 20*scale_factor, width=button_width)
                    dummy_y += slider_spacing + 20 * scale_factor
            dummy_y += 5 * scale_factor


    # Calculate screen dimensions
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()

    # Calculate window dimensions
    window_width = int(gui_width)
    window_height = int(dummy_y + y_margin_bottom)  # Use calculated height

    # Calculate centered position
    x = (screen_width - window_width) // 2
    y = (screen_height - window_height) // 2

    # Set the geometry *before* making the window visible
    geometry_string = f"{window_width}x{window_height}+{x}+{y}"

    #cleanup dummy objects
    for widget in root.winfo_children():
        widget.destroy()

    return geometry_string


def create_group_titles_ext(gui):
    groups = [
        ("Defence", gui.x_defence),
        ("Attack", gui.x_attack),
        ("Healer", gui.x_healer)
    ]
    for text, x in groups:
        x_pos = x + (gui.section_w / 2 - 30 * gui.scale_factor)
        y_pos = gui.y_margin_top - 30 * gui.scale_factor
        label = tk.Label(gui.root, text=text, bg=gui.bg_color, fg='white', font=gui.font)
        label.place(x=x_pos, y=y_pos)

def add_all_character_sections_ext(gui):
    spacing = 20 * gui.scale_factor

    defence_chars = [
        ("Hulk", [
            {"name": "Indestructible Guard", "margin": {"left": 0, "right": 0, "top": 0, "bottom": 0}, "defaultSliderValue": 70},
            {"name": "Jump", "margin": {"left": 0, "right": 0, "top": 0, "bottom": 10}, "defaultSliderValue": -1}
        ]),
        ("Captain America", [{"name": "Living Legend", "margin": {}, "defaultSliderValue": 100}]),
        ("Venom", [{"name": "Symbiotic Resilience", "margin": {}, "defaultSliderValue": 70}]),
        ("Magneto", [
            {"name": "Iron Bulwark", "margin": {}, "defaultSliderValue": 70},
            {"name": "Metallic Curtain", "margin": {}, "defaultSliderValue": 30}
        ]),
        ("Thor", [{"name": "Lightning Realm", "margin": {}, "defaultSliderValue": 70}])
    ]
    for char, funcs in defence_chars:
        add_character_section_ext(gui, "Defence", char, funcs, spacing)

    attack_chars = [
        ("Scarlet Witch", [{"name": "Mystic Projection", "margin": {}, "defaultSliderValue": 70}]),
        ("Namor", [{"name": "Blessing of The Deep", "margin": {}, "defaultSliderValue": 50}]),
        ("Psylocke", [{"name": "Psychic Stealth", "margin": {}, "defaultSliderValue": 70}]),
        ("Wolverine", [{"name": "Undying Animal", "margin": {}, "defaultSliderValue": 80}]),
        ("Mister Fantastic", [{"name": "Reflexive Rubber", "margin": {}, "defaultSliderValue": 60}])
    ]
    for char, funcs in attack_chars:
        add_character_section_ext(gui, "Attack", char, funcs, spacing)

    healer_chars = [
        ("Loki", [{"name": "Deception", "margin": {}, "defaultSliderValue": 40}]),
        ("Mantis", [{"name": "Natural Anger", "margin": {}, "defaultSliderValue": 100}]),
        ("Rocket Raccoon", [{"name": "Repair Mode", "margin": {}, "defaultSliderValue": 95}]),
        ("Luna Snow", [{"name": "Ice Arts", "margin": {}, "defaultSliderValue": 60}]),
        ("Adam Warlock", [
            {"name": "Avatar Life Stream", "margin": {"left": 0, "right": 0, "top": 0, "bottom": 0}, "defaultSliderValue": 60},
            {"name": "Soul Bound", "margin": {"left": 0, "right": 0, "top": 0, "bottom": 0}, "defaultSliderValue": 40}
        ]),
        ("Jeff The Land Shark", [{"name": "Hide and Seek", "margin": {}, "defaultSliderValue": 60}]),
        ("Invisible Woman", [{"name": "Double Jump", "margin": {}, "defaultSliderValue": 70}])
    ]
    for char, funcs in healer_chars:
        add_character_section_ext(gui, "Healer", char, funcs, spacing)

def add_character_section_ext(gui, group_name, char_name, functions, spacing):
    gui.section_states[char_name] = False
    btn = tk.Button(gui.root, text=char_name, 
                   command=lambda gn=group_name, cn=char_name: toggle_section_ext(gui, gn, cn),
                   font=gui.font)
    controls = []

    for func in functions:
        name = func["name"]
        margin = func["margin"]
        scaled_margin = {k: v * gui.scale_factor for k, v in margin.items()}
        gui.checkbox_margins[name] = scaled_margin
        slider_val = func["defaultSliderValue"]

        cb_var = tk.BooleanVar()
        cb = tk.Checkbutton(gui.root, text=name, variable=cb_var, bg=gui.bg_color, fg='white',
                           font=gui.font, highlightthickness=0, highlightbackground=gui.bg_color,
                           borderwidth=0, relief=tk.FLAT, takefocus=0,
                           activebackground=gui.bg_color, selectcolor=gui.bg_color,
                           command=lambda cn=char_name, fn=name, v=cb_var: handle_checkbox_ext(gui, cn, fn, v))
        cb.var = cb_var
        cb.char_name = char_name
        cb.func_name = name
        controls.append(cb)

        if slider_val != -1:
            slider_var = tk.IntVar(value=slider_val)
            slider_label = tk.Label(gui.root, text=str(slider_val), bg=gui.bg_color, fg='white', font=gui.font)
            slider = ttk.Scale(gui.root, from_=0, to=100, orient=tk.HORIZONTAL, takefocus=0,
                              length=gui.button_width, style="MySliderStyle.Horizontal",
                              variable=slider_var,
                              command=lambda v, cn=char_name, fn=name, lbl=slider_label: handle_slider_ext(gui, cn, fn, v, lbl))
            slider.var = slider_var
            slider.label = slider_label
            slider_label.slider = slider
            controls.append((slider_label, slider))
            gui.function_states.setdefault(char_name, {})[f"{name}_slider"] = slider_val
            update_slider_label_position_ext(gui, slider)
            gui.root.after_idle(lambda: update_slider_label_position_ext(gui, slider))

    gui.group_sections[group_name].append((char_name, btn, controls, spacing))

def toggle_section_ext(gui, group_name, char_name):
    gui.section_states[char_name] = not gui.section_states[char_name]
    if gui.section_states[char_name]:
        for group in gui.group_sections.values():
            for section in group:
                if section[0] != char_name:
                    gui.section_states[section[0]] = False
    layout_all_groups_ext(gui)

def layout_all_groups_ext(gui):
    max_height = gui.y_margin_bottom
    for group_name in ["Defence", "Attack", "Healer"]:
        y = gui.y_margin_top
        x = gui.x_defence if group_name == "Defence" else gui.x_attack if group_name == "Attack" else gui.x_healer

        for section in gui.group_sections[group_name]:
            char_name, btn, controls, spacing = section
            btn.place(x=x, y=y, width=gui.button_width, height=gui.button_height)
            y += gui.button_height + 15 * gui.scale_factor

            if gui.section_states.get(char_name, False):
                for control in controls:
                    if isinstance(control, tk.Checkbutton):
                        margin = gui.checkbox_margins.get(control.func_name, {})
                        control_x = x + 20 * gui.scale_factor + margin.get("left", 0)
                        control_y = y + margin.get("top", 0)
                        control.place(x=control_x, y=control_y)
                        y += gui.checkbox_spacing + margin.get("top", 0) + margin.get("bottom", 0)
                    elif isinstance(control, tuple):
                        slider_label, slider = control
                        slider.place(x=x, y=y + 20 * gui.scale_factor, width=gui.button_width)
                        slider.slider_x = x
                        slider.slider_y = y + 20 * gui.scale_factor
                        slider.slider_length = gui.button_width
                        update_slider_label_position_ext(gui, slider)
                        y += gui.slider_spacing + 20 * gui.scale_factor
                y += 5 * gui.scale_factor
            else:
                for control in controls:
                    if isinstance(control, tuple):
                        slider_label, slider = control
                        slider_label.place_forget()
                        slider.place_forget()
                    else:
                        control.place_forget()
            max_height = max(max_height, y)
    gui.root.geometry(f"{int(gui.gui_width)}x{int(max_height)}")

def update_slider_label_position_ext(gui, slider):
    slider.label.update_idletasks()
    try:
        current_val = int(float(slider.var.get()))
    except ValueError:
        current_val = 0
    fraction = current_val / 100.0

    def place_label():
        y_offset = -5 * gui.scale_factor
        slider.label.place(in_=slider, relx=fraction, y=y_offset, anchor='s')
        slider.label.lift()
    slider.label.after(10, place_label)

def handle_checkbox_ext(gui, char_name, func_name, var):
    gui.function_states.setdefault(char_name, {})[func_name] = var.get()
    if var.get():
        for group in gui.group_sections.values():
            for section in group:
                if section[0] != char_name:
                    for control in section[2]:
                        if isinstance(control, tk.Checkbutton):
                            control.var.set(False)

def handle_slider_ext(gui, char_name, func_name, value, label):
    int_value = int(float(value))
    gui.function_states.setdefault(char_name, {})[f"{func_name}_slider"] = int_value
    label.config(text=str(int_value))
    if hasattr(label, 'slider'):
        update_slider_label_position_ext(gui, label.slider)

def on_close_ext(gui):
    gui.root.destroy()
    sys.exit()


class MarvelRivalsGUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Marvel Rivals Characters")
        self.root.configure(bg='#619c4a')
        self.bg_color = '#619c4a'

        self.scale_factor = get_scale_factor(self.root)  # Use external function

        self.style = ttk.Style(self.root)
        self.style.theme_use('clam')
        self.style.layout("MySliderStyle.Horizontal",
                          [('Horizontal.Scale.trough', {
                              'children': [('Horizontal.Scale.slider', {'side': 'left', 'sticky': ''})],
                              'sticky': 'nswe'})])
        self.style.configure("MySliderStyle.Horizontal",
                             background=self.bg_color,
                             troughcolor='#4a6c3a',
                             foreground='white',
                             sliderthickness=20 * self.scale_factor,
                             sliderrelief='flat')

        self.base_font_size = 10
        self.font = ("Helvetica", int(self.base_font_size * self.scale_factor))

        self.x_margin_left = 10 * self.scale_factor
        self.x_margin_right = 8 * self.scale_factor
        self.y_margin_top = 50 * self.scale_factor
        self.y_margin_bottom = 42 * self.scale_factor
        self.section_w = 300 * self.scale_factor
        self.group_spacing = 20 * self.scale_factor
        self.button_height = 30 * self.scale_factor
        self.checkbox_spacing = 30 * self.scale_factor
        self.slider_spacing = 30 * self.scale_factor
        self.button_width = (300 - 20) * self.scale_factor

        self.section_states = {}
        self.function_states = {}
        self.group_sections = {"Defence": [], "Attack": [], "Healer": []}
        self.checkbox_margins = {}

        self.gui_width = (3 * self.section_w) + (2 * self.group_spacing) + self.x_margin_left + self.x_margin_right
        self.x_defence = self.x_margin_left
        self.x_attack = self.x_defence + self.section_w + self.group_spacing
        self.x_healer = self.x_attack + self.section_w + self.group_spacing

        # Calculate geometry *before* creating the widgets
        geometry = calculate_initial_geometry(  # Use external function
            self.root, self.gui_width, self.y_margin_top, self.button_width, self.button_height,
            self.checkbox_spacing, self.slider_spacing, self.scale_factor, self.y_margin_bottom
        )
        self.root.geometry(geometry)


        create_group_titles_ext(self)          # Use external functions
        add_all_character_sections_ext(self)
        layout_all_groups_ext(self)

        self.root.protocol("WM_DELETE_WINDOW", lambda: on_close_ext(self))  # Use external function
        # self.root.mainloop() # remove mainloop, class must not run, but be used

    # Remove @classmethod decorator
    def is_ability_checked(self, character_name, ability_name) -> bool:
        """Check if the specified ability for the character is checked."""
        return self.function_states.get(character_name, {}).get(ability_name, False)

    # Remove @classmethod decorator
    def get_slider_number(self, character_name, ability_name) -> int:
        """Get the slider value for the specified ability of the character."""
        return self.function_states.get(character_name, {}).get(f"{ability_name}_slider", -1)

# # Example usage (if you want to run the GUI):
# if __name__ == "__main__":
#     gui = MarvelRivalsGUI()
#     gui.root.mainloop()