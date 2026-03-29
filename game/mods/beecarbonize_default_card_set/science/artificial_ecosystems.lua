return {
  m_Name = "card_416",
  Id = 416,
  NameLocKey = "card_name/artificial_ecosystems",
  UpgradeCostBase = {
    Production = 0,
    People = 3,
    Science = 7
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "coastal_bariers",
    "artificial_corals"
  },
  UpgradeTime = 110,
  Speed = 0.25,
  Emissions = -1,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "Peatland_drying",
      Chance = -0.01
    },
    {
      EventId = "clima_apathy",
      Chance = -0.01
    },
    {
      EventId = "biodiversity_breakdown",
      Chance = -0.01
    },
    {
      EventId = "last_elephants",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_SC_artificial_ecosystems_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "artificial_ecosystems",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_SC_artificial_ecosystems_IL_BW.png"
}