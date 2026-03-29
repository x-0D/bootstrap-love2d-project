return {
  m_Name = "card_451",
  Id = 451,
  NameLocKey = "card_name/vr_worlds",
  UpgradeCostBase = {
    Production = 3,
    People = 0,
    Science = 6
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 2,
    Science = 0
  },
  UpgradeBonusEmissions = -30,
  UpgradesTo = "vr_fully_utopia",
  UpgradeTime = 60,
  Speed = 0.25,
  Emissions = 1,
  SectorType = 4,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "local_protests",
      Chance = -0.01
    },
    {
      EventId = "science_refusal",
      Chance = -0.01
    },
    {
      EventId = "local_hunger_revolutions",
      Chance = -0.01
    },
    {
      EventId = "anti_clima_movement",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "science_atlas_karta_SC_vr-worlds_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "vr_worlds",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "science_atlas_karta_SC_vr-worlds_IL_BW.png"
}