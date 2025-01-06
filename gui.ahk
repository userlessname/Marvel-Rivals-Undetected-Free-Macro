#Requires AutoHotkey v2.0

; -------------------------------------------------------------------
; GLOBAL SETTINGS
; -------------------------------------------------------------------
global xMarginLeft     := 10
global xMarginRight    := 8
global yMarginTop      := 50  ; Increased top margin for group labels
global yMarginBottom   := 42
global sectionW        := 300
global buttonSpacing   := 30
global sectionSpacing  := 5
global groupSpacing    := 20  ; Space between groups

; Varsayılan input değerleri (Default input values)
global defaultShield2Value := "-40"

; Bölümlerin open/close durumu, toggleBtn ve Controls dizilerini tutar
; (Holds open/close states of sections, toggleBtn, and Controls arrays)
global sectionStates := Map()
global functionStates := Map()

; -------------------------------------------------------------------
; MAIN GUI
; -------------------------------------------------------------------
myGui := Gui("+Resize", "Marvel Rivals Characters")
myGui.BackColor := 0x619c4a

; Define group positions
xDefence := xMarginLeft
xAttack := xDefence + sectionW + groupSpacing
xHealer := xAttack + sectionW + groupSpacing

; Initialize Y positions for each group
global yPosDefence := yMarginTop
global yPosAttack := yMarginTop
global yPosHealer := yMarginTop

; Add Group Labels
myGui.AddText("x" (xDefence + (sectionW / 2) - 30) " y" (yMarginTop - 30), "Defence")
myGui.AddText("x" (xAttack + (sectionW / 2) - 30) " y" (yMarginTop - 30), "Attack")
myGui.AddText("x" (xHealer + (sectionW / 2) - 30) " y" (yMarginTop - 30), "Healer")

; -------------------------------------------------------------------
; Add Defence Group Characters
; -------------------------------------------------------------------
hulk_indestructible_guard       := "Indestructible Guard"
hulk_jump                       := "Jump (does not need hp check)"
magneto_iron_bulwark            := "Iron Bulwark"
magneto_metallic_curtain        := "Metallic Curtain"
venom_symbiotic_resilience      := "Symbiotic Resilience"
thor_lightning_realm            := "Lightning Realm"

AddCharacterSection(myGui, "Hulk", [hulk_indestructible_guard, hulk_jump], xDefence, &yPosDefence, 70)
AddCharacterSection(myGui, "Magneto", [magneto_iron_bulwark, magneto_metallic_curtain], xDefence, &yPosDefence, 70)
AddCharacterSection(myGui, "Venom", [venom_symbiotic_resilience], xDefence, &yPosDefence, 70)
AddCharacterSection(myGui, "Thor", [thor_lightning_realm], xDefence, &yPosDefence, 70)

; -------------------------------------------------------------------
; Add Attack Group Characters
; -------------------------------------------------------------------
wolverine_undying_animal        := "Undying Animal"
scarletWitch_mystic_projection  := "Mystic Projection"
namor_blessing_of_the_deep      := "Blessing of The Deep"
psylocke_psychic_stealth        := "Psychic Stealth"

AddCharacterSection(myGui, "Wolverine", [wolverine_undying_animal], xAttack, &yPosAttack, 80)
AddCharacterSection(myGui, "Scarlet Witch", [scarletWitch_mystic_projection], xAttack, &yPosAttack, 70)
AddCharacterSection(myGui, "Namor", [namor_blessing_of_the_deep], xAttack, &yPosAttack, 50)
AddCharacterSection(myGui, "Psylocke", [psylocke_psychic_stealth], xAttack, &yPosAttack, 70)

; -------------------------------------------------------------------
; Add Healer Group Characters
; -------------------------------------------------------------------
mantis_natural_anger            := "Natural Anger"
loki_deception                  := "Deception"
rocket_raccoon_repair_mode      := "Repair Mode"
adam_warlock_avatar_life_stream := "Avatar Life Stream"
jeff_the_land_shark_hide_and_seek := "Hide and Seek"
luna_snow_ice_arts := "Ice Arts"

AddCharacterSection(myGui, "Mantis", [mantis_natural_anger], xHealer, &yPosHealer, 100)
AddCharacterSection(myGui, "Loki", [loki_deception], xHealer, &yPosHealer, 40)
AddCharacterSection(myGui, "Rocket Raccoon", [rocket_raccoon_repair_mode], xHealer, &yPosHealer, 95)
AddCharacterSection(myGui, "Adam Warlock", [adam_warlock_avatar_life_stream], xHealer, &yPosHealer, 40)
AddCharacterSection(myGui, "Jeff The Land Shark", [jeff_the_land_shark_hide_and_seek], xHealer, &yPosHealer, 60)
AddCharacterSection(myGui, "Luna Snow", [luna_snow_ice_arts], xHealer, &yPosHealer, 60)

