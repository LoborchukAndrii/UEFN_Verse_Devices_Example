
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }

var PlayerMoney:weak_map(player, float) = map{}

#                    Custom Event For Float (Money)
####################################################################################

money_mult_fun := type{_(:player, :float):float}

money_fun := type{_(:player):void}

my_float := class:

    var PlayersFunctions<private>:[player][]money_fun = map{}

    var PlayersTextBlocks<private>:[player][]text_block = map{}
    
    Subscribe<public>(Player:player, TextBlock:text_block):void =
            if:
                set PlayersTextBlocks[Player] += array{TextBlock}
            else:
                logic:
                    set PlayersTextBlocks[Player] = array{TextBlock}
            
    Bind(Player:player, Func:money_fun):void=
        if:
            set PlayersFunctions[Player] += array{Func}
        else:
            logic:
                set PlayersFunctions[Player] = array{Func}

    Dispatch<public>(Player:player, Amount:float):void =
        for (Block:PlayersTextBlocks[Player]):
            Block.SetText(GetText(ToTruncatedString(Amount, 2)))

        for(Func:PlayersFunctions[Player]):
            Func(Player)

my_widget := class:

    var PlayersNotificationWindow<private>:[player]stack_box = map{}

    var PlayersNotifications<private>:[player][]widget = map{}

    var PlayersNotificationsThread<private>:[player]logic = map{}

    RemovePlayerNotification(Player:player)<suspends>:void=
        logic:
            set PlayersNotificationsThread[Player] = true
        loop:
            Sleep(1.0)
            if:
                Window := PlayersNotificationWindow[Player]
                Notification := PlayersNotifications[Player][0]
                NewArray := PlayersNotifications[Player].RemoveElement[0]
                set PlayersNotifications[Player] = NewArray
            then:
                Window.RemoveWidget(Notification)
                
            if (PlayersNotifications[Player].Length = 0):
                logic:
                    set PlayersNotificationsThread[Player] = false
                break


    Subscribe<public>(Player:player, Stack:stack_box):void =
            logic:
                set PlayersNotificationWindow[Player] = Stack
                set PlayersNotificationsThread[Player] = false
            
    
    Dispatch<public>(Player:player, Notification:stack_box_slot, NewWidget:widget):void =
        if:
            Window := PlayersNotificationWindow[Player]
        then:
            Window.AddWidget(Notification)
            if:
                set PlayersNotifications[Player] += array{NewWidget}
            else:
                logic:
                    set PlayersNotifications[Player] = array{NewWidget}
            if (PlayersNotificationsThread[Player] = false):
                spawn:
                    RemovePlayerNotification(Player)
            

###################################################################################

Bank_Device := class(creative_device):

    var MoneyMultiplier : ?money_mult_fun = false

    MoneyNotifier : my_float = my_float{}

    Notification : my_widget = my_widget{}

    GetPlayerMoney(Player:player) : float =
        if:
            Amount := PlayerMoney[Player]
        then:
            return Amount
        else:
            logic:
                set PlayerMoney[Player] = 0.0
            return 0.0

    AddPlayerMoney(Player:player, Amount:float) : void =
        if:
            CurrentAmount := PlayerMoney[Player]
            Func := MoneyMultiplier?
        then:
            NewAmount := Func(Player, Amount)
            logic:
                set PlayerMoney[Player] = CurrentAmount + NewAmount         

            NotificationUI := GetNotification(NewAmount)
            Notification.Dispatch(Player, NotificationUI(0), NotificationUI(1))
            MoneyNotifier.Dispatch(Player, CurrentAmount + NewAmount)

    RemovePlayerMoney(Player:player, Amount:float) : void =
        if:
            CurrentAmount := PlayerMoney[Player]
            set PlayerMoney[Player] = CurrentAmount - Amount
        then:
            MoneyNotifier.Dispatch(Player, CurrentAmount - Amount)

    PlayerHasEnoughMoney(Player:player, Amount:float) : logic =
        var HasMoney : logic = false
        if:
            CurrentAmount := PlayerMoney[Player]
        then:
            set HasMoney = logic{CurrentAmount >= Amount}
        return HasMoney
    
