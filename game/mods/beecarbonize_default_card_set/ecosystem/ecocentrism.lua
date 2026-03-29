return {
  m_Name = "card_327",
  Id = 327,
  NameLocKey = "card_name/ecocentrism",
  UpgradeCostBase = {
    Production = 2,
    People = 4,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 1,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -40,
  UpgradesTo = "biophilia",
  UpgradeTime = 110,
  Speed = 0.1,
  Emissions = -2,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 1,
  UpgradeRandom = 0,
  Rarity = 4,
  EventChancesOnCreated = {
    {
      EventId = "enviro_refusal",
      Chance = -0.01
    },
    {
      EventId = "anti_clima_movement",
      Chance = -0.01
    },
    {
      EventId = "desinformation_campaign",
      Chance = -0.01
    },
    {
      EventId = "desinformation_campaign",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_ecosystem_prioritization_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "ecosystem_prioritization",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_ecosystem_prioritization_IL_BW.png"
}