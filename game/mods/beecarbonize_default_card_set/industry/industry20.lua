return {
  m_Name = "card_100",
  Id = 100,
  NameLocKey = "card_name/industry20",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "Non_renewable_energy",
    "renewable_energy",
    "nuclear_energy"
  },
  UpgradeTime = 30,
  Speed = 1,
  Emissions = 20,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "enviro_refusal",
      Chance = 0.02
    },
    {
      EventId = "oil_rig_explosion",
      Chance = 0.02
    },
    {
      EventId = "end_of_pollutant_regulation",
      Chance = 0.02
    }
  },
  OnDestroyedEvents = {
    "crumbling_infrastructure",
    "poverty_protests"
  },
  Sprite = "karta_IN_industry20_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "industry20",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_industry20_IL_BW.png"
}