return {
  m_Name = "event_983",
  Id = 983,
  NameLocKey = "events/lack_rare_metals",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 300,
  Repetition = 1,
  EffectsEveryRound = {
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterDuration = {
    Type = 3,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = {
      "sahara_solar_field",
      "solar_energy_2.0",
      "advanced_robotics",
      "space_mirrors"
    },
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "deep_sea_mining",
    Amount = 0
  },
  EffectInsolvency = {
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EventSolutions = {
    Production = 10,
    People = 0,
    Science = 10
  },
  EmissionThreshold = 0,
  EmissionsMin = 900,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 80,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}