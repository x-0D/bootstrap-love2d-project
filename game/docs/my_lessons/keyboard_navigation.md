# Клавиатурная навигация в FlexLove

В этом документе описаны паттерны и рекомендации по реализации клавиатурной навигации в проектах на базе FlexLove.

## Основные концепции

Библиотека FlexLove ориентирована на взаимодействие с помощью мыши, поэтому для полноценной поддержки клавиатуры необходимо реализовать дополнительную логику в сцене.

### 1. Отслеживание состояния (State Management)

Для реализации навигации необходимо хранить в объекте сцены следующие параметры:
- `selectedIndex`: индекс текущего выбранного элемента.
- `isPressed`: логический флаг, указывающий на нажатие клавиши подтверждения (Enter/Space).

### 2. Синхронизация визуальных состояний

Для того чтобы Renderer отобразил изменения, необходимо вручную обновлять внутренние состояния элементов:

```lua
function scene:updateButtonStates()
  for i, button in ipairs(self.buttons) do
    local isSelected = (i == self.selectedIndex)
    local state = isSelected and (self.isPressed and "pressed" or "hover") or "normal"
    
    -- Обновление состояния рендерера и менеджера тем
    if button._renderer then button._renderer:setThemeState(state) end
    if button._themeManager then button._themeManager:setState(state) end
    
    -- Ручное обновление свойств, если они не поддерживаются темой автоматически
    button.textColor = isSelected and (self.isPressed and COLORS.PRESSED or COLORS.HOVER) or COLORS.NORMAL
    
    -- Синхронизация флагов для корректного поведения при переключении на мышь
    button._hovered = isSelected
  end
end
```

### 3. Обработка ввода (Input Handling)

Используйте колбэки `keypressed` и `keyreleased` для изменения индекса и состояния нажатия:

```lua
function scene:keypressed(key)
  if key == "up" then
    self.selectedIndex = self.selectedIndex - 1
    -- Логика зацикливания...
  elseif key == "down" then
    self.selectedIndex = self.selectedIndex + 1
  elseif key == "return" or key == "space" then
    self.isPressed = true
  end
  self:updateButtonStates()
end
```

### 4. Совместная работа с мышью

Для бесшовного переключения между клавиатурой и мышью необходимо:
1. В `onEvent` элементов обновлять `selectedIndex` при событии `hover`.
2. В `updateButtonStates` проверять, не наведена ли мышь на элемент, прежде чем сбрасывать его состояние.

## Пример реализации

Актуальный пример реализации можно найти в файле [main_menu_screen.lua](file:///Users/appleroot/projects/bootstrap-love2d-project/game/scenes/main_menu_screen.lua).
