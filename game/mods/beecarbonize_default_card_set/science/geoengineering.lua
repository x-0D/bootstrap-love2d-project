return {
  m_Name = "card_415",
  Id = 415,
  NameLocKey = "card_name/geoengineering",
  UpgradeCostBase = {
    Production = 4,
    People = 0,
    Science = 3
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 2,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "artificial_ecosystems",
    "meteo_models",
    "atmospheric_aerosols"
  },
  UpgradeTime = 100,
  Speed = 0.25,
  Emissions = 1,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "widespread_cancer",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_geoengineering_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "geoengineering",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_geoengineering_IL_BW.png"
}