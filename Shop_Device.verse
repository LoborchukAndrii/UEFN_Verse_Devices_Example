
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }


Gun_Shop_device := class(creative_device):

    @editable
    Bank : Bank_Device = Bank_Device{}

    @editable
    Shopkeeper : character_device = character_device{}

    @editable
    Guns : item_granter_device = item_granter_device{}

    ExoticIcon : []texture = array{
        Texture.Exotic.Assault_MusterScoped,
        Texture.Exotic.Assault_PastaRipper,
        Texture.Exotic.Athena_Bow,
        Texture.Exotic.Athena_SMG,
        Texture.Exotic.IceLauncher,
        Texture.Exotic.MarksmanRevolver,
        Texture.Exotic.Shotgun_Breach,
        Texture.Exotic.Shotgun_Stack,
        Texture.Exotic.SMG_MusterQuick_Athena,
        Texture.Exotic.TIconWeaponsDrunkenQuadLauncherWeapon,
        Texture.Exotic.WaffleTruck,
        Texture.Exotic.WaffleTruck_BoomSniper,
        Texture.Exotic.WaffleTruck_HopRockDualies,
        Texture.Exotic.WaffleTruck_Pistol,
        Texture.Exotic.WaffleTruck_Pistol_Tracking,
        Texture.Exotic.WaffleTruck_Sniper_DragonBreath,
        Texture.Exotic.WaffleTruck_Sniper_StormScou
    }

    MythicIcon : []texture = array{
        Texture.Mythic.mythicWID_Assault_Bone_Athena_Boss_1
        Texture.Mythic.mythicWID_Assault_Chrono_RedDotAR_Athena_UR_1
        Texture.Mythic.mythicWID_Assault_CoreAR_Athena_UR_1
        Texture.Mythic.mythicWID_Assault_FlipMag_Athena_UR_1
        Texture.Mythic.mythicWID_Assault_Heavy_Recoil_Athena_UR_1
        Texture.Mythic.mythicWID_Assault_LlamaRoaster_Boss_1
        
        Texture.Mythic.mythicWID_Assault_Paprika_DPS_Athena_HS_UR_Boss_1
        Texture.Mythic.mythicWID_Assault_Paprika_Heavy_Athena_HS_UR_Boss_1
        Texture.Mythic.mythicWID_Assault_Paprika_Infantry_Athena_HS_UR_Boss_1
        Texture.Mythic.mythicWID_Assault_PastaRipper_Athena_Boss_1
        Texture.Mythic.mythicWID_Assault_RedDotAR_Athena_UR_TheFoundation_1
        Texture.Mythic.mythicWID_Assault_RedDotBurstAR_Athena_UR_Slone_1
        Texture.Mythic.mythicWID_Assault_SunRose_Athena_UR_1
        Texture.Mythic.mythicWID_Assault_Surgical_Thermal_Athena_UR_ThunderMeow_1
        Texture.Mythic.mythicWID_Boss_Adventure_AR_1
        Texture.Mythic.mythicWID_Boss_Adventure_AR_2
        
        Texture.Mythic.mythicWID_ChargeSMG_Athena_UR_1
        Texture.Mythic.mythicWID_Crossbow_MoonFlaxBoss__NitroQueen_Athena_UR_1
        Texture.Mythic.mythicWID_DMR_Athena_UR_1
        Texture.Mythic.mythicWID_DMR_Chrono_ToggleThermal_Athena_UR_1
        
        Texture.Mythic.mythicWID_Pistol_AutoHeavySuppressed_Athena_UR_Ore_T03_2
        Texture.Mythic.mythicWID_Pistol_Muster_Athena_UR_1
        
        Texture.Mythic.mythicWID_Shotgun_Auto_Paprika_Athena_UR_Boss_1
        Texture.Mythic.mythicWID_Shotgun_AutoDrum_Athena_UR_Ore_T03_1
        Texture.Mythic.mythicWID_Shotgun_Bone_Athena_Boss_1
        Texture.Mythic.mythicWID_Shotgun_Break_Cerberus_Athena_UR_1
        Texture.Mythic.mythicWID_Shotgun_Charge_Athena_UR_Ore_T03_1
        Texture.Mythic.mythicWID_Shotgun_CoreBurst_Athena_UR_1
        Texture.Mythic.mythicWID_Shotgun_CoreDPS_Athena_UR_1
        Texture.Mythic.mythicWID_Shotgun_HopScotch_Athena_UR_MMO_1
        Texture.Mythic.mythicWID_Shotgun_Moonflax_Combat_Athena_UR_1
        Texture.Mythic.mythicWID_Shotgun_OverLoad_Athena_UR_1
        Texture.Mythic.mythicWID_Shotgun_Pump_Paprika_Athena_UR_Boss_1
        Texture.Mythic.mythicWID_Shotgun_RadicalPump_Athena_UR_1
        Texture.Mythic.mythicWID_Shotgun_TwoShot_Pump_Athena_UR_1
        Texture.Mythic.mythicWID_SMG_CoreSMG_Athena_UR_1
        Texture.Mythic.mythicWID_SMG_Paprika_DPS_Athena_HS_UR_Boss_1
        Texture.Mythic.mythicWID_SMG_Recoil_Athena_UR_1
        Texture.Mythic.mythicWID_SMG_RedDot_Athena_UR_ThorneBoss_2
        Texture.Mythic.mythicWID_SMG_SunRose_DPS_Athena_UR_Boss_1
        Texture.Mythic.mythicWID_Sniper_ExplosiveRepeater_Athena_UR_1
        Texture.Mythic.mythicWID_Sniper_Heavy_Athena_UR_Ore_T03_2
        Texture.Mythic.mythicWID_SunRose_ModularDMR_Athena_UR_2
        Texture.Mythic.mythicWID_SunRose_Pistol_HandCannon_Athena_UR_1
        Texture.Mythic.mythicWID_ToadJam_Assault_CombatAR_1
        Texture.Mythic.mythicWID_ToadJam_LightPistol_2
        Texture.Mythic.mythicWID_ToadJam_Shotgun_Lever_1
        Texture.Mythic.mythicWID_VampireStake_Shotgun_UR_1
        
    }

    @editable
    IsExotic :logic = false

    @editable
    RowLength : int = 12

    @editable
    Price : float = 1.0

    var PlayerButtons : [player][]button_loud = map{}

    var PlayerWidget : [player]widget = map{}

    OnBegin<override>()<suspends>:void=

        Shopkeeper.InteractedWithEvent.Subscribe(OnStartShopping)

    OnStartShopping(Agent:agent) : void =
        if:
            Player := player[Agent]
            PlayerUI := GetPlayerUI[Player]
        then:
            if:
                not PlayerWidget[Player]
            then:
                NewUI := GenerateShopUI(Player)
                logic:
                    set PlayerWidget[Player] = NewUI

            NewSlot := player_ui_slot{InputMode:= ui_input_mode.All}

            HasMoney:= Bank.PlayerHasEnoughMoney(Player, Price)
            for(Button : PlayerButtons[Player]):
                Button.SetEnabled(HasMoney)

            if:
                ShowWidget := PlayerWidget[Player]
            then:
                PlayerUI.AddWidget(ShowWidget, NewSlot)
            
    GenerateShopUI(Player:player): widget=
        MoneyText := text_block:
            DefaultText := GetText(ToTruncatedString(Bank.GetPlayerMoney(Player), 2))
            DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}

        Money_Slot := stack_box_slot:
            HorizontalAlignment := horizontal_alignment.Center
            Padding := margin{Bottom := 10.0, Top := 10.0}
            Widget:= overlay:
                Slots:= array:
                    overlay_slot:
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Widget:= texture_block:
                            # DefaultDesiredSize := vector2{X:= 200.0, Y:= 50.0}
                            DefaultImage:= Texture.Store.PowerUp_back

                    overlay_slot: 
                        Padding := margin{Left := 10.0, Right := 10.0}
                        Widget:= stack_box:
                            Orientation := orientation.Horizontal
                            Slots:= array:
                                stack_box_slot:
                                    Widget:= texture_block:
                                        DefaultDesiredSize := vector2{X:= 50.0, Y:= 50.0}
                                        DefaultImage := Texture.Overlay.Dollar_icon

                                stack_box_slot:
                                    HorizontalAlignment := horizontal_alignment.Left
                                    Widget:= MoneyText

        Bank.MoneyNotifier.Subscribe(Player, MoneyText)

        ExitButton := button_loud:
            DefaultText := GetText("X")

        ExitButton.OnClick().Subscribe(Exit)

        Exit_Slot := stack_box_slot:
            HorizontalAlignment := horizontal_alignment.Fill
            VerticalAlignment := vertical_alignment.Center
            Padding := margin{Left := 20.0, Right := 20.0}
            Widget:= ExitButton

        Vertical_Frame := stack_box:
            Orientation := orientation.Vertical
            Slots:= array:
                stack_box_slot:
                    # Padding := margin{Bottom := 10.0}
                    Widget:= overlay:
                        Slots:= array:
                            overlay_slot:
                                Widget:= texture_block:
                                    DefaultDesiredSize := vector2{X:= 200.0, Y:= 50.0}
                                    DefaultImage:= Texture.Store.PowerUp_back

                            overlay_slot:
                                Widget:= text_block:
                                    DefaultJustification := text_justification.Center
                                    DefaultText := GetText("Gun shop")
                                    DefaultTextColor := color{R:= 1.0, B:= 1.0, G:= 1.0}


        Main_Overlay := overlay:
            Slots:= array:
                overlay_slot:
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Widget:= texture_block:
                        DefaultImage := Texture.Store.Background

                overlay_slot:
                    Padding := margin{Right := 25.0, Bottom := 10.0, Top := 10.0, Left := 25.0}
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Center
                    Widget:= Vertical_Frame
                                        
        var Main_Frame : stack_box = stack_box:
            Orientation := orientation.Horizontal

        var CurrentIcons : []texture = MythicIcon
        if (IsExotic = true):
            set CurrentIcons = ExoticIcon
            
        for(Index := 0..CurrentIcons.Length):
            if (Mod[Index, RowLength] = 0 and Index <> 0 or Index = CurrentIcons.Length):
                Main_Frame_Slot := stack_box_slot:
                    Padding := margin{Top := 5.0}
                    Widget:= Main_Frame
                Vertical_Frame.AddWidget(Main_Frame_Slot)
                set Main_Frame = stack_box:
                    Orientation := orientation.Horizontal
                
            GunCard:= stack_box_slot:
                Padding := margin{Right := 10.0, Left := 10.0}
                Widget:= GenerateGunCard(Player, Index, CurrentIcons)
            Main_Frame.AddWidget(GunCard)
            
        Vertical_Frame.AddWidget(Money_Slot)
        Vertical_Frame.AddWidget(Exit_Slot)               

        return Main_Overlay

    GenerateGunCard(Player:player, Index:int, Icons:[]texture): widget=
        var CardItem : texture = Texture.Store.Background

        if:
            Icon := Icons[Index]
            set CardItem = Icon

        BuyButton := button_loud:
            DefaultText := GetText(ToTruncatedString(Price, 2))
        
        BuyButton.OnClick().Subscribe(BuyGun)

        BuyButton.SetEnabled(Bank.PlayerHasEnoughMoney(Player, Price))

        if:
            set PlayerButtons[Player] += array{BuyButton}
        else:
            logic:
                set PlayerButtons[Player] = array{BuyButton}
            
        
        return stack_box:
            Orientation := orientation.Vertical
            Slots:= array:
                stack_box_slot:
                    Widget:= texture_block:
                        DefaultDesiredSize := vector2{X:= 100.0, Y:= 100.0}
                        DefaultImage := CardItem

                stack_box_slot:
                    Padding := margin{Top := 10.0}
                    Widget:= BuyButton

    BuyGun(Info:widget_message):void =
        if:
            Index := PlayerButtons[Info.Player].Find[Info.Source]
        then:
            Bank.RemovePlayerMoney(Info.Player, Price)
            Guns.GrantItemIndex(Info.Player, Index)
            HasMoney:= Bank.PlayerHasEnoughMoney(Info.Player, Price)
            for(Button : PlayerButtons[Info.Player]):
                Button.SetEnabled(HasMoney)
