return {
  m_Name = "card_104",
  Id = 104,
  NameLocKey = "card_name/renewable_energy",
  UpgradeCostBase = {
    Production = 0,
    People = 1,
    Science = 1
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "wind_energy",
    "solar_energy",
    "hydroenergy"
  },
  UpgradeTime = 25,
  Speed = 0.25,
  Emissions = 1,
  SectorType = 1,
  Categories = 524288,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "desinformation_campaign",
      Chance = 0.01
    },
    {
      EventId = "windless_dark_winter",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_renewable_energy_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "renewable_energy",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_renewable_energy_IL_BW.png"
}