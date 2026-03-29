return {
  m_Name = "card_454",
  Id = 454,
  NameLocKey = "card_name/human_engineering",
  UpgradeCostBase = {
    Production = 5,
    People = 0,
    Science = 4
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 2,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "modified_babies",
    "vr_worlds"
  },
  UpgradeTime = 60,
  Speed = 0.25,
  Emissions = 0,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "super_bacteria",
      Chance = -0.01
    },
    {
      EventId = "ai_gone_rogue",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_SC_ human_engineering_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "human_engineering",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_SC_ human_engineering_IL_BW.png"
}