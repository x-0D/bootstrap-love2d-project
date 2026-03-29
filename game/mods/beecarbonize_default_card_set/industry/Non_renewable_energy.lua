return {
  m_Name = "card_111",
  Id = 111,
  NameLocKey = "card_name/Non_renewable_energy",
  UpgradeCostBase = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "more_coal",
    "gas_power_plants",
    "massive_extraction"
  },
  UpgradeTime = 30,
  Speed = 0.4,
  Emissions = 7,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "oil_rig_explosion",
      Chance = 0.03
    },
    {
      EventId = "end_of_pollutant_regulation",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "IN_Non_renewable_energy_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "Non_renewable_energy",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "IN_Non_renewable_energy_IL_BW.png"
}