return {
  m_Name = "card_307",
  Id = 307,
  NameLocKey = "card_name/agroforestry",
  UpgradeCostBase = {
    Production = 0,
    People = 3,
    Science = 2
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 1
  },
  UpgradeBonusEmissions = -50,
  UpgradesTo = "carbon_storing_pasture",
  UpgradeTime = 90,
  Speed = 0.1,
  Emissions = 0,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 1,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "wild_deforestation",
      Chance = -0.01
    },
    {
      EventId = "amazon_forest_collapse",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_agroforestry_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "agroforestry",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_agroforestry_IL_BW.png"
}