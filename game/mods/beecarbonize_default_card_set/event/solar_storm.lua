return {
  m_Name = "event_1011",
  Id = 1011,
  NameLocKey = "events/solar_storm",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 70,
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
      Production = 5,
      People = 0,
      Science = 5
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
      "research centers",
      "massive_automation",
      "vr_worlds",
      "vr_fully_utopia"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 0,
    People = 0,
    Science = 4
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0.02,
  ChanceStartSeason = 60,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}