; -------------------------------------------------------------------
; Show GUI
; -------------------------------------------------------------------
; Calculate total GUI width to accommodate three groups
guiWidth := (3 * sectionW) + (2 * groupSpacing) + xMarginLeft + xMarginRight
myGui.Show("w" guiWidth " h550")
AdjustGuiSize(myGui)

; -------------------------------------------------------------------
; CLOSE OLAYI İÇİN OLAY İŞLEYİCİ EKLE
; (Add event handler for close event)
; -------------------------------------------------------------------
myGui.OnEvent("Close", (*) => ExitApp())

; -------------------------------------------------------------------
; FUNCTION: AddCharacterSection
; PURPOSE:  Karakter için toggle butonu + kontrol checkbox'ları ve slider ekler
; (Adds a toggle button + control checkboxes and slider for the character)
; -------------------------------------------------------------------
AddCharacterSection(guiObj, charName, functions_names, baseX, &baseY, defaultSliderValue := 50) {
    global sectionW, buttonSpacing, sectionSpacing
    global sectionStates, functionStates, defaultShield2Value

    ; Initialize section state as closed
    sectionStates[charName] := false

    ; Add toggle button at (baseX, baseY)
    toggleBtn := guiObj.AddButton(
        "x" baseX
      . " y" baseY
      . " w" (sectionW - xMarginLeft - xMarginRight)
      . " h30"
      , charName
    )
    sectionStates[charName "ToggleBtn"] := toggleBtn

    ; Event handler for toggle button
    toggleBtn.OnEvent("Click", (*) => ToggleSection(guiObj, charName))

    ; Increment Y position for next control
    baseY += buttonSpacing

    ; Create controls (checkboxes, HP text, and slider)
    controls := []

    ; Add checkboxes
    for func_name in functions_names {
        local f_name := func_name
        cb := guiObj.AddCheckBox("x" (baseX + 10) " y" (baseY + 10), f_name)
        cb.OnEvent("Click", HandleCheckboxClickClosure(charName, f_name, cb)) ; Closure event handler
        controls.Push(cb)

        ; **Add Input Box for Specific Functions**
        if (charName = "Magneto" && func_name = "Metallic Curtain") {
            ; Add the label "Add or Minus"
            add_or_minus_text := "Hp Add or Minus:"
            addOrMinusText := guiObj.AddText("x" (baseX + 110) " y" (baseY + 10), add_or_minus_text)
            controls.Push(addOrMinusText)

            ; Add the input box (Edit control)
            hpInputBox := guiObj.AddEdit("x" (baseX + 200) " y" (baseY + 8) " w60 h15", defaultShield2Value)

            ; Validation event handler
            hpInputBox.OnEvent("Change", (*) => HandleShield2InputChange(charName, hpInputBox))

            controls.Push(hpInputBox)

            ; Initialize shield2_AddOrMinus
            if (!functionStates.Has(charName)) {
                functionStates[charName] := Map()
            }
            if (!functionStates[charName].Has("Metallic Curtain_AddOrMinus")) {
                functionStates[charName]["Metallic Curtain_AddOrMinus"] := defaultShield2Value
            }
        }

        baseY += 25  ; Increment Y for next checkbox
    }

    ; Add HP Text
    hpText := guiObj.AddText("x" (baseX + 10) " y" (baseY + 5), "HP:")
    controls.Push(hpText)

    ; Add Slider
    slider := guiObj.AddSlider(
        "x" (baseX + 60) " y" baseY " w" (sectionW - xMarginLeft - xMarginRight - 70) " Range0-100 ToolTip",
        defaultSliderValue
    )
    slider.OnEvent("Change", (*) => HandleSliderChange(charName, slider))
    controls.Push(slider)

    baseY += 40  ; Increment Y after slider

    ; Save controls and hide them initially
    sectionStates[charName "Controls"] := controls
    for ctrl in controls
        ctrl.Visible := false

    ; Add slider's default value to functionStates
    if (!functionStates.Has(charName)) {
        functionStates[charName] := Map()
    }
    functionStates[charName]["slider"] := defaultSliderValue
}


; -------------------------------------------------------------------
; EVENT HANDLER: HandleCheckboxClickClosure
; PURPOSE:  Creates a closure for the HandleCheckboxClick event handler
; -------------------------------------------------------------------
HandleCheckboxClickClosure(sectionName, funcName, checkCtrl){
    return (*) => HandleCheckboxClick(sectionName, funcName, checkCtrl)
}

