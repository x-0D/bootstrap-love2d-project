return {
  m_Name = "card_204",
  Id = 204,
  NameLocKey = "card_name/loss_damage",
  UpgradeCostBase = {
    Production = 6,
    People = 0,
    Science = 0
  },
  UpgradeCostMultiples = 0,
  UpgradeBonus = {
    Production = 0,
    People = 3,
    Science = 0
  },
  UpgradeBonusEmissions = 0,
  UpgradesTo = nil,
  UpgradeTime = 50,
  Speed = 0.25,
  Emissions = -3,
  SectorType = 2,
  Categories = nil,
  ReplacedByUpgrade = 0,
  UpgradeRandom = 0,
  Rarity = 1,
  EventChancesOnCreated = {
    {
      EventId = "locl_conflicts",
      Chance = -0.01
    },
    {
      EventId = "local_hunger_revolutions",
      Chance = -0.01
    },
    {
      EventId = "climate_refugees",
      Chance = -0.01
    }
  },
  OnDestroyedEvents = nil,
  Sprite = "karta_PL_loss_damage_IL_BW.png",
  ColorSchemeIndex = 3,
  IllustrationKey = "loss_damage",
  ScriptFile = "UpgradeCardSO.cs",
  SpriteFile = "karta_PL_loss_damage_IL_BW.png"
}