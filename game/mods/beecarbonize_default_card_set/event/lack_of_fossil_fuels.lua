return {
  m_Name = "event_982",
  Id = 982,
  NameLocKey = "events/lack_of_fossil_fuels",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 100,
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
      "more_coal",
      "cleaner_fossil"
    },
    Amount = 0
  },
  EffectAfterSolved = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "massive_extraction",
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
    Production = 6,
    People = 5,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 70,
  Repeatable = 0,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}