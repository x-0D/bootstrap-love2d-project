return {
  m_Name = "card_303",
  Id = 303,
  NameLocKey = "card_name/kelp_plantation",
  UpgradeCostBase = {
    Production = 4,
    People = 5,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -30,
  UpgradesTo = nil,
  UpgradeTime = 120,
  Speed = 0.25,
  Emissions = -1,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "kelp_forest_breakdown",
      Chance = -0.02
    },
    {
      EventId = "mega_drought",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "EC_kelp_plantation_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "kelp_plantation",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "EC_kelp_plantation_IL_BW.png"
}