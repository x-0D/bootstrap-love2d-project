return {
  m_Name = "event_1016",
  Id = 1016,
  NameLocKey = "events/ecological_disbalanc",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 160,
  Repetition = 0,
  EffectsEveryRound = {
    Type = 2,
    TargetResource = {
      Production = 0,
      People = 2,
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
      "nature_conservation",
      "carbon_storing_pasture",
      "ecosystem_restoration",
      "amazon_reforestation",
      "agroecology"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 4,
    People = 0,
    Science = 6
  },
  EmissionThreshold = 0,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 25,
  Repeatable = 1,
  Sprite = {
    fileID = 0
  },
  ScriptFile = "EventCardSO.cs"
}