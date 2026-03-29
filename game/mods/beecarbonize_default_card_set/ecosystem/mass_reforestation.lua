return {
  m_Name = "card_314",
  Id = 314,
  NameLocKey = "card_name/mass_reforestation",
  UpgradeCostBase = {
    Production = 9,
    People = 0,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 3,
    Science = 0
  },
  UpgradeBonusEmissions = -30,
  UpgradesTo = nil,
  UpgradeTime = 150,
  Speed = 0.25,
  Emissions = -3,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "wild_deforestation",
      Chance = -0.01
    },
    {
      EventId = "end_of_pollutant_regulation",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_mass_reforestation_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "mass_reforestation",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_mass_reforestation_IL_BW.png"
}