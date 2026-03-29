return {
  m_Name = "card_123",
  Id = 123,
  NameLocKey = "card_name/modular_nuclear_reactor",
  UpgradeCostBase = {
    Production = 0,
    People = 10,
    Science = 10
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 3,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 300,
  Speed = 0.6,
  Emissions = 1,
  SectorType = 1,
  Categories = "0D000000",
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 0,
  EventChancesOnCreated = {
    {
      EventId = "nuclear_spill",
      Chance = 0.02
    },
    {
      EventId = "energy_shortage",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_modular_nuclear_reactor_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "modular_nuclear_reactor",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_modular_nuclear_reactor_IL_BW.png"
}