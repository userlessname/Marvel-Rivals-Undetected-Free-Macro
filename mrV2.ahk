#Requires AutoHotkey v2.0+
#SingleInstance Force

; Include necessary libraries
#Include Lib\AutoHotInterception.ahk
#Include mouse_keyboard_variables.ahk
#Include gui.ahk

; ================================================================================
; ================================================================================
; ================================================================================
AHI := AutoHotInterception()

; keyboard := keyboard_(AHI, "HID\VID_1C4F&PID_0002&REV_0330&MI_00")

; mouse := mouse_(AHI, "HID\VID_09DA&PID_57EB&REV_0028&MI_01")

; keyboard := keyboard_(AHI, "HID\VID_046D&PID_C34B&REV_6200&MI_00")

mouse := mouse_(AHI)

keyboard := keyboard_(AHI)

mouse_handle := mouse.handle
keyboard_handle := keyboard.handle

mouse_id := AHI.GetMouseIdFromHandle(mouse_handle)
keyboard_id := AHI.GetKeyboardIdFromHandle(keyboard_handle)

mouse.id := mouse_id
keyboard.id := keyboard_id

var := variables_()

Sleep 200

; #include gui.ahk

myGui := gui_()   ; Sınıf örneği oluştur

; script otomatik olarak devam eder...

Persistent

; Set Coordination Modes
CoordMode "Tooltip", "Screen"
CoordMode "Mouse", "Screen"
; Optimize script performance
SetWinDelay -1

; Subscribe to mouse and keyboard events
AHI.SubscribeMouseButton(mouse.id, var.mouse_left_code, false, LeftClick)

AHI.SubscribeKey(keyboard.id, GetKeySC("LCtrl"), false, LCtrl)
AHI.SubscribeKey(keyboard.id, GetKeySC("LAlt"), false, LAlt)
AHI.SubscribeKey(keyboard.id, GetKeySC("F9"), false, F9)

AHI.SubscribeKey(keyboard.id, GetKeySC("1"), false, One)
AHI.SubscribeKey(keyboard.id, GetKeySC("F1"), false, F1)
AHI.SubscribeKey(keyboard.id, GetKeySC("F2"), false, F2)

