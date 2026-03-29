return {
  m_Name = "event_971",
  Id = 971,
  NameLocKey = "events/mega_drought",
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
      "renewable_energy",
      "nuclear_energy",
      "nuclear2_0",
      "safer_nuclear"
    },
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 1,
    TargetResource = {
      Production = 0,
      People = 4,
      Science = 0
    },
    TargetCardID = nil,
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
    Science = 7
  },
  EmissionThreshold = 0,
  EmissionsMin = 1000,
  EmissionsMax = 2500,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}