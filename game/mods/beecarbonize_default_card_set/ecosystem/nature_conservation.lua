return {
  m_Name = "card_300",
  Id = 300,
  NameLocKey = "card_name/nature_conservation",
  UpgradeCostBase = {
    Production = 2,
    People = 0,
    Science = 1
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 0,
    Science = 0
  },
  UpgradeBonusEmissions = -10,
  UpgradesTo = {
    "agroecology",
    "local_solutions",
    "ecosystem_restoration"
  },
  UpgradeTime = 50,
  Speed = 0.1,
  Emissions = 0,
  SectorType = 3,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {},
  OnDestroyedEvents = nil,
  Sprite = "karta_EC_protected_landscapes_IL_BW.png",
  ColorSchemeIndex = 2,
  IllustrationKey = "protected_landscapes",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_EC_protected_landscapes_IL_BW.png"
}