; --- Mouse Event Handlers ---
LeftClick(state){
    ; tooltip_center("LeftClick")
    var.mouse_left_state := state
    if (state && var.LAlt_state && var.LCtrl_state){
        MouseGetPos(&xpos, &ypos)
        A_Clipboard := "X: " . xpos . ", Y: " . ypos
        tooltip_center(A_Clipboard, 1000)
    }
}
; --- Keyboard Event Handlers ---
One(state){
    ; tooltip_center("One")
    if (state && !var.One_state)
    {
        var.One_state := true
        if var.LCtrl_state
            active_deactive()
    }
    else if (!state && var.One_state)
    {
        var.One_state := false
    }
}
F1(state){
    if state
        return
    if var.LAlt_state
        send_key("F11")
}
F2(state){
    if state
        return
    if var.LAlt_state
        send_key("F12")
}
LCtrl(state){
    if (state && !var.LCtrl_state)
    {
        var.LCtrl_state := true
    }
    else if (!state && var.LCtrl_state)
    {
        var.LCtrl_state := false
    }
}
LAlt(state){
    if (state && !var.LAlt_state)
    {
        var.LAlt_state := true
    }
    else if (!state && var.LAlt_state)
    {
        var.LAlt_state := false
    }
}
; --- Active/Deactive ---
active_deactive(){
    var.active_deactive_toggle := !var.active_deactive_toggle
    ; ToolTip ("active_deactive_toggle  " . var.active_deactive_toggle)
    if var.active_deactive_toggle
    {
        tooltip_center(" +++ (1/3) ", 333)
        tooltip_center(" ++++++ (2/3) ", 333)
        tooltip_center(" +++++++++ (3/3) ", 333)
    }
    else
    {
        tooltip_center(" --- (1/3) ", 333)
        tooltip_center(" ------ (2/3) ", 333)
        tooltip_center(" --------- (3/3) ", 333)
    }
}
; --- Capture ---
F9(state) {
    if state
        return
    ; tooltip_center("daa")
    ; CaptureScreenRegion(998, 1010, 1010, 1013, "\screenshot.png")
    hulk.capture()
    magneto.capture()
    hp.capture()
    wolverine.capture()
    scarlet_witch.capture()
    mantis.capture()
    venom.capture()
    thor.capture()
    namor.capture()
    psylocke.capture()
    loki.capture()
    rocket_raccoon.capture()
    luna_snow.capture()
    adam_warlock.capture()
    jeff_the_land_shark.capture()
    captain_america.capture()
    mister_fantastic.capture()
    invisible_woman.capture()
}
; --- Main Loop ---
while true {
    Sleep 256

    ; Dışarıdan gelen “aktif/pasif toggle” değişkeni
    ; eğer yoksa, bir global veya static harici değişkenden
    ; alıp kendinize göre düzenleyebilirsiniz:
    if !var.active_deactive_toggle
        continue

    ; Hulk
    if (myGui.IsAbilityActive("Hulk", "Indestructible Guard")) {
        ; tooltip_center("Indestructible Guard")
        hulk.ability2()
    }
    if (myGui.IsAbilityActive("Hulk", "Jump")) {
        ; tooltip_center("Jump")
        hulk.jump()
    }
    

    ; Magneto
    if (myGui.IsAbilityActive("Magneto", "Iron Bulwark")) {
        ; tooltip_center("Iron Bulwark")
        magneto.shield()
    }
    if (myGui.IsAbilityActive("Magneto", "Metallic Curtain")) {
        ; tooltip_center("Metallic Curtain")
        magneto.shield2()
    }
    ; Wolverine
    if (myGui.IsAbilityActive("Wolverine", "Undying Animal")) {
        wolverine.ability1()
    }

    ; Scarlet Witch
    if (myGui.IsAbilityActive("Scarlet Witch", "Mystic Projection")) {
        scarlet_witch.ability2()
    }

    ; Mantis
    if (myGui.IsAbilityActive("Mantis", "Natural Anger")) {
        mantis.ability3()
    }

    ; Venom
    if (myGui.IsAbilityActive("Venom", "Symbiotic Resilience")) {
        venom.symbiotic_resilience()
    }

    ; Thor
    if (myGui.IsAbilityActive("Thor", "Lightning Realm")) {
        thor.lightning_realm()
    }

    ; Namor
    if (myGui.IsAbilityActive("Namor", "Blessing of The Deep")) {
        namor.blessing_of_the_deep()
    }

    ; Psylocke
    if (myGui.IsAbilityActive("Psylocke", "Psychic Stealth")) {
        psylocke.psychic_stealth()
    }

    ; Loki
    if (myGui.IsAbilityActive("Loki", "Deception")) {
        loki.deception()
    }

    ; Rocket Raccoon
    if (myGui.IsAbilityActive("Rocket Raccoon", "Repair Mode")) {
        rocket_raccoon.repair_mode()
    }

    ; Luna Snow
    if (myGui.IsAbilityActive("Luna Snow", "Ice Arts")) {
        luna_snow.ice_arts()
    }

    ; Adam Warlock
    if (myGui.IsAbilityActive("Adam Warlock", "Avatar Life Stream")) {
        adam_warlock.avatar_life_stream()
    }

    ; Jeff The Land Shark
    if (myGui.IsAbilityActive("Jeff The Land Shark", "Hide and Seek")) {
        jeff_the_land_shark.hide_and_seek()
    }

    ; Captain America
    if (myGui.IsAbilityActive("Captain America", "Living Legend")) {
        captain_america.living_legend()
    }

    ; Mister Fantastic
    if (myGui.IsAbilityActive("Mister Fantastic", "Reflexive Rubber")) {
        mister_fantastic.reflexive_rubber()
    }

    ; Invisible Woman
    if (myGui.IsAbilityActive("Invisible Woman", "Double Jump")) {
        invisible_woman.double_jump()
    }
}

; --- Class Definitions ---
class hp{
    static location_ := "\images\Hp\"
    static hpPic_    := hp.location_ . "hpPic.png"

    static hp0_10_x1    := 779,  hp0_10_y1      := 1008, hp0_10_x2      := 813,  hp0_10_y2      := 1017
    static hp10_20_x1   := 814,  hp10_20_y1     := 1008, hp10_20_x2     := 849,  hp10_20_y2     := 1017
    static hp20_30_x1   := 850,  hp20_30_y1     := 1008, hp20_30_x2     := 885,  hp20_30_y2     := 1017
    static hp30_40_x1   := 886,  hp30_40_y1     := 1008, hp30_40_x2     := 921,  hp30_40_y2     := 1017
    static hp40_50_x1   := 922,  hp40_50_y1     := 1008, hp40_50_x2     := 957,  hp40_50_y2     := 1017
    static hp50_60_x1   := 958,  hp50_60_y1     := 1008, hp50_60_x2     := 992,  hp50_60_y2     := 1017
    static hp60_70_x1   := 993,  hp60_70_y1     := 1008, hp60_70_x2     := 1028, hp60_70_y2     := 1017
    static hp70_80_x1   := 1029, hp70_80_y1     := 1008, hp70_80_x2     := 1064, hp70_80_y2     := 1017
    static hp80_90_x1   := 1065, hp80_90_y1     := 1008, hp80_90_x2     := 1100, hp80_90_y2     := 1017
    static hp90_100_x1  := 1101, hp90_100_y1    := 1008, hp90_100_x2    := 1137, hp90_100_y2    := 1017

    static capture() {
        ; CaptureScreenRegion(956, 1012, 958, 1013, this.hpPic_)
        ; Hp Area
        ; X: 779, Y: 1008
        ; X: 1137, Y: 1017
    }

