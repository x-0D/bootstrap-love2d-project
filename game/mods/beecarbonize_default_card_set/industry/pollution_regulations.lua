return {
  m_Name = "card_115",
  Id = 115,
  NameLocKey = "card_name/pollution_regulations",
  UpgradeCostBase = {
    Production = 2,
    People = 3,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 2
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 60,
  Speed = -0.25,
  Emissions = -4,
  SectorType = 1,
  Categories = 1048576,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 2,
  EventChancesOnCreated = {
    {
      EventId = "oil_rig_explosion",
      Chance = -0.04
    },
    {
      EventId = "end_of_pollutant_regulation",
      Chance = -0.05
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_ pollution_regulations_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "pollution_regulations",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_ pollution_regulations_IL_BW.png"
}