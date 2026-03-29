return {
  m_Name = "card_413",
  Id = 413,
  NameLocKey = "card_name/lab_food",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
    Science = 6
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 70,
  Speed = 0.25,
  Emissions = 2,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "tragic_harvest",
      Chance = -0.02
    },
    {
      EventId = "climate_refugees",
      Chance = -0.01
    },
    {
      EventId = "world_hunger",
      Chance = -0.02
    },
    {
      EventId = "widespread_cancer",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_lab_food_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "lab_food",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_lab_food_IL_BW.png"
}