    static Check(charName, AddOrMinus := 0) {
        if (AddOrMinus == "")
            AddOrMinus := 0
        ; tooltip_center("Checking HP for " . charName)
        hpValue := this.getSliderHp(charName, AddOrMinus)
        ; tooltip_center(charName . AddOrMinus)
        hpValueNumber := myGui.getSliderHpNumber(charName)
        ; tooltip_center(charName . ": " . hpValue)
        if (hpValue == "invalid")
        {
            tooltip_center("invalid")
            return false
        }
        ; tooltip_center("HP Value for " . charName . ": " . hpValue)
        ; ================================ Hp debug ================================
        ; tooltip_center(charName . ": " . hpValue)
        if (hpValueNumber == 0)
            return false
        if (hpValueNumber == 100)
            return true

        ; tooltip_center(this.hpImageSearch(charName, hpValue))
        if not (this.hpImageSearch(charName, hpValue))
            return true
        else
            return false
    }

    static hpImageSearch(charName, level){
        n_variant := 50
        Switch level {
            Case "0_10":
                var := isImage_there(hp.hp0_10_x1, hp.hp0_10_y1, hp.hp0_10_x2, hp.hp0_10_y2, hp.hpPic_, n_variant)
                return var.result
            Case "10_20":
                var := isImage_there(hp.hp10_20_x1, hp.hp10_20_y1, hp.hp10_20_x2, hp.hp10_20_y2, hp.hpPic_, n_variant)
                return var.result
            Case "20_30":
                var := isImage_there(hp.hp20_30_x1, hp.hp20_30_y1, hp.hp20_30_x2, hp.hp20_30_y2, hp.hpPic_, n_variant)
                return var.result
            Case "30_40":
                var := isImage_there(hp.hp30_40_x1, hp.hp30_40_y1, hp.hp30_40_x2, hp.hp30_40_y2, hp.hpPic_, n_variant)
                return var.result
            Case "40_50":
                var := isImage_there(hp.hp40_50_x1, hp.hp40_50_y1, hp.hp40_50_x2, hp.hp40_50_y2, hp.hpPic_, n_variant)
                return var.result
            Case "50_60":
                var := isImage_there(hp.hp50_60_x1, hp.hp50_60_y1, hp.hp50_60_x2, hp.hp50_60_y2, hp.hpPic_, n_variant)
                return var.result
            Case "60_70":
                var := isImage_there(hp.hp60_70_x1, hp.hp60_70_y1, hp.hp60_70_x2, hp.hp60_70_y2, hp.hpPic_, n_variant)
                return var.result
            Case "70_80":
                var := isImage_there(hp.hp70_80_x1, hp.hp70_80_y1, hp.hp70_80_x2, hp.hp70_80_y2, hp.hpPic_, n_variant)
                return var.result
            Case "80_90":
                var := isImage_there(hp.hp80_90_x1, hp.hp80_90_y1, hp.hp80_90_x2, hp.hp80_90_y2, hp.hpPic_, n_variant)
                return var.result
            Case "90_100":
                var := isImage_there(hp.hp90_100_x1, hp.hp90_100_y1, hp.hp90_100_x2, hp.hp90_100_y2, hp.hpPic_, n_variant)
                return var.result
            Default:
                ; tooltip_center("Geçersiz HP seviyesi: " . level, 1000)
                return false
        }
    }



    static getSliderHp(charName, AddOrMinus := 0){
        if (AddOrMinus == "")
            AddOrMinus := 0
        hpValue := myGui.getSliderHpNumber(charName) + AddOrMinus
        ; hpValue := myGui.getSliderHpNumber(charName)
        ; hpValue += hpValue AddOrMinus
        ; tooltip_center("HP Value for " . charName . ": " . hpValue)
        ; Aralığı belirle
        if (hpValue >= 0 && hpValue < 10) {
            return "0_10"
        }
        else if (hpValue >= 10 && hpValue < 20) {
            return "10_20"
        }
        else if (hpValue >= 20 && hpValue < 30) {
            return "20_30"
        }
        else if (hpValue >= 30 && hpValue < 40) {
            return "30_40"
        }
        else if (hpValue >= 40 && hpValue < 50) {
            return "40_50"
        }
        else if (hpValue >= 50 && hpValue < 60) {
            return "50_60"
        }
        else if (hpValue >= 60 && hpValue < 70) {
            return "60_70"
        }
        else if (hpValue >= 70 && hpValue < 80) {
            return "70_80"
        }
        else if (hpValue >= 80 && hpValue < 90) {
            return "80_90"
        }
        else if (hpValue >= 90 && hpValue <= 100) {
            return "90_100"
        }
        else {
            ; tooltip_center("HP değeri 0-100 aralığında olmalı: " . hpValue, 1000)
            return "invalid"
        }
    }

