return {
  m_Name = "event_1012",
  Id = 1012,
  NameLocKey = "events/aging_demography",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 220,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 6,
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
    Type = 0,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EffectInsolvency = {
    Type = 2,
    TargetResource = {
      Production = 6,
      People = 0,
      Science = 0
    },
    TargetCardID = nil,
    Amount = 0
  },
  EventSolutions = {
    Production = 4,
    People = 4,
    Science = 4
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 70,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}