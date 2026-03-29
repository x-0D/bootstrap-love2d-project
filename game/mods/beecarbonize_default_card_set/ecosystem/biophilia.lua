return {
  m_Name = "card_328",
  Id = 328,
  NameLocKey = "card_name/biophilia",
  UpgradeCostBase = {
    Production = 8,
    People = 0,
    Science = 8
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 2,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -60,
  UpgradesTo = "ecosystems_of_22th_century",
  UpgradeTime = 190,
  Speed = 0.25,
  Emissions = -5,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 1,
  UpgradeRandom = 0,
  Rarity = 4,
  EventChancesOnCreated = {
    {
      EventId = "enviro_refusal",
      Chance = -0.02
    },
    {
      EventId = "anti_clima_movement",
      Chance = -0.02
    },
    {
      EventId = "desinformation_campaign",
      Chance = -0.02
    },
    {
      EventId = "desinformation_campaign",
      Chance = -0.02
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_biophilia_IL_BW.png",
  ColorSchemeIndex = 1,
  IllustrationKey = "biophilia",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_biophilia_IL_BW.png"
}