    static test(){
        ; global thp, thp2, thp3, thp4, thp5, thp6, thp7, thp8, thp9, thp10
        ; n_variation := 100
        ; thp  := hp.Check("Hulk")
        ; thp2 := hp.Check("Magneto")
        ; thp3 := hp.Check("Wolverine")
        ; thp4 := hp.Check("Scarlet Witch")
        ; thp5 := hp.Check("Mantis")
        ; text := Format('hps:n Hulk:{1}n Magneto:{2}n Wolverine:{3}n Scarlet Witch:{4}n Mantis:{5}n', thp, thp2, thp3, thp4, thp5)
        ; tooltip_center(text, 1000)
    }
}
class hulk { ; Pic
    ; Define static properties
    static jump_x1 := 1230, jump_y1 := 605, jump_x2 := 1235, jump_y2 := 606
    static shield_x1 := 1672, shield_y1 := 983, shield_x2 := 1680, shield_y2 := 991
    static mjump_x1 := 1243, mjump_y1 := 573, mjump_x2 := 1245, mjump_y2 := 579
    static punch_x1 := 239, punch_y1 := 1000, punch_x2 := 250, punch_y2 := 1008

    static location_ := "\images\Hulk\"
    static jump_   := hulk.location_ . "jump.png"
    static shield_ := hulk.location_ . "shield.png"
    static mjump_  := hulk.location_ . "mjump.png"
    static punch_  := hulk.location_ . "punch.png"

    ; Capture function (currently commented out)
    static capture() {
        ; CaptureScreenRegion(this.jump_x1, this.jump_y1, this.jump_x2, this.jump_y2, this.jump_)
        ; CaptureScreenRegion(this.shield_x1, this.shield_y1, this.shield_x2, this.shield_y2, this.shield_)
        ; CaptureScreenRegion(this.mjump_x1, this.mjump_y1, this.mjump_x2, this.mjump_y2, this.mjump_)
        ; CaptureScreenRegion(this.punch_x1, this.punch_y1, this.punch_x2, this.punch_y2, this.punch_)
        ; ToolTip "capture"
    }

    static ability2() {
        ; tooltip_center("ability2")
        if hp.Check("Hulk") {
            n_variants := 25
            shield := isImage_there(this.shield_x1, this.shield_y1, this.shield_x2, this.shield_y2, this.shield_, n_variants)
            punch  := isImage_there(this.punch_x1, this.punch_y1, this.punch_x2, this.punch_y2, this.punch_, n_variants)
            if (punch.result && shield.result) {
                send_key("E")
            }
        }
    }

    ; Jump function
    static jump() {
        ; tooltip_center("jump")
        n_variants := 25
        jump := isImage_there(this.jump_x1, this.jump_y1, this.jump_x2, this.jump_y2, this.jump_, n_variants)
        if not jump.result {
            punch  := isImage_there(this.punch_x1, this.punch_y1, this.punch_x2, this.punch_y2, this.punch_, n_variants)
            if (punch.result) {
                AHI.SendKeyEvent(keyboard.id, GetKeySC("Space"), 1)
            }
        }
    }

    ; Prevent modification of constants
    __Set(name, value) {
        throw "Cannot modify a constant: " . name
    }
}
class magneto {
    static shield_x1 := 1674, shield_y1 := 976, shield_x2 := 1679, shield_y2 := 982
    static shield2_x1 := 1592, shield2_y1 := 976, shield2_x2 := 1598, shield2_y2 := 982
    static location_ := "\images\Magneto\"
    static shield_  := magneto.location_ . "shield.png"
    static shield2_ := magneto.location_ . "shield2.png"

    static capture() {
        ; CaptureScreenRegion(magneto.shield_x1, magneto.shield_y1, magneto.shield_x2, magneto.shield_y2, magneto.shield_)
        ; CaptureScreenRegion(magneto.shield2_x1, magneto.shield2_y1, magneto.shield2_x2, magneto.shield2_y2, magneto.shield2_)
    }

    static shield() {
        ; tooltip_center("shield")
        if hp.Check("Magneto") {
            shield := isImage_there(this.shield_x1, this.shield_y1, this.shield_x2, this.shield_y2, this.shield_, 25)
            if shield.result {
                ; middle button
                ; send_key(var.mouse_middle_code, true)
                send_key("F")
            }
        }
    }

    static shield2(){
        ; tooltip_center("shield2")
        ; Retrieve the AddOrMinus value from functionStates
        addOrMinus := myGui.GetAddOrMinusValue("Magneto", "Metallic Curtain")
        if (addOrMinus = "invalid")
            return

        if hp.Check("Magneto", addOrMinus) {
            shield2 := isImage_there(this.shield2_x1, this.shield2_y1, this.shield2_x2, this.shield2_y2, this.shield2_, 25)
            if shield2.result {
                send_key("E")
            }
        }
    }

