return {
  m_Name = "event_1101",
  Id = 1101,
  NameLocKey = "events/100_year_floods",
  EventSubsector = 1,
  Rarity = 1,
  Duration = 90,
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
      Production = 1,
      People = 3,
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
    TargetCardID = "ecosystem_engineers",
    Amount = 0
  },
  EffectInsolvency = {
    Type = 4,
    TargetResource = {
      Production = 0,
      People = 0,
      Science = 0
    },
    TargetCardID = "local_protests",
    Amount = 0
  },
  EventSolutions = {
    Production = 3,
    People = 2,
    Science = 0
  },
  EmissionThreshold = 250,
  EmissionsMin = 0,
  EmissionsMax = 999999,
  FlavourText = nil,
  InitialChance = 0,
  ChanceStartSeason = 0,
  Repeatable = 0,
  Sprite = "EventIllustrations_EVENT_CARD_100_year_floods_HR.png",
  ScriptFile = "EventCardSO.cs",
  SpriteFile = "EventIllustrations_EVENT_CARD_100_year_floods_HR.png"
}