return {
  m_Name = "event_1010",
  Id = 1010,
  NameLocKey = "events/pandemic",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 45,
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
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 10,
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
    Type = 3,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = {
      "lifestyle_changes",
      "decentralised_economy",
      "doughnut_economy"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 0,
    People = 1,
    Science = 5
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 80,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}