return {
  m_Name = "card_114",
  Id = 114,
  NameLocKey = "card_name/gas_power_plants",
  UpgradeCostBase = {
    Production = 3,
    People = 0,
    Science = 2
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 30,
  Speed = 0.4,
  Emissions = 2,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 2,
  EventChancesOnCreated = {
    {
      EventId = "gas_shortage",
      Chance = 0.01
    },
    {
      EventId = "energy_shortage",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_gas_power_plants_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "gas_power_plants",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_gas_power_plants_IL_BW.png"
}