return {
  m_Name = "event_954",
  Id = 954,
  NameLocKey = "events/unpredictable_weather",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 100,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 2,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterDuration = {
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "meteo_models",
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
    Production = 2,
    People = 0,
    Science = 5
  },
  EmissionThreshold = 0,
  EmissionsMin = 900,
  EmissionsMax = 1900,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}