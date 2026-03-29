return {
  m_Name = "event_1017",
  Id = 1017,
  NameLocKey = "events/agricultural_calamity",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 180,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "local_hunger_revolutions",
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
    Production = 5,
    People = 5,
    Science = 0
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 20,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}