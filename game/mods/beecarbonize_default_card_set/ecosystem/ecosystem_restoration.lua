return {
  m_Name = "card_322",
  Id = 322,
  NameLocKey = "card_name/ecosystem_restoration",
  UpgradeCostBase = {
    Production = 3,
    People = 2,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -50,
  UpgradesTo = {
    "protected_landscapes",
    "ecosystem_prioritization",
    "world_climate_fund"
  },
  UpgradeTime = 70,
  Speed = 0.1,
  Emissions = -1,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "monocultur_prohibition",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_ecocentrism_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "ecocentrism",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_ecocentrism_IL_BW.png"
}