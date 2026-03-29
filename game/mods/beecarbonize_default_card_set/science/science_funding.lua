return {
  m_Name = "card_400",
  Id = 400,
  NameLocKey = "card_name/science_funding",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
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
    "emission_clean",
    "incubator",
    "research centers"
  },
  UpgradeTime = 50,
  Speed = 0.6,
  Emissions = 0,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "fringe_research",
      Chance = 0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_ science_funding_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "science_funding",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_ science_funding_IL_BW.png"
}