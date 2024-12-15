
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }

Texture<public> := module:
    Overlay<public> := module:
    Store<public> := module:
    Exotic<public> := module:
    Mythic<public> := module:
    Boosters<public> := module:

GetText<localizes>(Translate:string):message= "{Translate}"

FindCharIndex(SearchChar:char, Str:[]char)<transacts><decides>:int=
    var FoundIndex:int = 0
    var Found:logic = false
    for (X -> Char : Str, not Found?):
        if (Char = SearchChar):
            set FoundIndex = X
    FoundIndex

ToTruncatedString(Number:float, Decimals:int):[]char=
    var Str:[]char = ToString(Number)
    if:
        DotIndex := FindCharIndex['.', Str]
        StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
        NewStr := Str.Slice[0, StopIndex] 
        set Str = NewStr
    Str

    #                    Custom Event For Int (Headshots)
####################################################################################
my_int := class:

    var PlayersTextBlocks<private>:[player][]text_block = map{}
    
    Subscribe<public>(Player:player, TextBlock:text_block):void =
            if:
                set PlayersTextBlocks[Player] += array{TextBlock}
            else:
                logic:
                    set PlayersTextBlocks[Player] = array{TextBlock}
            
    
    Dispatch<public>(Player:player, Amount:int):void =
        for (Block:PlayersTextBlocks[Player]):
            Block.SetText(GetText("{Amount}"))

###################################################################################

GetNotification(Amount:float): tuple(stack_box_slot, widget) =
    NewWidget := stack_box:
        Orientation := orientation.Horizontal
        Slots := array:
            stack_box_slot:
                Widget := texture_block:
                    DefaultDesiredSize := vector2{X:= 50.0, Y:= 50.0}
                    DefaultImage := Texture.Overlay.Dollar_icon
            stack_box_slot:
                Widget := text_block:
                    DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}
                    DefaultText:= GetText(ToTruncatedString(Amount, 2))
    Slot := stack_box_slot :
        Widget:= NewWidget
    return (Slot, NewWidget)

Overlay_UI_Device := class(creative_device):

    @editable
    Bank : Bank_Device = Bank_Device{}

    @editable
    PlayersTeams : team_settings_and_inventory_device = team_settings_and_inventory_device{}

    @editable
    Headshot_Tracker : tracker_device = tracker_device{}

    HeadshotNotifier : my_int = my_int{}

    var PlayersOverlay : [player]widget = map{}

    # @editable
    # Spawner : player_spawner_device = player_spawner_device{}

    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)


        PlayersTeams.TeamMemberSpawnedEvent.Subscribe(OnAgentAdded)
        # Spawner.SpawnedEvent.Subscribe(OnAgentAdded)

        spawn:
            UpdateHeadshots()

    UpdateHeadshots()<suspends> : void =
        loop:
            Sleep(1.0)
            for(Player : GetPlayspace().GetPlayers()):
                HeadshotNotifier.Dispatch(Player, Headshot_Tracker.GetValue(Player))

    OnAgentAdded(Agent:agent): void =
        if:
            Player := player[Agent]
            not PlayersOverlay[Player]
            PlayerUI := GetPlayerUI[Player]
            Print("Added overlay", ?Duration:=6.0)
        then:
            Bank.GetPlayerMoney(Player)
            NewOverlay := GenerateOverlay(Player)
            logic:
                set PlayersOverlay[Player] = NewOverlay
            PlayerUI.AddWidget(NewOverlay)

    OnPlayerAdded(Player:player): void =
        if:
            not PlayersOverlay[Player]
            PlayerUI := GetPlayerUI[Player]
            Print("Added overlay", ?Duration:=6.0)
        then:
            Bank.GetPlayerMoney(Player)
            NewOverlay := GenerateOverlay(Player)
            logic:
                set PlayersOverlay[Player] = NewOverlay
            PlayerUI.AddWidget(NewOverlay)

    GenerateOverlay(Player:player) : widget =
        MoneyText := text_block:
            DefaultText := GetText(ToTruncatedString(Bank.GetPlayerMoney(Player), 2))
            DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}

        Bank.MoneyNotifier.Subscribe(Player, MoneyText)

        HeadshotText := text_block:
            DefaultText := GetText("{Headshot_Tracker.GetValue()}")
            DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}

        HeadshotNotifier.Subscribe(Player, HeadshotText)

        NotificationWindow := stack_box:
            Orientation := orientation.Vertical
            Slots := array{}

        Bank.Notification.Subscribe(Player, NotificationWindow)
        
        canvas:
            Slots:= array:                  
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:= 0.85, Y:= 0.4}, Maximum := vector2{X:= 1.0, Y:= 0.6}}
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot: 
                                HorizontalAlignment := horizontal_alignment.Right
                                Widget:= stack_box:
                                    Orientation := orientation.Horizontal
                                    Slots:= array:
                                        stack_box_slot:
                                            Widget:= texture_block:
                                                DefaultDesiredSize := vector2{X:= 100.0, Y:= 50.0}
                                                DefaultImage := Texture.Overlay.Headshot_Icon2

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Right
                                            Padding := margin{Left:= 25.0, Right := 25.0}
                                            Widget:= HeadshotText

                            stack_box_slot: 
                                HorizontalAlignment := horizontal_alignment.Right
                                Widget:= stack_box:
                                    Orientation := orientation.Horizontal
                                    Slots:= array:
                                        stack_box_slot:
                                            Widget:= texture_block:
                                                DefaultDesiredSize := vector2{X:= 50.0, Y:= 50.0}
                                                DefaultImage := Texture.Overlay.Dollar_icon

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Right
                                            Padding := margin{Right := 25.0}
                                            Widget:= MoneyText

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:= 0.55, Y:= 0.4}, Maximum := vector2{X:= 0.65, Y:= 0.6}}
                    Widget := NotificationWindow
                        
