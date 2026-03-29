return {
  m_Name = "card_401",
  Id = 401,
  NameLocKey = "card_name/emission_clean",
  UpgradeCostBase = {
    Production = 3,
    People = 0,
    Science = 2
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 1,
    Science = 0
  },
  UpgradeBonusEmissions = -30,
  UpgradesTo = {
    "carbon_capture",
    "smog_sucking_vacuum"
  },
  UpgradeTime = 70,
  Speed = 0.1,
  Emissions = -2,
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
  Sprite = "science_atlas_karta_SC_emission_clean_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "emission_clean",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_emission_clean_IL_BW.png"
}