    ; -------------------------------------------------------------------
    ; FUNCTION: GetAddOrMinusValue
    ; PURPOSE:  Retrieve the AddOrMinus value from functionStates
    ; -------------------------------------------------------------------

    ; Prevent modification of constants
    __Set(name, value) {
        throw "Cannot modify a constant: " . name
    }
}
class wolverine{
    static ability1_x1 := 1507, ability1_y1 := 969, ability1_x2 := 1510, ability1_y2 := 970
    static location_ := "\images\Wolverine\"
    static ability1_  := this.location_ . "ability1.png"

    static capture() {
        ; CaptureScreenRegion(this.ability1_x1, this.ability1_y1, this.ability1_x2, this.ability1_y2, this.ability1_)
    }

    static ability1() {
        if hp.Check("Wolverine") {
            ; tooltip_center("daa")
            ability1 := isImage_there(this.ability1_x1, this.ability1_y1, this.ability1_x2, this.ability1_y2, this.ability1_, 25)
            if ability1.result {
                ; send_key("E")
                send_key(var.mouse_middle_code, true)
            }
        }
    }

    ; Prevent modification of constants
    __Set(name, value) {
        throw "Cannot modify a constant: " . name
    }
}
class scarlet_witch{
    static ability2_x1 := 1664, ability2_y1 := 986, ability2_x2 := 1666, ability2_y2 := 989
    static location_ := "\images\Scarlet_Witch\"
    static ability2_  := scarlet_witch.location_ . "ability2.png"

    static capture() {
        ; CaptureScreenRegion(this.ability2_x1, this.ability2_y1, this.ability2_x2, this.ability2_y2, this.ability2_)
    }

    static ability2() {
        if hp.Check("Scarlet Witch") {
            ability2 := isImage_there(this.ability2_x1, this.ability2_y1, this.ability2_x2, this.ability2_y2, this.ability2_, 25)
            if ability2.result {
                send_key("E")
                ; send_key(var.mouse_middle_code, true)
            }
        }
    }

    ; Prevent modification of constants
    __Set(name, value) {
        throw "Cannot modify a constant: " . name
    }
}
class mantis{
    static ability3_x1 := 1673, ability3_y1 := 984, ability3_x2 := 1678, ability3_y2 := 989
    static lifeOrb1_x1 := 921, lifeOrb1_y1 := 697, lifeOrb1_x2 := 922, lifeOrb1_y2 := 718
    static location_    := "\images\Mantis\"
    static ability3_    := mantis.location_ . "ability3.png"
    static lifeOrb1_    := mantis.location_ . "lifeOrb1.png"

    static capture() {
        ; CaptureScreenRegion(this.ability3_x1, this.ability3_y1, this.ability3_x2, this.ability3_y2, this.ability3_)
        ; CaptureScreenRegion(this.lifeOrb1_x1, this.lifeOrb1_y1, this.lifeOrb1_x2, this.lifeOrb1_y2, this.lifeOrb1_)
    }

    static ability3()
    {
        ; tooltip_center("amntis ability3")
        if hp.Check("Mantis")
        {
            ; tooltip_center("hp")
            ability3 := isImage_there(this.ability3_x1, this.ability3_y1, this.ability3_x2, this.ability3_y2, this.ability3_, 25)
            if ability3.result
            {
                ; tooltip_center("ability3")
                lifeOrb1 := isImage_there(this.lifeOrb1_x1, this.lifeOrb1_y1, this.lifeOrb1_x2, this.lifeOrb1_y2, this.lifeOrb1_, 2)
                if lifeOrb1.result
                {
                    ; tooltip_center("lifeOrb1")
                    send_key("F")
                    Sleep 7800
                }
            }
        }
    }

    ; Prevent modification of constants
    __Set(name, value) {
        throw "Cannot modify a constant: " . name
    }
}
class venom{
    static symbiotic_resilience_x1 := 1444, symbiotic_resilience_y1 := 982, symbiotic_resilience_x2 := 1450, symbiotic_resilience_y2 := 986
    static location_    := "\images\Venom\"
    static symbiotic_resilience_    := this.location_ . "symbiotic_resilience.png"

    static capture() {
        ; CaptureScreenRegion(this.symbiotic_resilience_x1, this.symbiotic_resilience_y1, this.symbiotic_resilience_x2, this.symbiotic_resilience_y2, this.symbiotic_resilience_)
    }

    static symbiotic_resilience()
    {
        ; tooltip_center("vocum symbiotic_resilience")
        if hp.Check("Venom")
        {
            ; tooltip_center("hp")
            symbiotic_resilience := isImage_there(this.symbiotic_resilience_x1, this.symbiotic_resilience_y1, this.symbiotic_resilience_x2, this.symbiotic_resilience_y2, this.symbiotic_resilience_, 25)
            if symbiotic_resilience.result
            {
                send_key(var.mouse_middle_code, true)
            }
        }
    }
}
class thor{
    static lightning_realm_x1 := 1445, lightning_realm_y1 := 979, lightning_realm_x2 := 1451, lightning_realm_y2 := 981
    static location_    := "\images\Thor\"
    static lightning_realm_    := this.location_ . "lightning_realm.png"

