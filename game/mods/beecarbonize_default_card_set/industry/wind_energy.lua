return {
  m_Name = "card_105",
  Id = 105,
  NameLocKey = "card_name/wind_energy",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
    Science = 1
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 1,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "home_wind_farms",
    "offshore_wind_farms"
  },
  UpgradeTime = 40,
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
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_wind_energy_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "wind_energy",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_wind_energy_IL_BW.png"
}