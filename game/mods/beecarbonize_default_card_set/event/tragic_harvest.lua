return {
  m_Name = "event_951",
  Id = 951,
  NameLocKey = "events/tragic_harvest",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 180,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 2,
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
    Type = 1,
    TargetResource = {
      Production = 2,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectInsolvency = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "world_hunger",
    Amount = 0
  },
  EventSolutions = {
    Production = 1,
    People = 0,
    Science = 3
  },
  EmissionThreshold = 0,
  EmissionsMin = 500,
  EmissionsMax = 2500,
  FlavourText = nil,
  InitialChance = 0.01,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}