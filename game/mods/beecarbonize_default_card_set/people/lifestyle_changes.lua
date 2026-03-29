return {
  m_Name = "card_237",
  Id = 237,
  NameLocKey = "card_name/lifestyle_changes",
  UpgradeCostBase = {
    Production = 3,
    People = 0,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 2,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "voluntary_modesty",
    "circular_economy",
    "loss_damage"
  },
  UpgradeTime = 40,
  Speed = -0.25,
  Emissions = -2,
  SectorType = 2,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "no_to_consumerism",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = "social_withdrawal",
  Sprite = "science_atlas_karta_SC_lifestyle_changes_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "lifestyle_changes",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_lifestyle_changes_IL_BW.png"
}