    static capture() {
        ; CaptureScreenRegion(this.lightning_realm_x1, this.lightning_realm_y1, this.lightning_realm_x2, this.lightning_realm_y2, this.lightning_realm_)
    }

    static lightning_realm()
    {
        ; tooltip_center("vocum lightning_realm")
        if hp.Check("Thor")
        {
            ; tooltip_center("hp")
            lightning_realm := isImage_there(this.lightning_realm_x1, this.lightning_realm_y1, this.lightning_realm_x2, this.lightning_realm_y2, this.lightning_realm_, 25)
            if lightning_realm.result
            {
                ; send_key("E")
                send_key(var.mouse_middle_code, true)
            }
        }
    }
}
class namor{
    static blessing_of_the_deep_x1 := 1673, blessing_of_the_deep_y1 := 980, blessing_of_the_deep_x2 := 1680, blessing_of_the_deep_y2 := 988
    static location_    := "\images\Namor\"
    static blessing_of_the_deep_    := this.location_ . "blessing_of_the_deep.png"

    static capture() {
        ; CaptureScreenRegion(this.blessing_of_the_deep_x1, this.blessing_of_the_deep_y1, this.blessing_of_the_deep_x2, this.blessing_of_the_deep_y2, this.blessing_of_the_deep_)
    }

    static blessing_of_the_deep()
    {
        ; tooltip_center("vocum blessing_of_the_deep")
        if hp.Check("Namor")
        {
            ; tooltip_center("hp")
            blessing_of_the_deep := isImage_there(this.blessing_of_the_deep_x1, this.blessing_of_the_deep_y1, this.blessing_of_the_deep_x2, this.blessing_of_the_deep_y2, this.blessing_of_the_deep_, 25)
            if blessing_of_the_deep.result
            {
                send_key("E")
                ; send_key(var.mouse_middle_code, true)
            }
        }
    }
}
class psylocke{
    static psychic_stealth_x1 := 1506, psychic_stealth_y1 := 976, psychic_stealth_x2 := 1513, psychic_stealth_y2 := 979
    static location_    := "\images\Psylocke\"
    static psychic_stealth_    := this.location_ . "psychic_stealth.png"

    static capture() {
        ; CaptureScreenRegion(this.psychic_stealth_x1, this.psychic_stealth_y1, this.psychic_stealth_x2, this.psychic_stealth_y2, this.psychic_stealth_)
    }

    static psychic_stealth()
    {
        ; tooltip_center("vocum psychic_stealth")
        if hp.Check("Psylocke")
        {
            ; tooltip_center("hp")
            psychic_stealth := isImage_there(this.psychic_stealth_x1, this.psychic_stealth_y1, this.psychic_stealth_x2, this.psychic_stealth_y2, this.psychic_stealth_, 25)
            if psychic_stealth.result
            {
                ; send_key("E")
                send_key(var.mouse_middle_code, true)
            }
        }
    }
}
class loki{

    static deception_x1 := 1523, deception_y1 := 979, deception_x2 := 1525, deception_y2 := 981
    static location_    := "\images\Loki\"
    static deception_    := this.location_ . "deception.png"

    static capture() {
        ; CaptureScreenRegion(this.deception_x1, this.deception_y1, this.deception_x2, this.deception_y2, this.deception_)
    }

    static deception()
    {
        ; tooltip_center("vocum deception")
        if hp.Check("Loki")
        {
            ; tooltip_center("hp")
            deception := isImage_there(this.deception_x1, this.deception_y1, this.deception_x2, this.deception_y2, this.deception_, 25)
            if deception.result
            {
                ; send_key("E")
                send_key(var.mouse_right_code, true)
            }
        }
    }
}
class rocket_raccoon{ ; Pic

    static gun_x1 := 271, gun_y1 := 1007, gun_x2 := 294, gun_y2 := 1008
    static location_    := "\images\Rocket_Raccoon\"
    static gun_    := this.location_ . "gun.png"

    static capture() {
        ; CaptureScreenRegion(this.gun_x1, this.gun_y1, this.gun_x2, this.gun_y2, this.gun_)
    }

    static repair_mode()
    {
        ; tooltip_center("repair_mode")
        if hp.Check("Rocket Raccoon")
        {
            n_variants := 25
            gun := isImage_there(this.gun_x1, this.gun_y1, this.gun_x2, this.gun_y2, this.gun_, n_variants)
            if gun.result
            {
                ; tooltip_center("hp")
                send_key(var.mouse_right_code, true)
                Sleep 700
            }
        }
    }
}
class luna_snow{

    static ice_arts_x1 := 1670, ice_arts_y1 := 994, ice_arts_x2 := 1675, ice_arts_y2 := 999
    static location_    := "\images\Luna_Snow\"
    static ice_arts_    := this.location_ . "ice_arts.png"

