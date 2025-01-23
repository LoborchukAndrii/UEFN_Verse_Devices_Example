
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }


GetText<localizes>(Translate:string):message= "{Translate}"
PlayerNameToMessage<localizes>(Agent:agent):message="{Agent}"

Overlay_UI_Device := class(creative_device):

    @editable
    PlayersTeams : team_settings_and_inventory_device = team_settings_and_inventory_device{}

    @editable
    ScoreTracker : tracker_device = tracker_device{}

    var PlayersOverlays : []widget = array{}

    var LeaderboardList : []stack_box = array{}

    var PlayersScores : [int][]tuple(widget, int) = map{}

    # @editable
    # Spawner : player_spawner_device = player_spawner_device{}

    OnBegin<override>()<suspends>:void=

        for(Index := 0..9):
            set PlayersOverlays += array{GenerateOverlay()}

        Print("Length of overlay {PlayersOverlays.Length}", ?Duration:=6.0)

        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)


        PlayersTeams.TeamMemberSpawnedEvent.Subscribe(OnAgentAdded)
        # Spawner.SpawnedEvent.Subscribe(OnAgentAdded)

        spawn:
            UpdateScore()

    UpdateScore()<suspends>:void=
        loop:
            Sleep(0.1)

            for(Leaderboard : LeaderboardList):
                for(ScoreWidgetsTeam : PlayersScores):
                    for(ScoreWidget : ScoreWidgetsTeam):
                        Leaderboard.RemoveWidget(ScoreWidget(0))

            for(Team := 0..9):
                if:
                    set PlayersScores[Team] = array{}

            AllPlayers := GetPlayspace().GetPlayers()

            for(Player : AllPlayers):
                PlayerNickname := PlayerNameToMessage(Player)
                Score := ScoreTracker.GetValue(Player)
                if (PlayersScores[0].Length = 0):
                    for(Index := 0..9):
                        NewWidget := GenerateLeaderboard(PlayerNickname, Score)
                        if:
                            set PlayersScores[Index] = array{(NewWidget, Score)}
                else:
                    var IsAdded : logic = false
                    if:
                        LeaderboardLength := PlayersScores[0].Length
                        # Print("Length {PlayersScores[0].Length}", ?Duration:=0.5)
                    then:
                        for(Index := 0..LeaderboardLength - 1):
                            if (ScoreInfo := PlayersScores[Index]):
                                if (Score > ScoreInfo[0](1)):
                                    for(Team := 0..9):
                                        NewWidget := GenerateLeaderboard(PlayerNickname, Score)
                                        if:
                                            NewArray := PlayersScores[Team].Insert[Index, array{(NewWidget, Score)}]
                                            set PlayersScores[Team] = NewArray
                                    set IsAdded = true
                                else if (Index = PlayersScores[0].Length - 1 and IsAdded = false):
                                    for(Team := 0..9):
                                        NewWidget := GenerateLeaderboard(PlayerNickname, Score)
                                        if:
                                            set PlayersScores[Team] += array{(NewWidget, Score)}

            for(Leaderboard:LeaderboardList):
                if:
                    Index := LeaderboardList.Find[Leaderboard]
                    ScoreInfo := PlayersScores[Index]
                then:
                    for(Info:ScoreInfo):
                        Leaderboard.AddWidget(stack_box_slot{Widget:=Info(0), Padding:= margin{Left:=0.0, Top:=10.0, Right:=0.0, Bottom:=10.0}})

    GetAgentTeamIndex(Agent:agent):int=
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()
        var TeamIndex : int = 0
        if:
            GetPlayerTeam := TeamCollection.GetTeam[Agent]

            for(Index := 0..Teams.Length):
                if (Teams[Index] = GetPlayerTeam):
                    set TeamIndex = Index
        return TeamIndex   

    OnAgentAdded(Agent:agent): void =
        PlayerTeam := GetAgentTeamIndex(Agent)
        if:
            Player := player[Agent]
            PlayerUI := GetPlayerUI[Player]
            RealOverlay := PlayersOverlays[PlayerTeam]
            Print("Added overlay", ?Duration:=6.0)
        then:
            PlayerUI.AddWidget(RealOverlay)

    OnPlayerAdded(Player:player): void =
        PlayerTeam := GetAgentTeamIndex(Player)
        if:
            PlayerUI := GetPlayerUI[Player]
            RealOverlay := PlayersOverlays[PlayerTeam]
            Print("Added overlay", ?Duration:=6.0)
        then:
            PlayerUI.AddWidget(RealOverlay)

    GenerateLeaderboard(PlayerName:message, Score:int) : widget =
        stack_box:
            Orientation := orientation.Horizontal
            Slots:= array:
                stack_box_slot:
                    Widget:= text_block:
                        DefaultText := PlayerName
                        DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}

                stack_box_slot:
                    Widget:= text_block:
                        DefaultText := GetText(": {Score}")
                        DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}

    GenerateOverlay() : widget =

        Leaderboard := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot: 
                    Widget:= text_block:
                        DefaultText := GetText("Leaderboard")
                        DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}

        set LeaderboardList += array{Leaderboard}
        
        canvas:
            Slots:= array:                  
                canvas_slot:
                    Alignment:= vector2{X:=1.0, Y:=1.0}
                    Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.2, Y:= 0.2}}
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot: 
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Widget:=overlay:
                                    Slots := array:
                                        overlay_slot: 
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding:= margin{Left:=0.0, Top:=0.0, Right:=0.0, Bottom:=0.0}
                                            Widget:= color_block:
                                                DefaultColor:= color{R:= 1.0, B:= 1.0, G:= 1.0}
                                                DefaultOpacity := 0.75
                        
                                        overlay_slot: 
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding:= margin{Left:=20.0, Top:=0.0, Right:=20.0, Bottom:=0.0}
                                            Widget:= color_block:
                                                DefaultColor:= color{R:= 0.0, B:= 1.0, G:= 0.0}
                                                DefaultOpacity := 0.75

                                        overlay_slot:
                                            Padding:= margin{Left:=25.0, Top:=10.0, Right:=25.0, Bottom:=10.0}
                                            Widget:= Leaderboard