; -------------------------------------------------------------------
; EVENT HANDLER: HandleCheckboxClick
; PURPOSE: Checkbox durumunu güncelle (Update checkbox status)
; -------------------------------------------------------------------
HandleCheckboxClick(sectionName, funcName, checkCtrl) {
    global functionStates, sectionStates
    ; Update functionStates
    if !functionStates.Has(sectionName)
        functionStates[sectionName] := Map()
    functionStates[sectionName][funcName] := checkCtrl.Value

    ; Eğer bu checkbox yeni seçildiyse, diğer bölümlerdeki checkbox'ları temizle
     ; (If this checkbox is newly selected, clear checkboxes in other sections)
    if (checkCtrl.Value) {
        UncheckOtherSections(sectionName, funcName)
    }

    ; **Enable/Disable the Input Box for shield2**
    if (sectionName = "Magneto" && funcName = "Metallic Curtain") {
        local controls := sectionStates[sectionName "Controls"]
        for index, ctrl in controls {
            if (ctrl.Type = "Edit") {
                ctrl.Enabled := checkCtrl.Value
                if (!checkCtrl.Value) {
                    ctrl.Value := defaultShield2Value ; Reset to default global değişken (Reset to default global variable)
                    functionStates[sectionName]["Metallic Curtain_AddOrMinus"] := defaultShield2Value
                }
            }
        }
    }

    ; Debugging için ToolTip ekleyebilirsiniz
    ; (You can add a ToolTip for debugging)
    ; tooltip_center("Clicked checkbox: " sectionName " - " funcName " - " checkCtrl.Value)
}

; -------------------------------------------------------------------
; EVENT HANDLER: HandleShield2InputChange
; PURPOSE:  Update the AddOrMinus value for shield2 in functionStates
; -------------------------------------------------------------------
HandleShield2InputChange(sectionName, inputCtrl) {
    global functionStates, defaultShield2Value
    local inputValue := inputCtrl.Value

    ; Allow empty input or just a minus sign without validation
    if (inputValue = "" || inputValue = "-") {
        return
    }

    ; Validate that the input is a number (integer, positive or negative)
    if !RegExMatch(inputValue, "^-?\d+$") {
        ; MsgBox("Lütfen shield2 için geçerli bir sayı girin.") ; "Please enter a valid number for shield2."
        inputCtrl.Value := functionStates[sectionName].Has("Metallic Curtain_AddOrMinus") ? functionStates[sectionName]["Metallic Curtain_AddOrMinus"] : defaultShield2Value
        return
    }

    ; Update functionStates with the valid input
    if !functionStates.Has(sectionName)
        functionStates[sectionName] := Map()
    functionStates[sectionName]["Metallic Curtain_AddOrMinus"] := inputValue

    ; Optional: Display a tooltip for confirmation
     ; (Optional: Display a tooltip for confirmation)
    ; tooltip_center("shield2 AddOrMinus değeri güncellendi: " . inputValue, 1000)
}

; -------------------------------------------------------------------
; EVENT HANDLER: HandleSliderChange
; PURPOSE: Slider değerini güncelle (Update slider value)
; -------------------------------------------------------------------
HandleSliderChange(sectionName, sliderCtrl) {
    global functionStates
    local sliderValue := sliderCtrl.Value

    ; functionStates["Hulk"]["slider"] = değer gibi bir yapı (structure like functionStates["Hulk"]["slider"] = value)
    if !functionStates.Has(sectionName)
        functionStates[sectionName] := Map()

    functionStates[sectionName]["slider"] := sliderValue

    ; tooltip_center("Slider changed for " . sectionName . ": " . sliderValue, 1000)
}

