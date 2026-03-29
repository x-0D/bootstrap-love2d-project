return {
  m_Name = "event_1029",
  Id = 1029,
  NameLocKey = "events/private_space_travels",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 90,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 5,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 70
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
    TargetCardID = "voluntary_modesty",
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
    Production = 0,
    People = 10,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 1000,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 70,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}