return {
  m_Name = "card_101",
  Id = 101,
  NameLocKey = "card_name/more_coal",
  UpgradeCostBase = {
    Production = 1,
    People = 1,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 2,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = "cleaner_fossil",
  UpgradeTime = 25,
  Speed = 0.4,
  Emissions = 10,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "energy_shortage",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = {
    "financial_crisis",
    "crumbling_infrastructure",
    "poverty_protests"
  },
  Sprite = "science_atlas_karta_SC_more_coal_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "more_coal",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_more_coal_IL_BW.png"
}