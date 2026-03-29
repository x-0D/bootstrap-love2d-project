return {
  m_Name = "card_424",
  Id = 424,
  NameLocKey = "card_name/meteo_models",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
    Science = 5
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 1,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "controlled_weather",
    "precision_agriculture"
  },
  UpgradeTime = 80,
  Speed = 0.4,
  Emissions = 0,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 2,
  EventChancesOnCreated = {
    {
      EventId = "end_of_pollutant_regulation",
      Chance = -0.01
    },
    {
      EventId = "unpredictable_weather",
      Chance = -0.01
    },
    {
      EventId = "crop_failure",
      Chance = -0.01
    },
    {
      EventId = "windless_dark_winter",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_meteo_models_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "meteo_models",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_meteo_models_IL_BW.png"
}