return {
  m_Name = "event_1015",
  Id = 1015,
  NameLocKey = "events/regional_clima",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 50,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "local_protests",
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
    TargetCardID = "natural_hedges",
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
    Production = 4,
    People = 0,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 500,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.01,
  ChanceStartSeason = 30,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}