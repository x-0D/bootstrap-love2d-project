return {
  m_Name = "card_428",
  Id = 428,
  NameLocKey = "card_name/controlled_weather",
  UpgradeCostBase = {
    Production = 0,
    People = 0,
    Science = 10
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 2,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 160,
  Speed = 0.4,
  Emissions = 1,
  SectorType = 1,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 2,
  EventChancesOnCreated = {
    {
      EventId = "end_of_pollutant_regulation",
      Chance = -0.02
    },
    {
      EventId = "unpredictable_weather",
      Chance = -0.02
    },
    {
      EventId = "local_hunger_revolutions",
      Chance = -0.01
    },
    {
      EventId = "deadly_heatwaves",
      Chance = -0.01
    },
    {
      EventId = "widespread_cancer",
      Chance = 0.01
    },
    {
      EventId = "crop_failure",
      Chance = -0.01
    },
    {
      EventId = "windless_dark_winter",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_IN_controlled_weather_IL_BW.png",
  ColorSchemeIndex = 0,
  IllustrationKey = "controlled_weather",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_IN_controlled_weather_IL_BW.png"
}