
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }

Reward_Fun := type{_(:int):void}

Notifier := class:

    var Functions : []Reward_Fun = array{}

    Bind(New_Function:Reward_Fun):void=
        set Functions += array{New_Function}

    Broadcast(Success_Index:int):void=
        for(Function:Functions):
            Function(Success_Index)



Custom_Code_Device := class(creative_device):

    ColorCategory<localizes>:message = "Color"
    TextCategory<localizes>:message = "Text"
    SettingsCategory<localizes>:message = "Settings"
    PaddingCategory<localizes>:message = "Padding"

    VerseNotifier : Notifier = Notifier{}

    @editable {Categories := array{ColorCategory}}
    BackColor : color = color{}

    @editable {Categories := array{ColorCategory}}
    PanelColor : color = color{}

    @editable {Categories := array{ColorCategory}}
    CodeInputPanelColor : color = color{}

    @editable {Categories := array{ColorCategory}}
    TextColor : color = color{}

    @editable {Categories := array{TextCategory}}
    ClearCodeText : string = "🔒"

    @editable {Categories := array{TextCategory}}
    EnterCodeText : string = "🔑"

    @editable {Categories := array{TextCategory}}
    ExitCodeText : string = "🚪"

    @editable {Categories := array{SettingsCategory}}
    CharacterLimit : int = 0

    @editable {Categories := array{PaddingCategory}}
    ButtonPanelPadding : float = 15.0

    @editable {Categories := array{PaddingCategory}}
    PanelPadding : float = 10.0

    @editable {Categories := array{PaddingCategory}}
    InputCodePaddingPadding : float = 5.0

    @editable {Categories := array{PaddingCategory}}
    ButtonPadding : float = 5.0

    @editable {Categories := array{SettingsCategory}}
    Code_Button : button_device = button_device{}

    @editable {Categories := array{SettingsCategory}}
    Rewards : []channel_device = array{}

    var PlayerText : [agent]text_block = map{}

    @editable {Categories := array{SettingsCategory}}
    Codes : []string = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Code_Button.InteractedWithEvent.Subscribe(ShowCodeUI)

        GetPlayspace().PlayerAddedEvent().Subscribe(PlayerConnected)

        VerseNotifier.Bind(Test)

    Test(Index:int):void=
        Print("Broadcast: {Index}", ?Duration:=6.0)

    PlayerConnected(Player:player): void =
        if:
            GetPlayerInfo[Player]

    GetPlayerInfo(Player:player)<transacts><decides>:PlayerActivationInfo=
        var Info : PlayerActivationInfo = UpdatedPlayerInfo()
        if:
            GetInfo := PlayersInfo[Player]
            set Info = GetInfo
        else:
            logic:
                set PlayersInfo[Player] = UpdatedPlayerInfo()
        return Info

    ShowCodeUI(Agent:agent): void =
        if:
            Player := player[Agent]
            PlayerUI:= GetPlayerUI[Player]
        then:
            NewUI := GenerateCodeUI(Player)
            SlotInfo := player_ui_slot{ZOrder:=10, InputMode:= ui_input_mode.All}
            PlayerUI.AddWidget(NewUI, SlotInfo)

    GenerateCodeUI(Player:player): widget =
        PlayerWriter := text_block{DefaultTextColor := TextColor}

        PlayerWriter.SetJustification(text_justification.Center)

        logic:
            set PlayerText[Player] = PlayerWriter

        DeleteButton := button_quiet:
            DefaultText := GetText(ClearCodeText)

        DeleteButton.OnClick().Subscribe(DeleteNumber)

        TryButton := button_quiet:
            DefaultText := GetText(EnterCodeText)

        TryButton.OnClick().Subscribe(SendNumber)

        ExitButton := button_quiet:
            DefaultText := GetText(ExitCodeText)

        ExitButton.OnClick().Subscribe(ExitFromUI)

        return canvas:
            Slots:= array:
                canvas_slot:
                    Anchors := anchors{Minimum:= vector2{X:= 0.5, Y:= 0.5}, Maximum:= vector2{X:= 0.5, Y:= 0.5}}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    Widget:= overlay:
                        Slots := array:
                            overlay_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Widget := color_block{DefaultColor:= BackColor}

                            overlay_slot:
                                Padding := margin{Left := PanelPadding, Right := PanelPadding, Top := PanelPadding, Bottom := PanelPadding}
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Widget := color_block{DefaultColor:= PanelColor}

                            overlay_slot:
                                Padding := margin{Left := ButtonPanelPadding, Right := ButtonPanelPadding, Top := ButtonPanelPadding, Bottom := ButtonPanelPadding}
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Widget := stack_box :
                                    Orientation := orientation.Vertical
                                    Slots:= array:
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            Widget:= overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Widget := color_block{DefaultColor:= CodeInputPanelColor}

                                                    overlay_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Padding := margin{Left := InputCodePaddingPadding, Right := InputCodePaddingPadding, Top := InputCodePaddingPadding, Bottom := InputCodePaddingPadding}
                                                        Widget := PlayerWriter

                                        stack_box_slot:
                                            Widget:= stack_box :
                                                Orientation := orientation.Horizontal
                                                Slots:= array:
                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("1")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("2")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("3")

                                        stack_box_slot:
                                            Widget:= stack_box :
                                                Orientation := orientation.Horizontal
                                                Slots:= array:
                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("4")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("5")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("6")

                                        stack_box_slot:
                                            Widget:= stack_box :
                                                Orientation := orientation.Horizontal
                                                Slots:= array:
                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("7")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("8")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("9")

                                        stack_box_slot:
                                            Widget:= stack_box :
                                                Orientation := orientation.Horizontal
                                                Slots:= array:
                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= DeleteButton

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= GenerateNumberButton("0")

                                                    stack_box_slot:
                                                        Padding := margin{Left := ButtonPadding, Right := ButtonPadding, Top := ButtonPadding, Bottom := ButtonPadding}
                                                        Widget:= TryButton

                                        stack_box_slot:
                                            Widget:= ExitButton


    GenerateNumberButton(Number:string): widget =
        Button := button_quiet:
            DefaultText := GetText(Number)

        Button.OnClick().Subscribe(AddNumber)

        return Button

    AddNumber(Info:widget_message): void=
        if:
            TextBlock := PlayerText[Info.Player]
            Button := button_quiet[Info.Source]
        then:
            Text := TextBlock.GetText()
            if (CharacterLimit > Text.Length or CharacterLimit = 0):
                NewText := Text + Button.GetText()
                TextBlock.SetText(GetText(NewText))

    DeleteNumber(Info:widget_message): void=
        if:
            TextBlock := PlayerText[Info.Player]
        then:
            TextBlock.SetText(GetText(""))

    SendNumber(Info:widget_message): void=
        if:
            TextBlock := PlayerText[Info.Player]
        then:
            SendedCode := TextBlock.GetText()
            for(Index := 0..Codes.Length):
                if (Codes[Index] = SendedCode):
                    if:
                        PlayerUI:= GetPlayerUI[Info.Player]
                        Root := Info.Source.GetRootWidget[]
                        # set PlayersInfo[Info.Player] = UpdatedPlayerInfo(Code)
                    then:
                        PlayerUI.RemoveWidget(Root)

                        if:
                            Transmitter := Rewards[Index]
                        then:
                            Transmitter.Transmit(option{Info.Player})

                    VerseNotifier.Broadcast(Index)
                else:
                    TextBlock.SetText(GetText(""))

    ExitFromUI(Info:widget_message): void=
        if:
            PlayerUI:= GetPlayerUI[Info.Player]
            Root := Info.Source.GetRootWidget[]
        then:
            PlayerUI.RemoveWidget(Root)
                
            
