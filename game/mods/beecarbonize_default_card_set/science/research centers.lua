return {
  m_Name = "card_404",
  Id = 404,
  NameLocKey = "card_name/research centers",
  UpgradeCostBase = {
    Production = 3,
    People = 0,
    Science = 3
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = {
    "advanced_robotics",
    "geoengineering"
  },
  UpgradeTime = 80,
  Speed = 0.25,
  Emissions = 0,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 2,
  EventChancesOnCreated = {
    {
      EventId = "clima_apathy",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_SC_research_centers_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "research centers",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_SC_research_centers_IL_BW.png"
}