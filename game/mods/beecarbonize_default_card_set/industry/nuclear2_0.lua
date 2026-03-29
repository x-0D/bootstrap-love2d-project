return {
  m_Name = "card_108",
  Id = 108,
  NameLocKey = "card_name/nuclear2_0",
  UpgradeCostBase = {
    Production = 10,
    People = 0,
    Science = 10
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 2
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = "modular_nuclear_reactor",
  UpgradeTime = 340,
  Speed = 0.6,
  Emissions = 1,
  SectorType = 1,
  Categories = "0D000000",
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "nuclear_catastrophe",
      Chance = 0.04
    },
    {
      EventId = "lack_nuclear_fuel",
      Chance = 0.02
    },
    {
      EventId = "nuclear_spill",
      Chance = 0.02
    },
    {
      EventId = "energy_shortage",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = "nuclear_cleanup",
  Sprite = "science_atlas_karta_SC_nuclear_energy_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "nuclear_energy",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_nuclear_energy_IL_BW.png"
}