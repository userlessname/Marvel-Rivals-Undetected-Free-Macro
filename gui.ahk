#Requires AutoHotkey v2.0

; myGui := gui_()   ; Sınıf örneği oluştur

class gui_ {
    ; ------------------------------------------------------------
    ; 1) SINIF DEĞİŞKENLERİ (GLOBAL GİBİ) TANIMLAMA
    ; ------------------------------------------------------------
    xMarginLeft     := 10
    xMarginRight    := 8
    yMarginTop      := 50
    yMarginBottom   := 42
    sectionW        := 300
    groupSpacing    := 20

    buttonHeight    := 30
    checkboxSpacing := 22
    sliderSpacing   := 35

    defaultShield2Value := "-40"
    currentGuiHeight    := 500

    sectionStates  := Map()  ; sectionStates[charName] -> true/false
    functionStates := Map()  ; functionStates[charName][func_name or slider] -> değer

    ; Her grubun içerisindeki karakterleri tutan yapı (Map içinde Array)
    groupSections  := Map()

    gui            := ""
    guiWidth       := 0

    xDefence       := 0
    xAttack        := 0
    xHealer        := 0

    ; ------------------------------------------------------------
    ; 2) CONSTRUCTOR: SINIF OLUŞTUĞUNDA ÇALIŞAN BÖLÜM
    ; ------------------------------------------------------------
    __New() {
        ; a) Grup dizilerini (Array) ayarla
        this.groupSections["Defence"] := []
        this.groupSections["Attack"]  := []
        this.groupSections["Healer"]  := []

        ; b) Ana GUI oluştur
        this.gui := Gui("+Resize", "Marvel Rivals Characters")
        ; this.gui := Gui("-DPIScale +E0x02000000", "Marvel Rivals Characters")
        this.gui.BackColor := 0x619c4a

        ; c) Grupların x konumlarını hesapla
        this.xDefence := this.xMarginLeft
        this.xAttack  := this.xDefence + this.sectionW + this.groupSpacing
        this.xHealer  := this.xAttack  + this.sectionW + this.groupSpacing

        ; d) Grup başlıklarını ekle
        this.gui.AddText("x" (this.xDefence + (this.sectionW / 2) - 30) " y" (this.yMarginTop - 30), "Defence")
        this.gui.AddText("x" (this.xAttack  + (this.sectionW / 2) - 30) " y" (this.yMarginTop - 30), "Attack")
        this.gui.AddText("x" (this.xHealer  + (this.sectionW / 2) - 30) " y" (this.yMarginTop - 30), "Healer")

        ; e) Karakterleri ekle
        this.AddAllCharacterSections()

        ; f) GUI boyutunu ayarla ve göster
        this.guiWidth := (3 * this.sectionW) + (2 * this.groupSpacing) + this.xMarginLeft + this.xMarginRight
        this.gui.Show("w" this.guiWidth " h" this.currentGuiHeight)

        ; g) Başlangıçta tüm bölümler kapalı: layout’u ilk kez uygula
        this.LayoutAllGroups()

        ; h) Pencere kapatılınca script sonlansın
        this.gui.OnEvent("Close", (*) => ExitApp())
    }

    ; ------------------------------------------------------------
    ; 3) TÜM KARAKTERLERİ TOPLUCA EKLEME
    ; ------------------------------------------------------------
    AddAllCharacterSections() {
        ; Defence
        this.AddCharacterSection("Defence", "Hulk",            ["Indestructible Guard", "Jump"], 70, 18)
        this.AddCharacterSection("Defence", "Captain America", ["Living Legend"],                 60)
        this.AddCharacterSection("Defence", "Venom",           ["Symbiotic Resilience"],          70)
        this.AddCharacterSection("Defence", "Magneto",         ["Iron Bulwark", "Metallic Curtain"], 70, 18)
        this.AddCharacterSection("Defence", "Thor",            ["Lightning Realm"],               70)

        ; Attack
        this.AddCharacterSection("Attack",  "Scarlet Witch",   ["Mystic Projection"],             70)
        this.AddCharacterSection("Attack",  "Namor",           ["Blessing of The Deep"],          50)
        this.AddCharacterSection("Attack",  "Psylocke",        ["Psychic Stealth"],               70)
        this.AddCharacterSection("Attack",  "Wolverine",       ["Undying Animal"],                80)
        this.AddCharacterSection("Attack",  "Mister Fantastic",["Reflexive Rubber"],              50)

        ; Healer
        this.AddCharacterSection("Healer",  "Loki",            ["Deception"],                     40)
        this.AddCharacterSection("Healer",  "Mantis",          ["Natural Anger"],                 100)
        this.AddCharacterSection("Healer",  "Rocket Raccoon",  ["Repair Mode"],                   95)
        this.AddCharacterSection("Healer",  "Luna Snow",       ["Ice Arts"],                      60)
        this.AddCharacterSection("Healer",  "Adam Warlock",    ["Avatar Life Stream"],            40)
        this.AddCharacterSection("Healer",  "Jeff The Land Shark", ["Hide and Seek"],             60)
        this.AddCharacterSection("Healer",  "Invisible Woman", ["Double Jump"],                   70)
    }

    ; ------------------------------------------------------------
    ; 4) BİR KARAKTER BÖLÜMÜ (SECTION) EKLEME
    ; ------------------------------------------------------------
    AddCharacterSection(groupName, charName, functions_names, defaultSliderValue := 50, customCheckboxSpacing := 25) {
        ; Başlangıçta kapalı olacak
        this.sectionStates[charName] := false

        ; Toggle butonu yarat
        toggleBtn := this.gui.AddButton("w280 h" this.buttonHeight, charName)
        toggleBtn.OnEvent("Click", (*) => this.ToggleSection(groupName, charName))

        ; Kontrolleri tutacak bir dizi
        controls := []

        ; CheckBox’ları ekle
        index := 0
        checkbox_1 := ""
        checkbox_2 := ""
        for func_name in functions_names {
            index += 1
            if (index == 1)
            {
                checkbox_1 := func_name
            }
            else if (index == 2)
            {
                checkbox_2 := func_name
            }
        }

        index := 0
        for func_name in functions_names {
            index += 1
            local f_name := func_name
            ; ToolTip(func_name)
            
            ; =======================================================================================
            ; cb := this.gui.AddCheckBox("w300 h20", f_name)
            ; cb.Visible := false
            ; ; Closure: tıklanınca HandleCheckboxClick metodunu çağıracak
            ; cb.OnEvent("Click", (ctrl, *) => this.HandleCheckboxClick(charName, f_name, ctrl))
            ; controls.Push(cb)
            ; =======================================================================================
            if (index == 1)
            {
                cb := this.gui.AddCheckBox("w300 h20", checkbox_1)
                cb.Visible := false
                cb.OnEvent("Click", (ctrl, *) => this.HandleCheckboxClick(charName, checkbox_1, ctrl))
                controls.Push(cb)
            }
            else if (index == 2)
            {
                cb := this.gui.AddCheckBox("w300 h20", checkbox_2)
                cb.Visible := false
                cb.OnEvent("Click", (ctrl, *) => this.HandleCheckboxClick(charName, checkbox_2, ctrl))
                controls.Push(cb)
            }
            ; =======================================================================================
            ; Magneto + Metallic Curtain => Edit kutusu ekle
            if (charName = "Magneto" && f_name = "Metallic Curtain") {
                textLabel := this.gui.AddText("w90", "Hp Add or Minus:")
                textLabel.Visible := false
                controls.Push(textLabel)

                hpInput := this.gui.AddEdit("w60 h20", this.defaultShield2Value)
                hpInput.Visible := false
                hpInput.OnEvent("Change", (ctrl, *) => this.HandleShield2InputChange(charName, ctrl))
                controls.Push(hpInput)

                ; Magneto durumu hafızaya kaydet
                if !this.functionStates.Has(charName)
                    this.functionStates[charName] := Map()
                this.functionStates[charName]["Metallic Curtain_AddOrMinus"] := this.defaultShield2Value
            }
        }

        ; HP label ve slider
        hpText := this.gui.AddText("w40", "HP:")
        hpText.Visible := false
        controls.Push(hpText)

        slider := this.gui.AddSlider("Range0-100 ToolTip w200 h20", defaultSliderValue)
        slider.Visible := false
        slider.OnEvent("Change", (ctrl, *) => this.HandleSliderChange(charName, ctrl))
        controls.Push(slider)

        ; functionStates’e kaydet (slider başlangıç değeri)
        if !this.functionStates.Has(charName)
            this.functionStates[charName] := Map()
        this.functionStates[charName]["slider"] := defaultSliderValue

        ; Son olarak bu karakteri, ilgili gruba ekle
        this.groupSections[groupName].Push([charName, toggleBtn, controls, customCheckboxSpacing])
    }

    ; ------------------------------------------------------------
    ; 5) TÜM GRUPLARI TEKRAR LAYOUT ETME
    ; ------------------------------------------------------------
    LayoutAllGroups() {
        this.LayoutGroupSections("Defence")
        this.LayoutGroupSections("Attack")
        this.LayoutGroupSections("Healer")
        this.AdjustGuiSize()
    
        ; Tüm yerleşim bitince yeniden boyama zorlaması
        DllCall("RedrawWindow"
            , "Ptr", this.gui.Hwnd
            , "Ptr", 0
            , "Ptr", 0
            , "UInt", 0x0401)
    }
    

    ; Bir gruptaki tüm karakterleri tek tek yerleştir
    LayoutGroupSections(groupName) {
        local xPos := (groupName = "Defence") ? this.xDefence
                 : (groupName = "Attack")    ? this.xAttack
                 : this.xHealer

        local yPos := this.yMarginTop

        for sectionArr in this.groupSections[groupName] {
            charName   := sectionArr[1]
            toggleBtn  := sectionArr[2]
            controls   := sectionArr[3]
            cSpacing   := sectionArr[4]

            local isExpanded := this.sectionStates[charName]

            ; 1) Toggle butonunu yerleştir
            toggleBtn.Move(xPos, yPos, this.sectionW - 20, this.buttonHeight)
            ; Butondan sonra + 15 piksel boşluk
            yPos += (this.buttonHeight + 15)

            ; 2) Bölüm açıksa kontrolleri tek tek göstermek
            if (isExpanded) {
                for ctrl in controls {
                    ctrl.Move(xPos + 20, yPos)
                    ctrl.Visible := true

                    if (ctrl.Type = "CheckBox") {
                        yPos += cSpacing
                    }
                    else if (ctrl.Type = "Text") {
                        yPos += 20
                    }
                    else if (ctrl.Type = "Edit") {
                        yPos += 25
                    }
                    else if (ctrl.Type = "Slider") {
                        yPos += this.sliderSpacing
                    }
                }
                ; Kontrollerin bitimine +5 piksel
                yPos += 5
            } else {
                ; Kapalıysa hepsini gizle
                for ctrl in controls {
                    ctrl.Visible := false
                }
            }
        }
    }

    ; ------------------------------------------------------------
    ; 6) GUI YÜKSEKLİĞİNİ DİNAMİK AYARLA
    ; ------------------------------------------------------------
    AdjustGuiSize() {
        local maxY := 0

        for group, sections in this.groupSections {
            local tempY := this.yMarginTop
            for sectionArr in sections {
                local charName   := sectionArr[1]
                local cSpacing   := sectionArr[4]
                local isExpanded := this.sectionStates[charName]

                ; Toggle buton + 15 piksel boşluk
                tempY += (this.buttonHeight + 15)

                if (isExpanded) {
                    local controls := sectionArr[3]
                    for ctrl in controls {
                        if (ctrl.Type = "CheckBox") {
                            tempY += cSpacing
                        }
                        else if (ctrl.Type = "Text") {
                            tempY += 20
                        }
                        else if (ctrl.Type = "Edit") {
                            tempY += 25
                        }
                        else if (ctrl.Type = "Slider") {
                            tempY += this.sliderSpacing
                        }
                    }
                    tempY += 5
                }
            }
            if (tempY > maxY) {
                maxY := tempY
            }
        }

        local neededHeight := maxY + this.yMarginBottom

        ; Pencereyi gerekliyse dikeyde büyüt
        if (neededHeight > this.currentGuiHeight) {
            this.gui.Move(, , , neededHeight)
            this.currentGuiHeight := neededHeight
        }
    }

    ; ------------------------------------------------------------
    ; 7) BÖLÜMÜ AÇ/KAPA (ToggleSection)
    ; ------------------------------------------------------------
    ToggleSection(groupName, charName) {
        this.sectionStates[charName] := !this.sectionStates[charName]
        local newState := this.sectionStates[charName]

        ; Sadece bir bölüm açık kalsın diyorsanız:
        if (newState) {
            this.CollapseAllSectionsExcept(charName)
        }

        ; Tekrar tüm grupları layout et
        this.LayoutAllGroups()
    }

    ; Tüm diğer section’ları kapat
    CollapseAllSectionsExcept(exceptCharName) {
        for group, sections in this.groupSections {
            for sectionArr in sections {
                local cName := sectionArr[1]
                if (cName != exceptCharName) {
                    this.sectionStates[cName] := false
                }
            }
        }
    }

    ; ------------------------------------------------------------
    ; 8) CHECKBOX, EDIT, SLIDER EVENT HANDLER’LARI
    ; ------------------------------------------------------------
    HandleCheckboxClick(sectionName, funcName, checkCtrl) {
        if !this.functionStates.Has(sectionName)
            this.functionStates[sectionName] := Map()
    
        this.functionStates[sectionName][funcName] := checkCtrl.Value  ; true/false
    
        ; Eğer checkbox işaretlendiyse, diğer tüm section’ların checkbox’larını kapat
        if (checkCtrl.Value) {
            this.UncheckOtherSectionsExcept(sectionName)
        }
    
        ; Magneto + Metallic Curtain => Edit kutusunu enable/disable
        if (sectionName == "Magneto" && funcName == "Metallic Curtain") {
            this.EnableDisableMagnetoEdit(checkCtrl.Value)
        }
    }

    EnableDisableMagnetoEdit(checked) {
        for group, sections in this.groupSections {
            for sectionArr in sections {
                local cName    := sectionArr[1]
                local controls := sectionArr[3]
                if (cName = "Magneto") {
                    for ctrl in controls {
                        if (ctrl.Type = "Edit") {
                            ctrl.Enabled := checked
                            ; Devre dışı kaldıysa varsayılan değere sıfırla
                            if (!checked) {
                                ctrl.Value := this.defaultShield2Value
                                this.functionStates["Magneto"]["Metallic Curtain_AddOrMinus"] := this.defaultShield2Value
                            }
                        }
                    }
                }
            }
        }
    }

    UncheckOtherSectionsExcept(currentSectionName) {
        for group, sections in this.groupSections {
            for sectionArr in sections {
                local cName    := sectionArr[1]
                local controls := sectionArr[3]

                ; Farklı karakter için tüm checkbox’ları false yap
                if (cName != currentSectionName) {
                    for ctrl in controls {
                        if (ctrl.Type == "CheckBox") {
                            ctrl.Value := false
                        }
                    }
                    ; Bellekteki functionStates true/false değerleri de false
                    if (this.functionStates.Has(cName)) {
                        for funcKey, funcVal in this.functionStates[cName] {
                            if (funcVal = true || funcVal = false) {
                                this.functionStates[cName][funcKey] := false
                            }
                        }
                    }
                }
            }
        }
    }

    HandleShield2InputChange(sectionName, inputCtrl) {
        local inputValue := inputCtrl.Value

        ; Boş veya sadece '-' girilmişse geçici olarak dokunma
        if (inputValue = "" || inputValue = "-") {
            return
        }
        ; RegEx ile sayı olup olmadığını kontrol et (- işareti dahil)
        if !RegExMatch(inputValue, "^-?\d+$") {
            ; Geçersiz giriş
            inputCtrl.Value := this.functionStates[sectionName]["Metallic Curtain_AddOrMinus"]
            return
        }
        this.functionStates[sectionName]["Metallic Curtain_AddOrMinus"] := inputValue
    }

    HandleSliderChange(sectionName, sliderCtrl) {
        local sliderValue := sliderCtrl.Value

        if !this.functionStates.Has(sectionName)
            this.functionStates[sectionName] := Map()

        this.functionStates[sectionName]["slider"] := sliderValue
    }

    ; ------------------------------------------------------------
    ; 9) EK YARDIMCI METOTLAR (İsteğe Bağlı)
    ; ------------------------------------------------------------
    getSliderHpNumber(charName) {
        if (this.functionStates.Has(charName) && this.functionStates[charName].Has("slider")) {
            return this.functionStates[charName]["slider"]
        }
        return 0
    }

    IsAbilityActive(charName, funcName) {
        return this.functionStates.Has(charName)
            && this.functionStates[charName].Has(funcName)
            && this.functionStates[charName][funcName]   ; true/false
    }

    GetAddOrMinusValue(sectionName, funcName) {
        if (this.functionStates.Has(sectionName) && this.functionStates[sectionName].Has(funcName "_AddOrMinus")) {
            local value := this.functionStates[sectionName][funcName "_AddOrMinus"]
            if RegExMatch(value, "^-?\d+$") {
                return value
            }
        }
        return "invalid"
    }
}
