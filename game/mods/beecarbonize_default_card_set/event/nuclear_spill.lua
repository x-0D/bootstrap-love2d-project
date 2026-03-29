return {
  m_Name = "event_975",
  Id = 975,
  NameLocKey = "events/nuclear_spill",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 60,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 1,
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
      People = 2,
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
      "nuclear_energy",
      "nuclear2_0"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 3,
    People = 0,
    Science = 2
  },
  EmissionThreshold = 0,
  EmissionsMin = 200,
  EmissionsMax = 1700,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}