
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.
GetText<localizes>(Translate:string):message= "{Translate}"

PlayerActivationInfo := class<final><persistable>:
    LastCode :string = ""

UpdatedPlayerInfo<constructor>(NewCode:string)<transacts> := PlayerActivationInfo:
    LastCode := NewCode

var PlayersInfo:weak_map(player, PlayerActivationInfo) = map{}

# A Verse-authored creative device that can be placed in a level
Code_Device := class(creative_device):

    @editable
    Trigger : button_device = button_device{}

    @editable
    Coins : item_granter_device = item_granter_device{}

    var PlayerText : [agent]text_block = map{}

    @editable
    Code : string = "2222"

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Trigger.InteractedWithEvent.Subscribe(ShowCodeUI)

        GetPlayspace().PlayerAddedEvent().Subscribe(PlayerConnected)

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
            GetPlayerInfo[Player].LastCode <> Code
        then:
            NewUI := GenerateCodeUI(Player)
            SlotInfo := player_ui_slot{ZOrder:=10, InputMode:= ui_input_mode.All}
            PlayerUI.AddWidget(NewUI, SlotInfo)

    GenerateCodeUI(Player:player): widget =
        PlayerWriter := text_block{}

        PlayerWriter.SetJustification(text_justification.Center)

        logic:
            set PlayerText[Player] = PlayerWriter

        DeleteButton := button_quiet:
            DefaultText := GetText("🔒")

        DeleteButton.OnClick().Subscribe(DeleteNumber)

        TryButton := button_quiet:
            DefaultText := GetText("🔑")

        TryButton.OnClick().Subscribe(SendNumber)

        ExitButton := button_quiet:
            DefaultText := GetText("🚪")

        ExitButton.OnClick().Subscribe(ExitFromUI)

        return canvas:
            Slots:= array:
                canvas_slot:
                    Anchors := anchors{Minimum:= vector2{X:= 0.5, Y:= 0.5}, Maximum:= vector2{X:= 0.5, Y:= 0.5}}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    Widget:=stack_box :
                        Orientation := orientation.Vertical
                        Slots:= array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                Widget:= PlayerWriter

                            stack_box_slot:
                                Widget:= stack_box :
                                    Orientation := orientation.Horizontal
                                    Slots:= array:
                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("1")

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("2")

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("3")

                            stack_box_slot:
                                Widget:= stack_box :
                                    Orientation := orientation.Horizontal
                                    Slots:= array:
                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("4")

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("5")

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("6")

                            stack_box_slot:
                                Widget:= stack_box :
                                    Orientation := orientation.Horizontal
                                    Slots:= array:
                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("7")

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("8")

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("9")

                            stack_box_slot:
                                Widget:= stack_box :
                                    Orientation := orientation.Horizontal
                                    Slots:= array:
                                        stack_box_slot:
                                            Widget:= DeleteButton

                                        stack_box_slot:
                                            Widget:= GenerateNumberButton("0")

                                        stack_box_slot:
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
            if (Code = SendedCode):
                if:
                    PlayerUI:= GetPlayerUI[Info.Player]
                    Root := Info.Source.GetRootWidget[]
                    set PlayersInfo[Info.Player] = UpdatedPlayerInfo(Code)
                then:
                    PlayerUI.RemoveWidget(Root)
                    Coins.GrantItem(Info.Player)
            else:
                TextBlock.SetText(GetText(""))

    ExitFromUI(Info:widget_message): void=
        if:
            PlayerUI:= GetPlayerUI[Info.Player]
            Root := Info.Source.GetRootWidget[]
        then:
            PlayerUI.RemoveWidget(Root)
                
            
