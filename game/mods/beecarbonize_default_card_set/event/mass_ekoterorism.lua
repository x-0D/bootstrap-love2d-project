return {
  m_Name = "event_986",
  Id = 986,
  NameLocKey = "events/mass_ekoterorism",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 140,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 1,
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
      Production = 3,
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
      "industry20",
      "more_coal",
      "fracking",
      "Non_renewable_energy",
      "massive_extraction",
      "deep_sea_mining"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 0,
    People = 6,
    Science = 3
  },
  EmissionThreshold = 0,
  EmissionsMin = 900,
  EmissionsMax = 3000,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}