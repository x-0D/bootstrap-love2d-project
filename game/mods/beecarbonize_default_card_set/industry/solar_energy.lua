return {
  m_Name = "card_106",
  Id = 106,
  NameLocKey = "card_name/solar_energy",
  UpgradeCostBase = {
    Production = 2,
    People = 1,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 1
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "sahara_solar_field",
    "solar_energy_2.0"
  },
  UpgradeTime = 30,
  Speed = 0.25,
  Emissions = 1,
  SectorType = 1,
  Categories = 524288,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "windless_dark_winter",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_solar_energy_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "solar_energy",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_solar_energy_IL_BW.png"
}