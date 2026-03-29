return {
  m_Name = "event_932",
  Id = 932,
  NameLocKey = "events/slowdown_gulf_stream",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 320,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 4,
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
    Type = 1,
    TargetResource = {
      Production = 0,
      People = 6,
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
    TargetCardID = "ecosystem_breakdown",
    Amount = 0
  },
  EventSolutions = {
    Production = 0,
    People = 0,
    Science = 15
  },
  EmissionThreshold = 0,
  EmissionsMin = 1600,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}