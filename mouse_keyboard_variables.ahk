#Requires AutoHotkey v2.0+
; mouse := mouse_(AHI) ; mouse haraketiyle device seçme
; keyboard := keyboard_(AHI) ; keyboard tuş basmayla keyboard seçme

; --- Class Mouse ---
class mouse_ {
    AHI := ""
    deviceList := ""
    handle := ""   
    acquired := false
    id := ""

    __New(AHI, handle := "") {
        this.AHI := AHI
        this.deviceList := this.AHI.GetDeviceList()
        if (handle == "")
        {
            this.subs()
            Sleep 200
            this.MouseMoveWaitToContinue()
            Sleep 200
        }
        else
        {
            this.handle := handle
            this.id := this.AHI.GetMouseIdFromHandle(this.handle)
            this.acquired := true
        }
    }

    ; Fare hareketlerini dinleme ve fareyi seçme
    subs() {
        for deviceId, info in this.deviceList {
            if info.IsMouse { ; Eğer cihaz bir fare ise
                this.AHI.SubscribeMouseMove(deviceId, false, this.WaitForMouseMove.Bind(this, info.Handle), true)
            }
        }
    }

    ; Fare hareketi algılandığında
    WaitForMouseMove(handle, x, y) {
        if (this.acquired) ; Eğer fare zaten alındıysa, hiçbir şey yapma
            return

        ; İlk mouse hareketi algılandığında
        this.handle := handle ; Handle'ı kaydet
        this.acquired := true ; Fare hareketinin alındığını işaretle

        ; Tüm farelerden dinlemeyi kaldır
        for deviceId, info in this.deviceList {
            if info.IsMouse {
                this.AHI.UnsubscribeMouseMove(deviceId) ; Aboneliği kaldır
            }
        }
        ; this.id := this.AHI.GetMouseIdFromHandle(this.handle)

        ; Seçilen fare bilgilerini göster
        ; MsgBox("Fare Seçildi!`nHandle: " this.handle "`nID: " this.id)
    }
    MouseMoveWaitToContinue(){
        ; Fareyi ekran koordinatlarına göre takip edeceğiz
        CoordMode("Mouse", "Screen")
     
        ;  helper_.tooltip_center("Please move your mouse to set", -1)
     
        ; Mevcut fare konumunu kaydet
        MouseGetPos(&oldX, &oldY)

        ; Fare konumu değişene kadar bekle
        helper_.tooltip_center("Please move your mouse", -1)
        While True {
            Sleep 10 ; CPU kullanımını aşırı yükseltmemek için kısa bir bekleme ekliyoruz
            MouseGetPos(&x, &y)
            if (x != oldX || y != oldY) {
                Break
            }
        } 
        ;  helper_.tooltip_center("Mouse SET", 1000)
    }
} 
; --- Class Keyboard ---
class keyboard_ {
    AHI := ""
    deviceList := ""
    handle := ""   
    acquired := false
    id := ""

    __New(AHI, handle := "") {
        this.AHI := AHI
        this.deviceList := this.AHI.GetDeviceList()
        if (handle == "")
        {
            this.subs()
            Sleep 200
            this.KeyWaitAnyToContinue()
            Sleep 200
        }
        else
        {
            this.handle := handle
            this.id := this.AHI.GetKeyboardIdFromHandle(this.handle)
            this.acquired := true
        }
    }
    ; Fare hareketlerini dinleme ve fareyi seçme
    subs() {
        for deviceId, info in this.deviceList {
            if !info.IsMouse { ; Eğer cihaz bir klavye ise
                this.AHI.SubscribeKeyboard(deviceId, false, this.WaitForKeyPress.Bind(this, info.Handle), true)
            }
        }
    }
    ; Fare hareketi algılandığında
    WaitForKeyPress(handle, code, state) {
        if (this.acquired) ; Eğer tuş zaten alındıysa, hiçbir şey yapma
            return 
        if (state = 1) { ; Sadece tuş basımı olayını işlemek için
            this.handle := handle ; Handle'ı kaydet
            this.acquired := true ; Tuşun alındığını işaretle
    
            ; Tüm klavyelerden dinlemeyi kaldır
            for deviceId, info in this.deviceList {
                if !info.IsMouse {
                    this.AHI.UnsubscribeKeyboard(deviceId) ; Aboneliği kaldır
                }
            }  
            ; this.id := this.AHI.GetKeyboardIdFromHandle(this.handle)
            ToolTip ; ToolTip'i kapat 
        }
    }
    KeyWaitAnyToContinue(){
        helper_.tooltip_center("Please press any key from keyboard", -1)
        ih := InputHook()
        ih.KeyOpt("{All}", "E")  ; End
        ih.Start()
        ih.Wait()
        ih.Stop()
    }
}

; --- Constans ---
class variables_ {
    One_state := false

    mouse_left_state := false
    LCtrl_state := false
    LAlt_state := false
    BackTick_state := false
    BackTick_toggle := false
    active_deactive_toggle := true

    set(name, value){
        Switch name {
            Case "mouse_left_state":
                this.mouse_left_state := value
            Case "LCtrl_state":
                this.LCtrl_state := value
            Case "LAlt_state":
                this.LAlt_state := value
            Case "BackTick_state":
                this.BackTick_state := value
            Case "BackTick_toggle":
                this.BackTick_toggle := value
            Default:
                helper_.tooltip_center("invalid set name")
        }
    }

    mouse_left_code := 0
    mouse_right_code := 1
    mouse_middle_code := 2
    mouse_side1_code := 3
    mouse_side2_code := 4
    mouse_wheel_vertical_code := 5
    mouse_wheel_horizontal_code := 6
    
    NestedConstants := {
        NESTED_CONST_ONE: "NestedValue1",
        NESTED_CONST_TWO: "NestedValue2"
    }
    ; static _instance := ""
    
    ; __New() {
    ;     ; ; Ensure only one instance of the class
    ;     ; if (this.__Class._instance) {
    ;     ;     throw Exception("Cannot create multiple instances of Constants. Use Constants.GetInstance() to get the object.")
    ;     ; }
    ; }
    
    ; static GetInstance() {
    ;     ; Create the singleton instance if it doesn't exist
    ;     if !this._instance {
    ;         this._instance := this()
    ;     }
    ;     return this._instance
    ; }
}

; --- Helper Functions ---
class helper_{
    static tooltip_center(text, sleep_time := 400) {
        ScreenWidth := SysGet(78)  ; Update screen width if needed
        ScreenHeight := SysGet(79)  ; Update screen height if needed
        CenterOfTheScreenX := ScreenWidth // 2
        CenterOfTheScreenY := ScreenHeight // 2
    
        Tooltip text, CenterOfTheScreenX, CenterOfTheScreenY
        if not (sleep_time == -1)
        {
            Sleep sleep_time
            Tooltip
        }
    }
}