    static capture() {
        ; CaptureScreenRegion(this.ice_arts_x1, this.ice_arts_y1, this.ice_arts_x2, this.ice_arts_y2, this.ice_arts_)
    }

    static ice_arts()
    {
        ; tooltip_center("ice_arts")
        if hp.Check("Luna Snow")
        {
            ; tooltip_center("hp")
            ice_arts := isImage_there(this.ice_arts_x1, this.ice_arts_y1, this.ice_arts_x2, this.ice_arts_y2, this.ice_arts_, 25)
            if ice_arts.result
            {
                send_key("E")
                ; send_key(var.mouse_right_code, true)
            }
        }
    }
}
class adam_warlock{

    static avatar_life_stream_x1 := 1539, avatar_life_stream_y1 := 979, avatar_life_stream_x2 := 1544, avatar_life_stream_y2 := 984
    static location_    := "\images\Adam_Warlock\"
    static avatar_life_stream_    := this.location_ . "avatar_life_stream.png"

    static capture() {
        ; CaptureScreenRegion(this.avatar_life_stream_x1, this.avatar_life_stream_y1, this.avatar_life_stream_x2, this.avatar_life_stream_y2, this.avatar_life_stream_)
    }

    static avatar_life_stream()
    {
        ; tooltip_center("avatar_life_stream")
        if hp.Check("Adam Warlock")
        {
            ; tooltip_center("hp")
            avatar_life_stream := isImage_there(this.avatar_life_stream_x1, this.avatar_life_stream_y1, this.avatar_life_stream_x2, this.avatar_life_stream_y2, this.avatar_life_stream_, 25)
            if avatar_life_stream.result
            {
                ; send_key("E")
                send_key(var.mouse_middle_code, true)
            }
        }
    }
}
class jeff_the_land_shark{

    static hide_and_seek_x1 := 1677, hide_and_seek_y1 := 981, hide_and_seek_x2 := 1682, hide_and_seek_y2 := 986
    static location_    := "\images\Jeff_The_Land_Shark\"
    static hide_and_seek_    := this.location_ . "hide_and_seek.png"

    static capture() {
        ; CaptureScreenRegion(this.hide_and_seek_x1, this.hide_and_seek_y1, this.hide_and_seek_x2, this.hide_and_seek_y2, this.hide_and_seek_)
    }

    static hide_and_seek()
    {
        ; tooltip_center("hide_and_seek")
        if hp.Check("Jeff The Land Shark")
        {
            ; tooltip_center("hp")
            hide_and_seek := isImage_there(this.hide_and_seek_x1, this.hide_and_seek_y1, this.hide_and_seek_x2, this.hide_and_seek_y2, this.hide_and_seek_, 25)
            if hide_and_seek.result
            {
                send_key("E")
                ; send_key(var.mouse_middle_code, true)
            }
        }
    }
}
class captain_america{

    static living_legend_x1 := 1510, living_legend_y1 := 991, living_legend_x2 := 1512, living_legend_y2 := 992
    static arm_x1 := 235, arm_y1 := 1004, arm_x2 := 250, arm_y2 := 1006
    static location_    := "\images\Captain_America\"
    static living_legend_    := this.location_ . "living_legend.png"
    static arm_    := this.location_ . "arm.png"

    static capture() {
        ; CaptureScreenRegion(this.living_legend_x1, this.living_legend_y1, this.living_legend_x2, this.living_legend_y2, this.living_legend_)
        ; CaptureScreenRegion(this.arm_x1, this.arm_y1, this.arm_x2, this.arm_y2, this.arm_)
    }

    static living_legend()
    {
        arm := isImage_there(this.arm_x1, this.arm_y1, this.arm_x2, this.arm_y2, this.arm_, 25)

        if hp.Check("Captain America")
        {
            ; tooltip_center("captain america")
            ; tooltip_center("hp")
            living_legend := isImage_there(this.living_legend_x1, this.living_legend_y1, this.living_legend_x2, this.living_legend_y2, this.living_legend_, 25)
            if living_legend.result
            {
                ; send_key("E")

                ; AHI.SendMouseButtonEvent(mouse.id, var.mouse_right_code, 1)
                send_key(var.mouse_right_code, true)
            }
        }
    }
}
class mister_fantastic{
    static reflexive_rubber_x1 := 1665, reflexive_rubber_y1 := 974, reflexive_rubber_x2 := 1668, reflexive_rubber_y2 := 980
    static location_    := "\images\Mister_Fantastic\"
    static reflexive_rubber_    := this.location_ . "reflexive_rubber.png"

    static capture() {
        ; CaptureScreenRegion(this.reflexive_rubber_x1, this.reflexive_rubber_y1, this.reflexive_rubber_x2, this.reflexive_rubber_y2, this.reflexive_rubber_)
    }

