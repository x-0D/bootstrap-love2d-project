return {
  m_Name = "card_461",
  Id = 461,
  NameLocKey = "card_name/atmospheric_aerosols",
  UpgradeCostBase = {
    Production = 7,
    People = 5,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -100,
  UpgradesTo = {
    "radiative_cooling",
    "space_mirrors",
    "reflective_sheets"
  },
  UpgradeTime = 90,
  Speed = 0.25,
  Emissions = -2,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 4,
  EventChancesOnCreated = {
    {
      EventId = "widespread_cancer",
      Chance = 0.02
    },
    {
      EventId = "unpredictable_weather",
      Chance = 0.02
    },
    {
      EventId = "regional_clima",
      Chance = 0.02
    },
    {
      EventId = "ecological_disbalanc",
      Chance = 0.02
    },
    {
      EventId = "agricultural_calamity",
      Chance = 0.02
    },
    {
      EventId = "science_refusal",
      Chance = 0.02
    },
    {
      EventId = "tragic_harvest",
      Chance = 0.02
    },
    {
      EventId = "local_protests",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_SC_atmospheric_aerosols_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "atmospheric_aerosols",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_SC_atmospheric_aerosols_IL_BW.png"
}