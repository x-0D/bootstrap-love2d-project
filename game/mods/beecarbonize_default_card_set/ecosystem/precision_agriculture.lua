return {
  m_Name = "card_411",
  Id = 411,
  NameLocKey = "card_name/precision_agriculture",
  UpgradeCostBase = {
    Production = 4,
    People = 0,
    Science = 4
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 1,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "resistant_crops",
    "lab_food",
    "hydropony"
  },
  UpgradeTime = 80,
  Speed = 0.4,
  Emissions = 1,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "crop_failure",
      Chance = -0.01
    },
    {
      EventId = "tragic_harvest",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_precision_agriculture_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "precision_agriculture",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_precision_agriculture_IL_BW.png"
}