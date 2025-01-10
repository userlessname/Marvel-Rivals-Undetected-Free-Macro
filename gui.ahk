#Requires AutoHotkey v2.0
; myGui := gui_()   ; Sınıf örneği oluştur

class gui_ {
    ; ------------------------------------------------------------
    ; 1) GLOBAL GİBİ OLAN AYARLARI ARTIK SINIF DEĞİŞKENLERİ OLARAK TANIMLIYORUZ
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

    ; Bölüm durumları ve fonksiyon durumlarını tutacak Map() yapıları
    sectionStates  := Map()  ; sectionStates[charName] -> true/false
    functionStates := Map()  ; functionStates[charName][func_name or slider] -> değer

    ; Her grubun içerisindeki karakterleri tutan dizi (Map içinde Array)
    groupSections  := Map()

    ; GUI ve boyut
    gui            := ""
    guiWidth       := 0

    ; Grupların X pozisyonları
    xDefence       := 0
    xAttack        := 0
    xHealer        := 0

    ; ------------------------------------------------------------
    ; SINIF OLUŞTUĞUNDA (CONSTRUCTOR) YAPILACAKLAR
    ; ------------------------------------------------------------
    __New() {
        ; 1) Grup dizilerini ayarla
        this.groupSections["Defence"] := []
        this.groupSections["Attack"]  := []
        this.groupSections["Healer"]  := []

        ; 2) Ana GUI oluştur
        this.gui := Gui("+Resize", "Marvel Rivals Characters")
        this.gui.BackColor := 0x619c4a

        ; 3) Grupların x konumlarını hesapla
        this.xDefence := this.xMarginLeft
        this.xAttack  := this.xDefence + this.sectionW + this.groupSpacing
        this.xHealer  := this.xAttack  + this.sectionW + this.groupSpacing

        ; 4) Grup başlıklarını ekle
        this.gui.AddText("x" (this.xDefence + (this.sectionW / 2) - 30) " y" (this.yMarginTop - 30), "Defence")
        this.gui.AddText("x" (this.xAttack  + (this.sectionW / 2) - 30) " y" (this.yMarginTop - 30), "Attack")
        this.gui.AddText("x" (this.xHealer  + (this.sectionW / 2) - 30) " y" (this.yMarginTop - 30), "Healer")

        ; 5) Tüm karakterleri ekleyen metodu çağır
        this.AddAllCharacterSections()

        ; 6) GUI boyutunu ayarla ve göster
        this.guiWidth := (3 * this.sectionW) + (2 * this.groupSpacing) + this.xMarginLeft + this.xMarginRight
        this.gui.Show("w" this.guiWidth " h" this.currentGuiHeight)

        ; 7) Başlangıçta tüm bölümler kapalı olacağı için layout’u ilk kez uygula
        this.LayoutAllGroups()

        ; 8) Pencere kapatılınca script sonlansın
        this.gui.OnEvent("Close", (*) => ExitApp())
    }

    ; ------------------------------------------------------------
    ; 2) TÜM KARAKTERLERİ TOPLUCA EKLEME
    ; ------------------------------------------------------------
    AddAllCharacterSections() {
        ; Defence
        this.AddCharacterSection("Defence", "Hulk",            ["Indestructible Guard", "Jump"], 70, 18)
        this.AddCharacterSection("Defence", "Captain America", ["Living Legend"],                                          60)
        this.AddCharacterSection("Defence", "Venom",           ["Symbiotic Resilience"],                                  70)
        this.AddCharacterSection("Defence", "Magneto",         ["Iron Bulwark", "Metallic Curtain"],                      70, 18)
        this.AddCharacterSection("Defence", "Thor",            ["Lightning Realm"],                                       70)

        ; Attack
        this.AddCharacterSection("Attack",  "Scarlet Witch",   ["Mystic Projection"],                                     70)
        this.AddCharacterSection("Attack",  "Namor",           ["Blessing of The Deep"],                                  50)
        this.AddCharacterSection("Attack",  "Psylocke",        ["Psychic Stealth"],                                       70)
        this.AddCharacterSection("Attack",  "Wolverine",       ["Undying Animal"],                                        80)
        this.AddCharacterSection("Attack",  "Mister Fantastic",["Reflexive Rubber"],                                      50)

        ; Healer
        this.AddCharacterSection("Healer",  "Loki",            ["Deception"],                                             40)
        this.AddCharacterSection("Healer",  "Mantis",          ["Natural Anger"],                                         100)
        this.AddCharacterSection("Healer",  "Rocket Raccoon",  ["Repair Mode"],                                           95)
        this.AddCharacterSection("Healer",  "Luna Snow",       ["Ice Arts"],                                              60)
        this.AddCharacterSection("Healer",  "Adam Warlock",    ["Avatar Life Stream"],                                    40)
        this.AddCharacterSection("Healer",  "Jeff The Land Shark", ["Hide and Seek"],                                     60)
        this.AddCharacterSection("Healer",  "Invisible Woman", ["Double Jump"],                                           70)
    }

    ; ------------------------------------------------------------
    ; 3) BİR KARAKTER BÖLÜMÜ (SECTION) EKLEME
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
    ; 4) TÜM GRUPLARI LAYOUT ET (Defence, Attack, Healer)
    ; ------------------------------------------------------------
    LayoutAllGroups() {
        this.LayoutGroupSections("Defence")
        this.LayoutGroupSections("Attack")
        this.LayoutGroupSections("Healer")
        this.AdjustGuiSize()
    }
    getSliderHpNumber(charName){
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
            ; Validate that the value is a number
            if RegExMatch(value, "^-?\d+$") {
                return value
            }
        }
        ; If not found or invalid, return a default value or "invalid"
        return "invalid"
    }
    ; Belirli bir grup içindeki tüm bölümleri yatay/dikey konumlandır
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

            ; Toggle buton konumu
            toggleBtn.Move(xPos, yPos, this.sectionW - 20, this.buttonHeight)
            yPos += (this.buttonHeight + 15)

            ; Eğer açılmışsa (expanded) kontrolleri sırayla yerleştir
            if (isExpanded) {
                for ctrl in controls {
                    ctrl.Move(xPos + 20, yPos)
                    ctrl.Visible := true

                    ; Kontrol tipine göre dikey boşluğu artır
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
                yPos += 5
            } else {
                ; Kapalıysa tüm kontrolleri gizle
                for ctrl in controls
                    ctrl.Visible := false
            }
        }
    }

    ; ------------------------------------------------------------
    ; 5) BÖLÜMLERİ AÇ/KAPA (ToggleSection)
    ; ------------------------------------------------------------
    ToggleSection(groupName, charName) {
        this.sectionStates[charName] := !this.sectionStates[charName]
        local newState := this.sectionStates[charName]

        ; İsteğe bağlı: Sadece bir karakterin bölümü açık kalsın diyorsak:
        if (newState) {
            this.CollapseAllSectionsExcept(charName)
        }

        ; Tekrar layout uygula
        this.LayoutAllGroups()
    }

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
    ; 6) CHECKBOX, EDIT, SLIDER EVENT HANDLER METOTLARI
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
    
                ; Sadece farklı karakter/seksiyonda ise
                if (cName != currentSectionName) {
                    ; 1) Kontroller arasındaki bütün checkbox’ları kapat
                    for ctrl in controls {
                        if (ctrl.Type == "CheckBox") {
                            ctrl.Value := false
                        }
                    }
                    
                    ; 2) Bellekte tuttuğumuz functionStates içindeki ilgili değerleri de false yap
                    if (this.functionStates.Has(cName)) {
                        for funcKey, funcVal in this.functionStates[cName] {
                            ; Örneğin "slider" ya da "Metallic Curtain_AddOrMinus" gibi 
                            ; numeric/string değerleri ellememek isteyebiliriz.
                            ; Sadece true/false olan "checkbox" fonksiyonlarını kapatalım:
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
    ; 7) GUI YÜKSEKLİĞİNİ İHTİYACA GÖRE AYARLA
    ; ------------------------------------------------------------
    AdjustGuiSize() {
        local maxY := 0

        for group, sections in this.groupSections {
            local tempY := this.yMarginTop
            for sectionArr in sections {
                local charName      := sectionArr[1]
                local cSpacing      := sectionArr[4]
                local isExpanded    := this.sectionStates[charName]

                ; Toggle buton yüksekliği
                tempY += (this.buttonHeight + 5)

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
}