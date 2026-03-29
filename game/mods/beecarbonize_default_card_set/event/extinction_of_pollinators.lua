return {
  m_Name = "event_962",
  Id = 962,
  NameLocKey = "events/extinction_of_pollinators",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 100,
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
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "robobees",
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
      "agroecology",
      "agroforestry",
      "ecosystem_restoration"
    },
    Amount = 0
  },
  EventSolutions = {
    Production = 4,
    People = 0,
    Science = 4
  },
  EmissionThreshold = 900,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = "EventIllustrations_EVENT_CARD_extinction_of_pollinators_HR.png",
  ScriptFile = "EventCardSO.cs",
  SpriteFile = "EventIllustrations_EVENT_CARD_extinction_of_pollinators_HR.png"
}