; -------------------------------------------------------------------
; FUNCTION: UncheckOtherSections
; PURPOSE: Diğer tüm bölümlerdeki (sectionName hariç) checkbox’ların işaretlerini kaldır
; (Uncheck the checkboxes in all other sections (except sectionName))
; -------------------------------------------------------------------
UncheckOtherSections(currentSectionName, currentFuncName) {
    global sectionStates, functionStates
    for key, val in sectionStates.Clone() { ; sectionStates üzerinde değişiklik yapacağımız için Clone() kullanıyoruz (Using Clone() because we will change sectionStates)
        ; key = "HulkControls" gibi -> karakter adını alalım (key = like "HulkControls" -> let's get the character name)
        if InStr(key, "Controls") {
            local charName := StrReplace(key, "Controls")
            ; Aynı bölüm mü? atla (Is it the same section? skip)
            if (charName = currentSectionName)
                continue

            ; O bölümdeki bütün checkbox'ları uncheck yap
             ; (Uncheck all checkboxes in that section)
            local controls := sectionStates[key]
            for ctrl in controls {
                ; CheckBox türündeki kontrolleri hedefle (Target controls of type CheckBox)
                if (ctrl.Type = "CheckBox") {
                    if (ctrl.Text != currentFuncName) { ; Opsiyonel: belirli bir checkbox'u hariç tutmak isterseniz (Optional: if you want to exclude a specific checkbox)
                        ctrl.Value := false
                        ; functionStates'ı güncelle (update functionStates)
                        if (functionStates.Has(charName) && functionStates[charName].Has(ctrl.Text)) {
                            functionStates[charName][ctrl.Text] := false
                        }
                    }
                }
            }
        }
    }
}

; -------------------------------------------------------------------
; FUNCTION: ToggleSection
; PURPOSE:  Seçilmiş bölümü aç/kapa ve kontrollerin görünümünü güncelle
; (Opens/closes selected section and updates the visibility of controls)
; -------------------------------------------------------------------
ToggleSection(guiObj, charName) {
    global sectionStates, defaultShield2Value

    if !sectionStates.Has(charName)
        sectionStates[charName] := false

    ; Eğer bölüm kapalı ise, diğer tüm bölümleri kapat
    ; (If the section is closed, close all other sections)
    if (!sectionStates[charName]) {
        CollapseAllSectionsExcept(charName)
    }

    ; Açık/kapalı durumu tersine çevir (Reverse open/close state)
    sectionStates[charName] := !sectionStates[charName]
    local isExpanded := sectionStates[charName]

    ; İlgili kontroller (Related controls)
    if !sectionStates.Has(charName "Controls") {
        ; MsgBox("Hata: Bu bölümün kontrol listesi bulunamadı => " charName)
        ; (MsgBox("Error: The control list for this section was not found => " charName))
        return
    }
    local controls := sectionStates[charName "Controls"]

    ; Kontrolleri göster/gizle (Show/hide controls)
    for ctrl in controls
        ctrl.Visible := isExpanded

    ; **Enable shield2 input box based on checkbox state**
    if (charName = "Magneto") {
        for ctrl in controls {
            if (ctrl.Type = "Edit") {
                ; Find the shield2 checkbox state
                local shield2Checked := functionStates[charName].Has("Metallic Curtain") ? functionStates[charName]["Metallic Curtain"] : false
                ctrl.Enabled := shield2Checked
            }
        }
    }

    ; GUI boyutunu güncelle (Update GUI size)
    AdjustGuiSize(guiObj)
}

; -------------------------------------------------------------------
; FUNCTION: CollapseAllSectionsExcept
; PURPOSE:  Belirtilen bölüm hariç tüm bölümleri kapat
; (Closes all sections except the specified one)
; -------------------------------------------------------------------
CollapseAllSectionsExcept(exceptCharName) {
    global sectionStates, defaultShield2Value

    for key, val in sectionStates.Clone() { ; sectionStates üzerinde değişiklik yapacağımız için Clone() kullanıyoruz (Using Clone() because we will change sectionStates)
        if InStr(key, "Controls") || InStr(key, "ToggleBtn")
            continue

        if (key != exceptCharName && sectionStates[key]) {
            sectionStates[key] := false

            ; İlgili kontrolleri gizle (Hide related controls)
            if (sectionStates.Has(key "Controls")) {
                local controls := sectionStates[key "Controls"]
                for ctrl in controls
                    ctrl.Visible := false
            }
        }
    }
}

; -------------------------------------------------------------------
; FUNCTION: AdjustGuiSize
; PURPOSE:  Bölümlerin y ekseninde dizilimini ve GUI yüksekliğini güncelle
; (Updates the layout of sections on the y-axis and the GUI height)
; -------------------------------------------------------------------
AdjustGuiSize(guiObj) {
    global xMarginLeft, xMarginRight, yMarginTop, yMarginBottom, sectionW
    global groupSpacing, buttonSpacing, sectionSpacing, sectionStates, defaultShield2Value

    ; Calculate maximum Y position among all groups
    maxY := yMarginTop

    for group in ["Defence", "Attack", "Healer"] {
        yVar := "yPos" group
        if (maxY < %yVar%) {
            maxY := %yVar%
        }
    }

    ; Set GUI height based on the maximum Y position
    guiHeight := maxY + yMarginBottom
    guiObj.Move(, , , guiHeight)
}