    static reflexive_rubber()
    {
        reflexive_rubber := isImage_there(this.reflexive_rubber_x1, this.reflexive_rubber_y1, this.reflexive_rubber_x2, this.reflexive_rubber_y2, this.reflexive_rubber_, 25)

        if hp.Check("Mister Fantastic")
        {
            ; tooltip_center("Mister Fantastic")
            ; tooltip_center("hp")
            reflexive_rubber := isImage_there(this.reflexive_rubber_x1, this.reflexive_rubber_y1, this.reflexive_rubber_x2, this.reflexive_rubber_y2, this.reflexive_rubber_, 25)
            if reflexive_rubber.result
            {
                send_key("E")

                ; AHI.SendMouseButtonEvent(mouse.id, var.mouse_right_code, 1)
                ; send_key(var.mouse_right_code, true)
            }
        }
    }
}
class invisible_woman{
    static double_jump_x1 := 1455, double_jump_y1 := 978, double_jump_x2 := 1458, double_jump_y2 := 980
    static double_jump_2_x1 := 1455, double_jump_2_y1 := 978, double_jump_2_x2 := 1458, double_jump_2_y2 := 980
    static location_    := "\images\Invisible_Woman\"
    static double_jump_    := this.location_ . "double_jump.png"
    static double_jump_2_    := this.location_ . "double_jump_2.png"

    static capture() {
        ; CaptureScreenRegion(this.double_jump_x1, this.double_jump_y1, this.double_jump_x2, this.double_jump_y2, this.double_jump_)
        ; CaptureScreenRegion(this.double_jump_2_x1, this.double_jump_2_y1, this.double_jump_2_x2, this.double_jump_2_y2, this.double_jump_2_)
    }

    static double_jump()
    {
        double_jump := isImage_there(this.double_jump_x1, this.double_jump_y1, this.double_jump_x2, this.double_jump_y2, this.double_jump_, 25)

        if hp.Check("Invisible Woman")
        {
            ; tooltip_center("Invisible Woman")
            double_jump_2 := isImage_there(this.double_jump_2_x1, this.double_jump_2_y1, this.double_jump_2_x2, this.double_jump_2_y2, this.double_jump_2_, 25)
            if double_jump_2.result
            {
                send_key("Space")

                ; AHI.SendMouseButtonEvent(mouse.id, var.mouse_right_code, 1)
                ; send_key(var.mouse_right_code, true)
            }
            else
            {
                double_jump := isImage_there(this.double_jump_x1, this.double_jump_y1, this.double_jump_x2, this.double_jump_y2, this.double_jump_, 25)
                if double_jump.result
                {
                    send_key("Space")
                    send_key("Space")
                }
            }

        }
    }
}
; --- Helper Functions ---
tooltip_center(text, sleep_time := 400) {
    ScreenWidth := SysGet(78)  ; Update screen width if needed
    ScreenHeight := SysGet(79)  ; Update screen height if needed
    CenterOfTheScreenX := ScreenWidth // 2
    CenterOfTheScreenY := ScreenHeight // 2

    Tooltip(text, CenterOfTheScreenX, CenterOfTheScreenY)
    if not (sleep_time == -1)
    {
        Sleep sleep_time
        Tooltip()
    }
}
isImage_there(x1, y1, x2, y2, path, n_variation := -1) {
    ; n_variation 0 to 255
    ImagePath := A_ScriptDir . path
    SearchX1 := x1
    SearchY1 := y1
    SearchX2 := x2
    SearchY2 := y2

    ; Perform the image search
    if (n_variation == -1) {
        result := ImageSearch(&FoundX, &FoundY, SearchX1, SearchY1, SearchX2, SearchY2, ImagePath)
    } else {
        result := ImageSearch(&FoundX, &FoundY, SearchX1, SearchY1, SearchX2, SearchY2, "*" . n_variation . " " . ImagePath)
    }

    ; Return the result as an object
    return {result: result, FoundX: FoundX, FoundY: FoundY}
}
CaptureScreenRegion(x1, y1, x2, y2, outputPath) {
    ; Calculate the width and height of the region
    outputFile := A_ScriptDir . outputPath
    width := x2 - x1
    height := y2 - y1

    command := Format('nircmd savescreenshot "{1}" {2} {3} {4} {5}', outputFile, x1, y1, width, height)
    ; A_Clipboard := command
    RunWait(command)
    tooltip_center(outputPath, 1000)
}
send_key(key, isMouse := false, delay := 64) {
    if not isMouse
    {
        AHI.SendKeyEvent(keyboard.id, GetKeySC(key), 1)
        Sleep(delay)
        AHI.SendKeyEvent(keyboard.id, GetKeySC(key), 0)
        Sleep(delay)
    }
    else
    {
        AHI.SendMouseButtonEvent(mouse.id, key, 1)
        Sleep(delay)
        AHI.SendMouseButtonEvent(mouse.id, key, 0)
        Sleep(delay)
    }
}
